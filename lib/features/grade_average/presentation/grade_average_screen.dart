import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/app_drawer.dart';

class GradeAverageScreen extends StatefulWidget {
  const GradeAverageScreen({super.key});
  @override
  State<GradeAverageScreen> createState() => _GradeAverageScreenState();
}

class _GradeAverageScreenState extends State<GradeAverageScreen> {
  final _subjects = <_Sub>[];
  static const _grades = {
    'O': 10.0,
    'A+': 9.0,
    'A': 8.0,
    'B+': 7.0,
    'B': 6.0,
    'C': 5.0,
    'D': 4.0,
    'F': 0.0,
  };

  double get _gpa {
    if (_subjects.isEmpty) return 0;
    double tp = 0, tc = 0;
    for (final s in _subjects) {
      tp += s.gp * s.cr;
      tc += s.cr;
    }
    return tc > 0 ? tp / tc : 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('GPA'),
        leading: Builder(
          builder: (c) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(c).openDrawer(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _subjects.add(_Sub())),
        backgroundColor: accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    size: 48,
                    color: Color(0xFF8E8E93),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap + to add a subject',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GPA',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            _gpa.toStringAsFixed(2),
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ..._subjects.asMap().entries.map((e) {
                  final i = e.key;
                  final s = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Dismissible(
                      key: ValueKey('$i${s.g}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => setState(() => _subjects.removeAt(i)),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3A3A3C)
                                : const Color(0xFFC6C6C8),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Subject ${i + 1}',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${s.cr} cr',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 32,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _grades.entries.map((g) {
                                  final sel = s.g == g.key;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        s.g = g.key;
                                        s.gp = g.value;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: sel
                                              ? const Color(0xFF34C759)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: sel
                                                ? const Color(0xFF34C759)
                                                : const Color(0xFF8E8E93),
                                          ),
                                        ),
                                        child: Text(
                                          g.key,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: sel
                                                ? Colors.white
                                                : const Color(0xFF8E8E93),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

class _Sub {
  int cr;
  String g;
  double gp;
  _Sub() : cr = 3, g = 'O', gp = 10;
}
