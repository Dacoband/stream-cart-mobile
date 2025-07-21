import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gợi ý tìm kiếm',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () => onSuggestionTap(suggestion),
              backgroundColor: Colors.grey.shade100,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PopularSearches extends StatelessWidget {
  final List<String> popularSearches;
  final Function(String) onSearchTap;

  const PopularSearches({
    super.key,
    required this.popularSearches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    if (popularSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 20,
              color: Colors.orange.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Tìm kiếm phổ biến',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popularSearches.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final search = popularSearches[index];
            return ListTile(
              leading: Icon(
                Icons.trending_up,
                color: Colors.orange.shade600,
                size: 20,
              ),
              title: Text(search),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
              onTap: () => onSearchTap(search),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            );
          },
        ),
      ],
    );
  }
}

class CategorySearchSuggestions extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategoryTap;

  const CategorySearchSuggestions({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category,
              size: 20,
              color: Colors.blue.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Danh mục',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: categories.length > 6 ? 6 : categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () => onCategoryTap(category),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
