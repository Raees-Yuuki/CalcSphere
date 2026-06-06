// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/services/history_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          _SectionLabel('APPEARANCE'),
          _Card(
            isDark: isDark,
            children: [
              _ThemeNavRow(isDark: isDark, onTap: () => context.push('/theme')),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel('DATA'),
          _Card(
            isDark: isDark,
            children: [
              _ActionRow(
                icon: Icons.delete_outline_rounded,
                label: 'Clear All History',
                color: const Color(0xFFFF3B30),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Clear History?'),
                      content: const Text(
                        'This will delete all calculation history.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Color(0xFFFF3B30)),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    HistoryService().clearAll('');
                    if (context.mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('History cleared')),
                      );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel('ABOUT'),
          _Card(
            isDark: isDark,
            children: [
              _InfoRow(label: 'Version', value: '1.0.0'),
              _Divider(isDark: isDark),
              _InfoRow(label: 'Developer', value: 'CalcSphere Team'),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF8E8E93),
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _Card({required this.isDark, required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
        width: 0.5,
      ),
    ),
    child: Column(children: children),
  );
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 52),
    child: Container(
      height: 0.5,
      color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
    ),
  );
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, size: 20, color: color),
    title: Text(label, style: GoogleFonts.inter(fontSize: 15, color: color)),
    onTap: onTap,
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label, style: GoogleFonts.inter(fontSize: 15)),
    trailing: Text(
      value,
      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8E8E93)),
    ),
  );
}

class _ThemeNavRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ThemeNavRow({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final iconBgColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE5E5EA);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.palette_outlined,
          size: 20,
          color: textColor.withOpacity(0.8),
        ),
      ),
      title: Text(
        'Theme',
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        'Personalize the look and make it yours',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textColor.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDark ? const Color(0xFF5C5C5E) : const Color(0xFFC6C6C8),
      ),
      onTap: onTap,
    );
  }
}
