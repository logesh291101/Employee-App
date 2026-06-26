import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/edit_profile_screen.dart';
import 'package:employee_app/screens/profile/settings_screen.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/screens/profile/widgets/profile_detail_tile.dart';
import 'package:employee_app/screens/profile/widgets/profile_header_card.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  String _fullName = 'Logesh';
  String _employeeId = 'VEDA-1024';
  String _email = 'logesh@vedagroup.com';
  String _mobile = '+91 98765 43210';
  String _designation = 'Jr.Flutter Developer';
  String _department = 'Information Technology';
  String _reportingManager = 'John Smith';
  String _officeLocation = 'Bangalore Headquarters';
  String _loginType = 'Employee Login';
  String _employeeStatus = 'Active';
  String _joiningDate = '15 March 2022';
  String _employeeCode = 'EMP-2022-1024';
  String _workLocation = 'Bangalore, India';
  String _address = '42, MG Road, Bangalore';

  int get _completionPercent {
    final fields = [
      _fullName,
      _email,
      _mobile,
      _officeLocation,
      _address,
      _designation,
      _department,
    ];
    final filled = fields.where((f) => f.trim().isNotEmpty).length;
    return ((filled / fields.length) * 100).round();
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    showAuthSnackBar(context, 'Profile refreshed');
  }

  Future<void> _onEditProfile() async {
    HapticFeedback.lightImpact();
    final result = await Navigator.of(context).push<Map<String, String>>(
      authPageRoute(
        EditProfileScreen(
          fullName: _fullName,
          email: _email,
          mobile: _mobile,
          officeLocation: _officeLocation,
          address: _address,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _fullName = result['fullName'] ?? _fullName;
      _email = result['email'] ?? _email;
      _mobile = result['mobile'] ?? _mobile;
      _officeLocation = result['officeLocation'] ?? _officeLocation;
      _address = result['address'] ?? _address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'My Profile',
        onSettingsTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).push(authPageRoute(const SettingsScreen()));
        },
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x88FFFFFF),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.black,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileHeaderCard(
                      name: _fullName,
                      employeeId: _employeeId,
                      email: _email,
                      mobile: _mobile,
                      completionPercent: _completionPercent,
                    ),
                    const SizedBox(height: 28),
                    const ProfileSectionTitle(title: 'Employee Details'),
                    ProfileDetailTile(
                      icon: Icons.work_outline,
                      label: 'Designation',
                      value: _designation,
                    ),
                    ProfileDetailTile(
                      icon: Icons.apartment_outlined,
                      label: 'Department',
                      value: _department,
                    ),
                    ProfileDetailTile(
                      icon: Icons.supervisor_account_outlined,
                      label: 'Reporting Manager',
                      value: _reportingManager,
                    ),
                    ProfileDetailTile(
                      icon: Icons.location_on_outlined,
                      label: 'Office Location',
                      value: _officeLocation,
                    ),
                    ProfileDetailTile(
                      icon: Icons.login_rounded,
                      label: 'Login Type',
                      value: _loginType,
                    ),
                    const SizedBox(height: 20),
                    const ProfileSectionTitle(title: 'Additional Information'),
                    ProfileDetailTile(
                      icon: Icons.verified_outlined,
                      label: 'Employee Status',
                      value: _employeeStatus,
                    ),
                    ProfileDetailTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Joining Date',
                      value: _joiningDate,
                    ),
                    ProfileDetailTile(
                      icon: Icons.qr_code_2_outlined,
                      label: 'Employee Code',
                      value: _employeeCode,
                    ),
                    ProfileDetailTile(
                      icon: Icons.map_outlined,
                      label: 'Work Location',
                      value: _workLocation,
                    ),
                    const SizedBox(height: 28),
                    GradientButton(
                      label: 'Edit Profile',
                      onPressed: _onEditProfile,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
