import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/hierarchy/hierarchy_screen.dart';
import 'package:employee_app/screens/home/add_post_screen.dart';
import 'package:employee_app/screens/support/support_screen.dart';
import 'package:employee_app/screens/timesheet/add_timesheet_screen.dart';
import 'package:employee_app/screens/timesheet/timesheet_history_screen.dart';
import 'package:employee_app/screens/home/widgets/attendance_status_card.dart';
import 'package:employee_app/screens/home/widgets/dashboard_bottom_nav.dart';
import 'package:employee_app/screens/home/widgets/home_app_bar.dart';
import 'package:employee_app/screens/home/widgets/quick_actions_section.dart';
import 'package:employee_app/screens/home/widgets/quick_actions_sheet.dart';
import 'package:employee_app/screens/home/widgets/social_feed_card.dart';
import 'package:employee_app/screens/profile/profile_screen.dart';
import 'package:employee_app/screens/attendance/attendance_dashboard_screen.dart';
import 'package:employee_app/screens/work_tracking/work_tracking_dashboard_screen.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  bool _isRefreshing = false;

  static const _employeeName = 'Logesh K';

  static const _quickActions = [
    QuickAction(label: 'Add Timesheet', icon: Icons.add_chart_outlined),
    QuickAction(label: 'Timesheet History', icon: Icons.history_rounded),
    QuickAction(label: 'Hierarchy', icon: Icons.account_tree_outlined),
    QuickAction(label: 'Support', icon: Icons.support_agent_outlined),
  ];

  List<Map<String, dynamic>> _feedPosts = _seedFeedPosts();

  static List<Map<String, dynamic>> _seedFeedPosts() {
    final now = DateTime.now();
    return [
      {
        'id': 'post-3',
        'authorName': 'HR Team',
        'caption':
            'Celebrating our quarterly achievements! Thank you to every team member for your dedication and hard work.',
        'tag': 'TeamSpirit',
        'imageAsset': 'assets/images/veda_group_logo.png',
        'mediaType': 'image',
        'createdAt': now.subtract(const Duration(hours: 2)),
        'likeCount': 48,
        'isLiked': false,
      },
      {
        'id': 'post-2',
        'authorName': 'Priya Sharma',
        'caption':
            'Highlights from yesterday\'s leadership workshop. Great insights on collaboration and growth.',
        'tag': 'Leadership',
        'imageAsset': 'assets/images/veda_group_logo.png',
        'mediaType': 'video',
        'createdAt': now.subtract(const Duration(hours: 8)),
        'likeCount': 31,
        'isLiked': true,
      },
      {
        'id': 'post-1',
        'authorName': 'Veda Group',
        'caption':
            'Welcome to the employee community feed. Share updates, moments, and milestones with your colleagues.',
        'tag': 'Welcome',
        'imageAsset': 'assets/images/veda_group_logo.png',
        'mediaType': 'image',
        'createdAt': now.subtract(const Duration(days: 1)),
        'likeCount': 112,
        'isLiked': false,
      },
    ];
  }

  List<Map<String, dynamic>> get _sortedFeedPosts {
    final posts = List<Map<String, dynamic>>.from(_feedPosts);
    posts.sort((a, b) {
      final aTime = a['createdAt'] as DateTime;
      final bTime = b['createdAt'] as DateTime;
      return bTime.compareTo(aTime);
    });
    return posts;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    showAuthSnackBar(context, 'Feed refreshed');
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentNavIndex = index);
  }

  void _onQuickActionTap(QuickAction action) {
    final label = action.label.trim();
    if (label == 'Add Timesheet') {
      Navigator.of(context).push(authPageRoute(const AddTimesheetScreen()));
    } else if (label == 'Timesheet History') {
      Navigator.of(context).push(
        authPageRoute(const TimesheetHistoryScreen()),
      );
    } else if (label == 'Hierarchy') {
      Navigator.of(context).push(authPageRoute(const HierarchyScreen()));
    } else if (label == 'Support') {
      Navigator.of(context).push(authPageRoute(const SupportScreen()));
    }
  }

  void _showQuickActionsMenu() {
    showQuickActionsSheet(
      context,
      actions: _quickActions,
      onActionTap: _onQuickActionTap,
    );
  }

  Future<void> _onAddPost() async {
    HapticFeedback.lightImpact();
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      authPageRoute(const AddPostScreen()),
    );

    if (result == null || !mounted) return;

    setState(() {
      _feedPosts.insert(0, {
        'id': 'post-${DateTime.now().millisecondsSinceEpoch}',
        'authorName': _employeeName,
        'caption': result['caption'] as String,
        'tag': result['tag'] as String? ?? '',
        'imageAsset': result['imageAsset'] as String?,
        'mediaType': result['mediaType'] as String,
        'createdAt': result['createdAt'] as DateTime,
        'likeCount': 0,
        'isLiked': false,
      });
    });
  }

  void _toggleLike(String postId) {
    setState(() {
      final index = _feedPosts.indexWhere((post) => post['id'] == postId);
      if (index == -1) return;

      final post = _feedPosts[index];
      final isLiked = post['isLiked'] as bool;
      final likeCount = post['likeCount'] as int;
      post['isLiked'] = !isLiked;
      post['likeCount'] = isLiked ? likeCount - 1 : likeCount + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBody: true,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeTab(),
          const AttendanceDashboardScreen(),
          const WorkTrackingDashboardScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHomeTab() {
    final posts = _sortedFeedPosts;

    return Stack(
      children: [
        const Positioned.fill(child: AuthBackground()),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: HomeAppBar(
            onMenuTap: _showQuickActionsMenu,
            onProfileTap: () => setState(() => _currentNavIndex = 3),
          ),
          body: RefreshIndicator(
            color: AppColors.black,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Good day, $_employeeName 👋',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AttendanceStatusCard(
                          status: AttendanceStatus.present,
                          officeLocation: 'Bangalore',
                          checkInTime: '09:02 AM',
                          checkOutTime: '--',
                          totalHours: 'In Progress',
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          label: 'Add Post',
                          height: 52,
                          onPressed: _onAddPost,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Social Feed',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                if (posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No posts yet. Tap Add Post to share something.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.grey700,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = posts[index];
                          final postId = post['id'] as String;

                          return SocialFeedCard(
                            authorName: post['authorName'] as String,
                            caption: post['caption'] as String,
                            tag: post['tag'] as String? ?? '',
                            timeLabel: _formatTimeAgo(
                              post['createdAt'] as DateTime,
                            ),
                            likeCount: post['likeCount'] as int,
                            isLiked: post['isLiked'] as bool,
                            isVideo: post['mediaType'] == 'video',
                            imageAsset: post['imageAsset'] as String?,
                            onLike: () => _toggleLike(postId),
                            onComment: () => showAuthSnackBar(
                              context,
                              'Comments — coming soon',
                            ),
                            onShare: () => showAuthSnackBar(
                              context,
                              'Share — coming soon',
                            ),
                          );
                        },
                        childCount: posts.length,
                      ),
                    ),
                  ),
                if (_isRefreshing)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 100, top: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
