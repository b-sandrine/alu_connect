import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/conversation_entity.dart';
import '../providers/messaging_providers.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _typingDebounce;
  bool _isTyping = false;
  String? _myUserId;
  int _lastMarkedMessageCount = -1;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingDebounce?.cancel();
    _clearTyping();
    super.dispose();
  }

  void _clearTyping() {
    final userId = _myUserId;
    if (!_isTyping || userId == null) return;
    _isTyping = false;
    ref.read(messagingControllerProvider.notifier).setTyping(
          conversationId: widget.conversationId,
          userId: userId,
          isTyping: false,
        );
  }

  void _onTextChanged(String value) {
    final userId = _myUserId;
    if (userId == null) return;
    if (!_isTyping) {
      _isTyping = true;
      ref.read(messagingControllerProvider.notifier).setTyping(
            conversationId: widget.conversationId,
            userId: userId,
            isTyping: true,
          );
    }
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(seconds: 3), _clearTyping);
  }

  Future<void> _send() async {
    final userId = _myUserId;
    final text = _textController.text.trim();
    if (text.isEmpty || userId == null) return;
    _textController.clear();
    _typingDebounce?.cancel();
    _clearTyping();
    await ref.read(messagingControllerProvider.notifier).sendMessage(
          conversationId: widget.conversationId,
          senderId: userId,
          text: text,
        );
  }

  Future<void> _pickImage() async {
    final userId = _myUserId;
    if (userId == null) return;
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null || !mounted) return;
    await ref.read(messagingControllerProvider.notifier).sendImageMessage(
          conversationId: widget.conversationId,
          senderId: userId,
          imageFile: File(picked.path),
        );
  }

  void _maybeMarkAsRead(int messageCount) {
    final userId = _myUserId;
    if (userId == null || messageCount == 0) return;
    if (messageCount == _lastMarkedMessageCount) return;
    _lastMarkedMessageCount = messageCount;
    ref
        .read(messagingControllerProvider.notifier)
        .markAsRead(conversationId: widget.conversationId, userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();
    _myUserId = user.id;

    final conversationAsync = ref.watch(conversationProvider(widget.conversationId));
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(
        title: conversationAsync.when(
          data: (conversation) {
            if (conversation == null) return const Text('Chat');
            return _ChatAppBarTitle(conversation: conversation, myUserId: user.id);
          },
          loading: () => const Text('Chat'),
          error: (_, __) => const Text('Chat'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                _maybeMarkAsRead(messages.length);
                if (messages.isEmpty) {
                  return Center(
                    child: Text('Say hello 👋', style: AppTextStyles.bodyMedium),
                  );
                }
                final conversation = conversationAsync.valueOrNull;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMine = message.senderId == user.id;
                    final isRead = conversation != null &&
                        isMine &&
                        conversation.isReadByOther(user.id, message.sentAt);
                    return MessageBubble(message: message, isMine: isMine, isRead: isRead);
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorView(message: e.toString()),
            ),
          ),
          conversationAsync.maybeWhen(
            data: (conversation) {
              if (conversation == null || !conversation.isOtherTyping(user.id)) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${conversation.otherParticipantName(user.id)} is typing…',
                    style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          _ChatInputBar(
            controller: _textController,
            onChanged: _onTextChanged,
            onSend: _send,
            onPickImage: _pickImage,
          ),
        ],
      ),
    );
  }
}

class _ChatAppBarTitle extends StatelessWidget {
  const _ChatAppBarTitle({required this.conversation, required this.myUserId});

  final ConversationEntity conversation;
  final String myUserId;

  @override
  Widget build(BuildContext context) {
    final otherId = conversation.otherParticipantId(myUserId);
    final otherName = conversation.otherParticipantName(myUserId);

    return Consumer(
      builder: (context, ref, _) {
        final otherUser = ref.watch(userByIdProvider(otherId)).valueOrNull;
        final subtitle = otherUser == null
            ? null
            : otherUser.isOnline
                ? 'Online'
                : otherUser.lastActiveAt != null
                    ? 'Last seen ${DateFormat.MMMd().add_jm().format(otherUser.lastActiveAt!)}'
                    : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(otherName, style: AppTextStyles.titleMedium),
            if (subtitle != null)
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: otherUser!.isOnline ? AppColors.success : AppColors.textHint,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.onPickImage,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: onPickImage,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Message…',
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
