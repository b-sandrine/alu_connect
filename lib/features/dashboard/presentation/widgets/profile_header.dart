import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../messaging/presentation/providers/messaging_providers.dart';
import '../../../profiles/presentation/providers/student_profile_providers.dart';

/// Avatar + time-aware greeting + name/degree + notification badge, used at
/// the top of the student dashboard Home tab. Tapping the avatar switches
/// to the Profile tab; tapping the bell switches to Messages (the app's
/// current stand-in for a notification center — see [unreadConversationCountProvider]).
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({
    super.key,
    required this.userId,
    required this.userName,
    required this.onAvatarTap,
    required this.onNotificationsTap,
  });

  final String userId;
  final String userName;
  final VoidCallback onAvatarTap;
  final VoidCallback onNotificationsTap;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(studentProfileByOwnerProvider(userId));
    final unreadCount = ref.watch(unreadConversationCountProvider(userId));

    return profileAsync.when(
      data: (profile) => _Content(
        greeting: _greeting,
        userName: userName,
        photoUrl: profile?.photoUrl,
        degree: profile?.degree,
        unreadCount: unreadCount,
        onAvatarTap: onAvatarTap,
        onNotificationsTap: onNotificationsTap,
      ),
      loading: () => Row(
        children: [
          const CircleAvatar(radius: 26, child: SizedBox.shrink()),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.box(context: context, width: 140, height: 14),
                const SizedBox(height: 6),
                AppSkeleton.box(context: context, width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
      error: (_, __) => _Content(
        greeting: _greeting,
        userName: userName,
        photoUrl: null,
        degree: null,
        unreadCount: unreadCount,
        onAvatarTap: onAvatarTap,
        onNotificationsTap: onNotificationsTap,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.greeting,
    required this.userName,
    required this.photoUrl,
    required this.degree,
    required this.unreadCount,
    required this.onAvatarTap,
    required this.onNotificationsTap,
  });

  final String greeting;
  final String userName;
  final String? photoUrl;
  final String? degree;
  final int unreadCount;
  final VoidCallback onAvatarTap;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final firstName = userName.split(' ').first;

    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: colors.studentAccent.withValues(alpha: 0.15),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? Text(
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: colors.studentAccent),
                  )
                : null,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $firstName!',
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (degree != null && degree!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  degree!,
                  style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Badge(
          isLabelVisible: unreadCount > 0,
          label: Text('$unreadCount'),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: onNotificationsTap,
          ),
        ),
      ],
    );
  }
}
