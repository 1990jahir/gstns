import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/res/font_manager.dart';
import '../../../../core/res/string_manager.dart';
import '../../../../core/res/styles_manager.dart';
import '../widgets/profile_actions.dart';
import '../widgets/profile_field_tile.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_support_box.dart';

/// Dedicated Profile Page redesigned to match the latest modern fintech/tax app UI trends.
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), // Bottom padding for floating navbar
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  ProfileHeaderCard(),
                  SizedBox(height: 24),
                  ProfileSectionCard(
                    title: 'Personal Information',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.person_outline_rounded,
                        label: StringManager.profileNameLabel,
                        value: StringManager.profileNameValue,
                        color: Colors.blue,
                      ),
                      ProfileFieldTile(
                        icon: Icons.badge_outlined,
                        label: StringManager.profileIdLabel,
                        value: StringManager.profileIdValue,
                        color: Colors.purple,
                      ),
                      ProfileFieldTile(
                        icon: Icons.email_outlined,
                        label: StringManager.profileEmailLabel,
                        value: StringManager.profileEmailValue,
                        color: Colors.teal,
                      ),
                      ProfileFieldTile(
                        icon: Icons.phone_outlined,
                        label: StringManager.profileContactLabel,
                        value: StringManager.profileContactValue,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ProfileSectionCard(
                    title: 'Business & Tax Details',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.business_rounded,
                        label: StringManager.profileCompanyLabel,
                        value: StringManager.profileCompanyValue,
                        color: Colors.orange,
                      ),
                      ProfileFieldTile(
                        icon: Icons.receipt_long_outlined,
                        label: StringManager.profileGstinLabel,
                        value: StringManager.profileGstinValue,
                        color: Colors.indigo,
                      ),
                      ProfileFieldTile(
                        icon: Icons.credit_card_rounded,
                        label: StringManager.profilePanLabel,
                        value: StringManager.profilePanValue,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ProfileSectionCard(
                    title: 'Financial Overview',
                    children: [
                      ProfileFieldTile(
                        icon: Icons.account_balance_wallet_outlined,
                        label: StringManager.profileWalletLabel,
                        value: StringManager.profileWalletValue,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ProfileSupportBox(),
                  SizedBox(height: 24),
                  ProfileActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
