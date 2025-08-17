import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ReviewFiltersBar extends StatefulWidget {
  final bool initialVerifiedOnly;
  final void Function(int? minRating, int? maxRating, bool verifiedOnly, String? sortBy, bool ascending) onChanged;
  const ReviewFiltersBar({super.key, required this.initialVerifiedOnly, required this.onChanged});

  @override
  State<ReviewFiltersBar> createState() => _ReviewFiltersBarState();
}

class _ReviewFiltersBarState extends State<ReviewFiltersBar> {
  int? _star;
  bool _verified = false;
  String? _sortBy;
  bool _asc = false;

  @override
  void initState() {
    super.initState();
    _verified = widget.initialVerifiedOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        _StarChip(
          label: 'Tất cả',
          selected: _star == null,
          onTap: () => setState(() => _star = null),
        ),
        for (int i = 5; i >= 1; i--)
          _StarChip(
            label: '$i★',
            selected: _star == i,
            onTap: () => setState(() => _star = i),
          ),
        const Spacer(),
        FilterChip(
          label: const Text('Đã mua'),
          selected: _verified,
          onSelected: (v) => setState(() => _verified = v),
          selectedColor: AppColors.brandAccent.withOpacity(0.4),
          checkmarkColor: AppColors.brandDark,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.sort_rounded),
          onPressed: () async {
            final result = await showModalBottomSheet<(String?, bool)>(
              context: context,
              builder: (_) => _SortSheet(initialSortBy: _sortBy, initialAscending: _asc),
            );
            if (result != null) {
              setState(() {
                _sortBy = result.$1;
                _asc = result.$2;
              });
            }
          },
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => widget.onChanged(_star, _star, _verified, _sortBy, _asc),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, foregroundColor: Colors.white),
          child: const Text('Áp dụng'),
        )
      ]),
    );
  }
}

class _StarChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _StarChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.brandAccent.withOpacity(0.6),
        labelStyle: TextStyle(color: selected ? AppColors.brandDark : null),
      ),
    );
  }
}

class _SortSheet extends StatefulWidget {
  final String? initialSortBy;
  final bool initialAscending;
  const _SortSheet({required this.initialSortBy, required this.initialAscending});

  @override
  State<_SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<_SortSheet> {
  String? _sortBy;
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initialSortBy;
    _ascending = widget.initialAscending;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sắp xếp theo', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              _SortChip(label: 'Mới nhất', value: 'createdAt', group: _sortBy, onSelected: (v) => setState(() => _sortBy = v)),
              _SortChip(label: 'Đánh giá', value: 'rating', group: _sortBy, onSelected: (v) => setState(() => _sortBy = v)),
              _SortChip(label: 'Hữu ích', value: 'helpful', group: _sortBy, onSelected: (v) => setState(() => _sortBy = v)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Tăng dần'),
              const SizedBox(width: 8),
              Switch(value: _ascending, onChanged: (v) => setState(() => _ascending = v)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop((_sortBy, _ascending)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandPrimary, foregroundColor: Colors.white),
                child: const Text('Xong'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final String value;
  final String? group;
  final void Function(String) onSelected;
  const _SortChip({required this.label, required this.value, required this.group, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final selected = group == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: AppColors.brandAccent.withOpacity(0.6),
      labelStyle: TextStyle(color: selected ? AppColors.brandDark : null),
    );
  }
}
