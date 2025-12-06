import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/admin/providers/user_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userManagementProvider.notifier).loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userManagementProvider);
    final notifier = ref.read(userManagementProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search users',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    notifier.setFilter(
                      state.filter.copyWith(search: value, page: 1),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Filter by Role: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: state.filter.role ?? 'all',
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All Roles'),
                        ),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                        DropdownMenuItem(
                          value: 'seller',
                          child: Text('Seller'),
                        ),
                        DropdownMenuItem(value: 'host', child: Text('Host')),
                        DropdownMenuItem(
                          value: 'professional',
                          child: Text('Professional'),
                        ),
                      ],
                      onChanged: (value) {
                        notifier.setFilter(
                          state.filter.copyWith(
                            role: value == 'all' ? null : value,
                            page: 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (state.isLoading && state.data == null)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(child: Center(child: Text('Error: ${state.error}')))
          else if (state.data?.data.isEmpty ?? true)
            const Expanded(child: Center(child: Text('No users found')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.data!.data.length,
                itemBuilder: (context, index) {
                  final user = state.data!.data[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(
                      '${user.email}\nRoles: ${user.roles.join(", ")}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showEditRoleDialog(context, user, notifier),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _confirmDelete(context, user, notifier),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    User user,
    UserManagementNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await notifier.deleteUser(user.id.toString());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete user: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(
    BuildContext context,
    User user,
    UserManagementNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => _EditRoleDialog(user: user, notifier: notifier),
    );
  }
}

class _EditRoleDialog extends StatefulWidget {
  final User user;
  final UserManagementNotifier notifier;

  const _EditRoleDialog({required this.user, required this.notifier});

  @override
  State<_EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<_EditRoleDialog> {
  late List<String> _selectedRoles;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRoles = List.from(widget.user.roles);
  }

  @override
  Widget build(BuildContext context) {
    final allRoles = ['buyer', 'seller', 'host', 'professional', 'admin'];

    return AlertDialog(
      title: Text('Edit Roles for ${widget.user.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: allRoles.map((role) {
            return CheckboxListTile(
              title: Text(role.toUpperCase()),
              value: _selectedRoles.contains(role),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedRoles.add(role);
                  } else {
                    _selectedRoles.remove(role);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await widget.notifier.updateUserRole(
                      widget.user.id.toString(),
                      _selectedRoles,
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update roles: $e')),
                    );
                    setState(() => _isLoading = false);
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
