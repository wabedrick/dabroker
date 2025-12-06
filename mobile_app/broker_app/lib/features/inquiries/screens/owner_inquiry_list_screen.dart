import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/features/inquiries/providers/owner_inquiry_provider.dart';
import 'package:broker_app/features/inquiries/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OwnerInquiryListScreen extends ConsumerStatefulWidget {
  const OwnerInquiryListScreen({super.key});

  @override
  ConsumerState<OwnerInquiryListScreen> createState() =>
      _OwnerInquiryListScreenState();
}

class _OwnerInquiryListScreenState
    extends ConsumerState<OwnerInquiryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(ownerInquiryListProvider.notifier).loadInquiries(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerInquiryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Property Inquiries')),
      body: state.when(
        data: (inquiries) {
          if (inquiries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No inquiries yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: inquiries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final inquiry = inquiries[index];
              final lastMessage = inquiry.messages.isNotEmpty
                  ? inquiry.messages.last
                  : null;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          inquiryId: inquiry.publicId,
                          title: inquiry.sender?.name ?? 'Inquiry',
                        ),
                      ),
                    );
                  },
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          inquiry.property?.title ?? 'Unknown Property',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          DateFormat('MMM d, h:mm a').format(lastMessage.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'From: ${inquiry.sender?.name ?? 'Unknown User'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (lastMessage != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          lastMessage.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
