import 'package:broker_app/data/models/inquiry.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';

import 'package:broker_app/features/inquiries/repositories/inquiry_repository.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? bookingId;
  final String? inquiryId;
  final String title;

  const ChatScreen({
    super.key,
    this.bookingId,
    this.inquiryId,
    required this.title,
  }) : assert(
         bookingId != null || inquiryId != null,
         'Either bookingId or inquiryId must be provided',
       );

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _pollingTimer;
  bool _isLoading = true;
  bool _isSending = false;
  Inquiry? _inquiry;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInquiry();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isSending && mounted) {
        _loadInquiry(isPolling: true);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInquiry({bool isPolling = false}) async {
    try {
      if (!isPolling) {
        setState(() {
          _isLoading = true;
          _error = null;
        });
      }

      final Inquiry inquiry;
      if (widget.bookingId != null) {
        inquiry = await ref
            .read(inquiryRepositoryProvider)
            .getBookingInquiry(widget.bookingId!);
      } else {
        inquiry = await ref
            .read(inquiryRepositoryProvider)
            .getInquiry(widget.inquiryId!);
      }

      if (mounted) {
        final shouldScroll = _inquiry == null || inquiry.messages.length > _inquiry!.messages.length;
        setState(() {
          _inquiry = inquiry;
          _isLoading = false;
        });
        if (shouldScroll) {
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (mounted && !isPolling) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _inquiry == null) return;

    setState(() {
      _isSending = true;
    });

    try {
      final newMessage = await ref
          .read(inquiryRepositoryProvider)
          .sendMessage(_inquiry!.publicId, text);

      if (mounted) {
        setState(() {
          _inquiry!.messages.add(newMessage);
          _messageController.clear();
          _isSending = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $_error'),
                        ElevatedButton(
                          onPressed: _loadInquiry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _inquiry?.messages.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = _inquiry!.messages[index];
                      // Check if the message is from the current user
                      final currentUser = ref.read(authStateProvider).user;
                      final isMe = message.senderId == currentUser?.id;
                      final bubbleColor = isMe
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest;
                      final messageColor = isMe
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface;
                      final timeColor = isMe
                          ? colorScheme.onPrimary.withValues(alpha: 0.75)
                          : colorScheme.onSurfaceVariant;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(color: messageColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'MMM d, h:mm a',
                                ).format(message.createdAt),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: timeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: _isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.send, color: colorScheme.primary),
                        onPressed: _isSending ? null : _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
