import 'package:employee_app/screens/home/widgets/quick_action_tile.dart';
import 'package:employee_app/screens/home/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  final List<QuickAction> actions;
  final ValueChanged<QuickAction>? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: kQuickActionTileHeight,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return QuickActionTile(
              action: action,
              showShadow: true,
              onTap: () {
                HapticFeedback.selectionClick();
                onActionTap?.call(action);
              },
            );
          },
        ),
      ],
    );
  }
}
