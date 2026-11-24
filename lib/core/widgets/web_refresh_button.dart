import 'package:flutter/material.dart';
import '../res/string_manager.dart';

/// Blue Refresh button matching the exact web portal screenshot:
/// Placed on the top right of the AppBar across all management screens.
class WebRefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;

  const WebRefreshButton({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ElevatedButton.icon(
        onPressed: onRefresh,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // Official GSTSOF web blue color
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        icon: const Icon(Icons.sync_rounded, size: 16, color: Colors.white),
        label: const Text(
          StringManager.refresh,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}

