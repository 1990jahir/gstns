import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_field_item.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_support_box.dart';

/// Dedicated Profile Page composed of clean, reusable modular widgets.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringManager.profileDetailsTitle,
          style: getBoldStyle(
            fontSize: FontManager.s18,
            color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileHeaderCard(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: ProfileFieldItem(label: StringManager.profileNameLabel, value: StringManager.profileNameValue)),
                      const SizedBox(width: 16),
                      Expanded(child: ProfileFieldItem(label: StringManager.profileIdLabel, value: StringManager.profileIdValue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: ProfileFieldItem(label: StringManager.profileCompanyLabel, value: StringManager.profileCompanyValue)),
                      const SizedBox(width: 16),
                      Expanded(child: ProfileFieldItem(label: StringManager.profileGstinLabel, value: StringManager.profileGstinValue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: ProfileFieldItem(label: StringManager.profileEmailLabel, value: StringManager.profileEmailValue)),
                      const SizedBox(width: 16),
                      Expanded(child: ProfileFieldItem(label: StringManager.profileContactLabel, value: StringManager.profileContactValue)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: ProfileFieldItem(label: StringManager.profilePanLabel, value: StringManager.profilePanValue)),
                      const SizedBox(width: 16),
                      Expanded(child: ProfileFieldItem(label: StringManager.profileWalletLabel, value: StringManager.profileWalletValue)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProfileSupportBox(),
                  const SizedBox(height: 24),
                  const ProfileActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
