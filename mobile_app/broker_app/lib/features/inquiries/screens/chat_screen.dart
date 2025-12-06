import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/data/models/inquiry.dart';
import 'package:broker_app/features/inquiries/repositories/inquiry_repository.dart';
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
  bool _isLoading = true;
  bool _isSending = false;
  Inquiry? _inquiry;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInquiry();
  }

  Future<void> _loadInquiry() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
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
        setState(() {
          _inquiry = inquiry;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                          // We need to know if the message is from current user.
                          // But we don't have current user ID easily accessible here without another provider.
                          // However, the API returns 'sender' object.
                          // We can check if sender.id matches current user id?
                          // Or we can just check alignment based on sender name vs title?
                          // Better: pass current user ID or check against a user provider.
                          // For now, let's assume we can get current user from a provider.
                          // Or just use a simple heuristic: if sender name == widget.title (the other person), it's received.
                          // Wait, widget.title is the OTHER person.
                          // So if message.sender.name == widget.title, it's received (left).
                          // Else it's sent (right).
                          
                          final isMe = message.sender?.name != widget.title;
                          
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
                                color: isMe
                                    ? AppColors.primaryBlue
                                    : Colors.grey[200],
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
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, h:mm a')
                                        .format(message.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54,
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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: AppColors.primaryBlue),
                    onPressed: _isSending ? null : _sendMessage,
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
