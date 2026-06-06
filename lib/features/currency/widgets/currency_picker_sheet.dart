// lib/features/currency/widgets/currency_picker_sheet.dart
//
// FIX: Selection bug was because Navigator.pop() was called without
// passing the selected value back. Now we pass _selected via Navigator.pop()
// and the caller (currency_screen.dart) uses the returned value to call setCurrency.

import 'package:flutter/material.dart';
import 'package:calc_sphere/features/currency/controller/currency_controller.dart';
import 'package:calc_sphere/features/currency/widgets/currency_list_tile.dart';

class CurrencyPickerSheet extends StatefulWidget {
  final String title;
  final CurrencyController controller;
  final String initialSelected;

  const CurrencyPickerSheet({
    super.key,
    required this.title,
    required this.controller,
    required this.initialSelected,
  });

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  String _search = '';
  late String _selected;
  bool _editMode = false;
  final TextEditingController _searchCtrl = TextEditingController();

  static const Color _teal = Color(0xFF009688);

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        final list = widget.controller.sortedCurrencies(search: _search);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            ),
            child: Column(
              children: [
                // ── Teal title bar ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(color: _teal),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Search bar ──
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _search = v),
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFCCCCCC),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFE0E0E0)),

                // ── Currency list ──
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            'No currencies found',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Color(0xFFEEEEEE),
                          ),
                          itemBuilder: (_, i) {
                            final currency = list[i];
                            final isHidden = widget.controller.hiddenCurrencies
                                .contains(currency.code);

                            return CurrencyListTile(
                              currency: currency,
                              isSelected: _selected == currency.code,
                              editMode: _editMode,
                              isHidden: isHidden,
                              tealColor: _teal,
                              onTap: () {
                                setState(() => _selected = currency.code);
                                // ✅ FIX: Pop immediately with selected value
                                // so the screen can call setCurrency right away
                                Navigator.pop(context, currency.code);
                              },
                              onToggleHidden: () {
                                widget.controller.toggleHidden(currency.code);
                              },
                            );
                          },
                        ),
                ),

                const Divider(height: 1, color: Color(0xFFDDDDDD)),

                // ── Bottom bar: EDIT LIST | CANCEL ──
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // EDIT LIST / DONE button
                        Expanded(
                          child: TextButton(
                            onPressed: () =>
                                setState(() => _editMode = !_editMode),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              _editMode ? 'DONE' : 'EDIT LIST',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 24,
                          color: const Color(0xFFDDDDDD),
                        ),

                        // CANCEL button — pops with null (no change)
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
