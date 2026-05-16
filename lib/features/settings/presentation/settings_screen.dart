import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../shared/services/history_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final accent = ref.watch(accentColorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          _SectionLabel('APPEARANCE'),
          _Card(
            isDark: isDark,
            children: [
              _ThemeRow(
                themeMode: themeMode,
                onChanged: (m) =>
                    ref.read(themeModeProvider.notifier).setThemeMode(m),
              ),
              _Divider(isDark: isDark),
              _AccentRow(
                current: accent,
                onChanged: (c) =>
                    ref.read(accentColorProvider.notifier).setColor(c),
              ),
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
                    HistoryService().clearAll();
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

class _ThemeRow extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  const _ThemeRow({required this.themeMode, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.palette_rounded, size: 20, color: Color(0xFF8E8E93)),
          const SizedBox(width: 12),
          Text('Theme', style: GoogleFonts.inter(fontSize: 15)),
          const Spacer(),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode, size: 16),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.phone_android, size: 16),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode, size: 16),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (s) => onChanged(s.first),
            style: ButtonStyle(visualDensity: VisualDensity.compact),
          ),
        ],
      ),
    );
  }
}

class _AccentRow extends StatelessWidget {
  final Color current;
  final ValueChanged<Color> onChanged;
  const _AccentRow({required this.current, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(
            Icons.color_lens_rounded,
            size: 20,
            color: Color(0xFF8E8E93),
          ),
          const SizedBox(width: 12),
          Text('Accent Color', style: GoogleFonts.inter(fontSize: 15)),
          const Spacer(),
          ...ColorTokens.accentPresets.map(
            (c) => Padding(
              padding: const EdgeInsets.only(left: 6),
              child: GestureDetector(
                onTap: () => onChanged(c),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: current == c ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
