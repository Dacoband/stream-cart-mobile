import 'package:flutter/material.dart';
import '../../../domain/entities/search_filters.dart';
import '../../../domain/entities/category_entity.dart';

class SearchFiltersWidget extends StatefulWidget {
  final SearchFilters initialFilters;
  final List<CategoryEntity> categories;
  final Function(SearchFilters) onFiltersChanged;
  final VoidCallback onClose;

  const SearchFiltersWidget({
    super.key,
    required this.initialFilters,
    required this.categories,
    required this.onFiltersChanged,
    required this.onClose,
  });

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  late SearchFilters _filters;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _minPriceController.text = _filters.minPrice?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _updateFilters(SearchFilters newFilters) {
    setState(() {
      _filters = newFilters;
    });
  }

  void _applyFilters() {
    // Validate price range
    final minPrice = double.tryParse(_minPriceController.text);
    final maxPrice = double.tryParse(_maxPriceController.text);

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giá tối thiểu không được lớn hơn giá tối đa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final finalFilters = _filters.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    widget.onFiltersChanged(finalFilters);
    widget.onClose();
  }

  void _resetFilters() {
    setState(() {
      _filters = const SearchFilters();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bộ lọc tìm kiếm',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  _buildCategoryFilter(),
                  const SizedBox(height: 24),

                  // Price Range Filter
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 24),

                  // Sort By Filter
                  _buildSortByFilter(),
                  const SizedBox(height: 24),

                  // Rating Filter
                  _buildRatingFilter(),
                  const SizedBox(height: 24),

                  // Stock Filter
                  _buildStockFilter(),
                  const SizedBox(height: 24),

                  // Sale Filter
                  _buildSaleFilter(),
                ],
              ),
            ),
          ),

          // Action Buttons
          const Divider(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  child: const Text('Đặt lại'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _filters.categoryId,
          decoration: const InputDecoration(
            hintText: 'Chọn danh mục',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Tất cả danh mục'),
            ),
            ...widget.categories.map((category) => DropdownMenuItem<String>(
              value: category.categoryId,
              child: Text(category.categoryName),
            )),
          ],
          onChanged: (value) {
            _updateFilters(_filters.copyWith(categoryId: value));
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khoảng giá',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Giá tối thiểu',
                  border: OutlineInputBorder(),
                  suffixText: '₫',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Giá tối đa',
                  border: OutlineInputBorder(),
                  suffixText: '₫',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortByFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sắp xếp theo',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _filters.sortBy,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: SortOption.values.map((option) => DropdownMenuItem<String>(
            value: option.value,
            child: Text(option.displayName),
          )).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateFilters(_filters.copyWith(sortBy: value));
            }
          },
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá tối thiểu',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildRatingChip(null, 'Tất cả'),
            ...List.generate(5, (index) {
              final rating = index + 1;
              return _buildRatingChip(rating, '$rating sao');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingChip(int? rating, String label) {
    final isSelected = _filters.minRating == rating;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rating != null) ...[
            Icon(
              Icons.star,
              size: 16,
              color: isSelected ? Colors.white : Colors.amber,
            ),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      onSelected: (selected) {
        _updateFilters(_filters.copyWith(minRating: selected ? rating : null));
      },
    );
  }

  Widget _buildStockFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tình trạng kho',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Chỉ hiển thị sản phẩm còn hàng'),
          value: _filters.inStockOnly,
          onChanged: (value) {
            _updateFilters(_filters.copyWith(inStockOnly: value));
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSaleFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khuyến mãi',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Chỉ hiển thị sản phẩm đang giảm giá'),
          value: _filters.onSaleOnly,
          onChanged: (value) {
            _updateFilters(_filters.copyWith(onSaleOnly: value));
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
