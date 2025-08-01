import 'package:flutter/material.dart';
import '../../../domain/entities/category/category_entity.dart';

class SubcategoryCarousel extends StatelessWidget {
  final List<SubCategoryEntity> subCategories;
  final Function(SubCategoryEntity) onSubcategoryTap;

  const SubcategoryCarousel({
    super.key,
    required this.subCategories,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          return _buildSubcategoryItem(context, subCategory);
        },
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, SubCategoryEntity subCategory) {
    return GestureDetector(
      onTap: () => onSubcategoryTap(subCategory),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: subCategory.iconURL != null && subCategory.iconURL!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          subCategory.iconURL!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.category_outlined,
                              color: Color(0xFF4CAF50),
                              size: 24,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.category_outlined,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
              ),
              const SizedBox(height: 8),
              // Category Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  subCategory.categoryName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
