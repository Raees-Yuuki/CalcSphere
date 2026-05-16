import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_drawer.dart';

class WorldTimeScreen extends StatefulWidget {
  const WorldTimeScreen({super.key});
  @override
  State<WorldTimeScreen> createState() => _WorldTimeScreenState();
}

class _WorldTimeScreenState extends State<WorldTimeScreen> {
  final _cities = <_City>[];
  Timer? _timer;

  static const _available = [
    _City('New York', 'US', 'America/New_York', -4),
    _City('London', 'UK', 'Europe/London', 1),
    _City('Tokyo', 'Japan', 'Asia/Tokyo', 9),
    _City('Dubai', 'UAE', 'Asia/Dubai', 4),
    _City('Sydney', 'Australia', 'Australia/Sydney', 10),
    _City('Paris', 'France', 'Europe/Paris', 2),
    _City('Singapore', 'Singapore', 'Asia/Singapore', 8),
    _City('Mumbai', 'India', 'Asia/Kolkata', 5),
    _City('Berlin', 'Germany', 'Europe/Berlin', 2),
    _City('Toronto', 'Canada', 'America/Toronto', -4),
    _City('Hong Kong', 'China', 'Asia/Hong_Kong', 8),
    _City('Seoul', 'South Korea', 'Asia/Seoul', 9),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  DateTime _cityTime(_City c) => DateTime.now().toUtc().add(Duration(hours: c.offset));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('World Time'), leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => Scaffold.of(c).openDrawer()))),
      floatingActionButton: FloatingActionButton(onPressed: _addCity, backgroundColor: accent, child: const Icon(Icons.add, color: Colors.white)),
      body: _cities.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.public_rounded, size: 48, color: Color(0xFF8E8E93)), const SizedBox(height: 12), Text('Tap + to add a city', style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF8E8E93)))]))
          : ListView.builder(
              padding: const EdgeInsets.all(16), itemCount: _cities.length,
              itemBuilder: (_, i) {
                final c = _cities[i]; final t = _cityTime(c);
                return Dismissible(key: ValueKey(c.name), direction: DismissDirection.endToStart,
                  background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: const Color(0xFFFF3B30), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (_) => setState(() => _cities.removeAt(i)),
                  child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF2C2C2E) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8), width: 0.5)),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('${c.country} · ${DateFormat('EEE, MMM d').format(t)}', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E8E93))),
                      ])),
                      Text(DateFormat('HH:mm:ss').format(t), style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, fontFeatures: const [FontFeature.tabularFigures()])),
                    ])));
              }),
    );
  }

  void _addCity() async {
    final picked = await showModalBottomSheet<_City>(context: context,
      builder: (_) => ListView.builder(padding: const EdgeInsets.all(16), itemCount: _available.length,
        itemBuilder: (_, i) { final c = _available[i]; return ListTile(title: Text(c.name), subtitle: Text(c.country), trailing: Text('UTC${c.offset >= 0 ? '+' : ''}${c.offset}'), onTap: () => Navigator.pop(context, c)); }));
    if (picked != null && !_cities.any((c) => c.name == picked.name)) setState(() => _cities.add(picked));
  }
}

class _City {
  final String name, country, tz;
  final int offset;
  const _City(this.name, this.country, this.tz, this.offset);
}
