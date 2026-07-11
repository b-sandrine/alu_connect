import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/conversation_entity.dart';
import '../providers/messaging_providers.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final conversationsAsync = ref.watch(conversationsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) return const _EmptyState();
          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
            itemBuilder: (_, i) => _ConversationTile(
              conversation: conversations[i],
              myUserId: user.id,
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  const _ConversationTile({required this.conversation, required this.myUserId});

  final ConversationEntity conversation;
  final String myUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherId = conversation.otherParticipantId(myUserId);
    final otherName = conversation.otherParticipantName(myUserId);
    final otherPhotoUrl = conversation.otherParticipantPhotoUrl(myUserId);
    final isOnline =
        ref.watch(userByIdProvider(otherId)).valueOrNull?.isOnline ?? false;
    final hasUnread = conversation.hasUnread(myUserId);

    return ListTile(
      onTap: () => context.push('/messages/${conversation.id}'),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage:
                otherPhotoUrl != null ? CachedNetworkImageProvider(otherPhotoUrl) : null,
            child: otherPhotoUrl == null
                ? Text(
                    otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                    style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
                  )
                : null,
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(otherName, style: AppTextStyles.titleSmall),
      subtitle: Text(
        conversation.lastMessageText ?? 'Say hello 👋',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: hasUnread
            ? AppTextStyles.bodySmall
                .copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)
            : AppTextStyles.bodySmall,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (conversation.lastMessageAt != null)
            Text(
              DateFormat.MMMd().add_jm().format(conversation.lastMessageAt!),
              style: AppTextStyles.caption,
            ),
          if (hasUnread) ...[
            const SizedBox(height: 6),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('No conversations yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Message a startup from an opportunity to get started',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
