import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

/// User Page
/// Halaman dengan clean modern dark UI menggunakan reusable widgets

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Users', style: AppTextStyles.h2),
          Text('BLoC + Dio + Chucker Demo', style: AppTextStyles.caption),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
          onPressed: () {
            context.read<UserBloc>().add(const FetchUsersEvent());
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          color: AppColors.surface,
          onSelected: (value) {
            if (value == 'clear_cache') {
              context.read<UserBloc>().add(const ClearUserCacheEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                _buildSnackBar('Cache cleared!', AppColors.warning),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear_cache',
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Clear Cache', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSnackBar(
              'User "${state.user.name}" created!',
              AppColors.success,
            ),
          );
        } else if (state is UserDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSnackBar('User deleted successfully', AppColors.warning),
          );
        } else if (state is UserError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(_buildSnackBar(state.message, AppColors.error));
        }
      },
      builder: (context, state) {
        if (state is UserInitial) {
          context.read<UserBloc>().add(const LoadCachedUsersEvent());
          return const AppLoading(message: 'Initializing...');
        } else if (state is UserLoading) {
          return AppLoading(message: state.message ?? 'Loading...');
        } else if (state is UserLoaded) {
          return _buildUserList(context, state);
        } else if (state is UserError) {
          return _buildError(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserList(BuildContext context, UserLoaded state) {
    return Column(
      children: [
        if (state.isFromCache)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(Icons.cached, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Showing cached data${state.lastFetchTime != null ? ' • ${_formatTime(state.lastFetchTime!)}' : ''}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              context.read<UserBloc>().add(const FetchUsersEvent());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: state.users.isEmpty
                ? const AppEmptyState(
                    icon: Icons.people_outline,
                    title: 'No users found',
                    subtitle: 'Pull to refresh or add a new user',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(context, state.users[index], index);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user, int index) {
    return AppAnimatedCard(
      index: index,
      onTap: () => _showUserDetail(context, user),
      child: Row(
        children: [
          AppAvatar(text: user.name, colorIndex: index),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(user.email, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, UserError state) {
    return AppErrorState(
      message: state.message,
      onRetry: () {
        context.read<UserBloc>().add(const FetchUsersEvent());
      },
      secondaryAction:
          state.cachedUsers != null && state.cachedUsers!.isNotEmpty
          ? TextButton(
              onPressed: () {
                context.read<UserBloc>().add(const LoadCachedUsersEvent());
              },
              child: Text('Show cached data', style: AppTextStyles.link),
            )
          : null,
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateUserDialog(context),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text('Add User', style: AppTextStyles.buttonSmall),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Create New User', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(
                  'This will POST to JSONPlaceholder API',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: nameController,
                  label: 'Name',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: usernameController,
                  label: 'Username',
                  prefixIcon: Icons.alternate_email,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: emailController,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: phoneController,
                  label: 'Phone (optional)',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Create User',
                  width: double.infinity,
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        usernameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty) {
                      context.read<UserBloc>().add(
                        CreateUserEvent(
                          name: nameController.text,
                          username: usernameController.text,
                          email: emailController.text,
                          phone: phoneController.text.isNotEmpty
                              ? phoneController.text
                              : null,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildSnackBar(
                          'Please fill all required fields',
                          AppColors.warning,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUserDetail(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                AppAvatar(text: user.name, size: 80),
                const SizedBox(height: 16),
                Text(user.name, style: AppTextStyles.h3),
                Text(
                  '@${user.username}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.email_outlined, 'Email', user.email),
                if (user.phone != null)
                  _buildDetailRow(Icons.phone_outlined, 'Phone', user.phone!),
                if (user.website != null)
                  _buildDetailRow(Icons.language, 'Website', user.website!),
                if (user.company != null)
                  _buildDetailRow(
                    Icons.business,
                    'Company',
                    user.company!.name,
                  ),
                if (user.address != null)
                  _buildDetailRow(
                    Icons.location_on_outlined,
                    'Address',
                    '${user.address!.city}, ${user.address!.street}',
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          AppIconButton(icon: icon, backgroundColor: AppColors.background),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(
      content: Text(message, style: AppTextStyles.bodyMedium),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
