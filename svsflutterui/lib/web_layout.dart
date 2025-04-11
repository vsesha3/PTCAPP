import 'package:flutter/material.dart';
import 'package:svsflutterui/student_list_screen.dart';
import 'package:svsflutterui/login_screen.dart';

class PrimaryLayoutWeb extends StatefulWidget {
  const PrimaryLayoutWeb({super.key});

  @override
  State<PrimaryLayoutWeb> createState() => _PrimaryLayoutWebState();
}

class _PrimaryLayoutWebState extends State<PrimaryLayoutWeb> {
  bool _isDrawerExpanded = true;
  int _selectedIndex = 1; // Default to Student Profile

  final List<DrawerItem> _drawerItems = [
    DrawerItem(
      title: 'Staff Profile',
      icon: Icons.person,
      route: '/staff-profile',
    ),
    DrawerItem(
      title: 'Student Profile',
      icon: Icons.school,
      route: '/student-profile',
    ),
    DrawerItem(
      title: 'Admin Data',
      icon: Icons.admin_panel_settings,
      route: '/admin-data',
    ),
    DrawerItem(
      title: 'Reports',
      icon: Icons.assessment,
      route: '/reports',
    ),
    DrawerItem(
      title: 'Transaction',
      icon: Icons.payment,
      route: '/transaction',
    ),
  ];

  void _handleLogout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Navigate to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Drawer
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isDrawerExpanded ? 240 : 64,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Drawer Header
                Container(
                  height: 64,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isDrawerExpanded ? 16 : 0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: _isDrawerExpanded
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      if (_isDrawerExpanded) ...[
                        const SizedBox(width: 16),
                        Text(
                          'Grooming Tales',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                // Drawer Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = _drawerItems[index];
                      final isSelected = _selectedIndex == index;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          height: 48,
                          padding: EdgeInsets.symmetric(
                            horizontal: _isDrawerExpanded ? 16 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: _isDrawerExpanded
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              if (_isDrawerExpanded) ...[
                                const SizedBox(width: 16),
                                Text(
                                  item.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Drawer Toggle Button
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isDrawerExpanded = !_isDrawerExpanded;
                      });
                    },
                    icon: Icon(
                      _isDrawerExpanded
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _drawerItems[_selectedIndex].title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            offset: const Offset(0, 48),
                            onSelected: (value) {
                              if (value == 'logout') {
                                _handleLogout(context);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 8),
                                    Text('Profile'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(Icons.settings),
                                    SizedBox(width: 8),
                                    Text('Settings'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                            ],
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Text(
                                'A',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Content Area
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Staff Profile'));
      case 1:
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: StudentListScreen(),
        );
      case 2:
        return const Center(child: Text('Admin Data'));
      case 3:
        return const Center(child: Text('Reports'));
      case 4:
        return const Center(child: Text('Transaction'));
      default:
        return const Center(child: Text('Select a menu item'));
    }
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}
