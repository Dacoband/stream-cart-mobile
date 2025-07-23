import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../domain/entities/category_entity.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryEntity>? categories;
  
  const CategorySection({
    super.key,
    this.categories,
  });

  // Mock categories data for fallback
  static const List<Map<String, dynamic>> _mockCategories = [
    {
      'id': '1',
      'name': 'Điện tử',
      'icon': Icons.phone_android,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'name': 'Thời trang',
      'icon': Icons.checkroom,
      'color': Colors.pink,
    },
    {
      'id': '3',
      'name': 'Gia dụng',
      'icon': Icons.home,
      'color': Colors.green,
    },
    {
      'id': '4',
      'name': 'Làm đẹp',
      'icon': Icons.face_retouching_natural,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'name': 'Thể thao',
      'icon': Icons.sports_soccer,
      'color': Colors.orange,
    },
    {
      'id': '6',
      'name': 'Sách',
      'icon': Icons.book,
      'color': Colors.brown,
    },
    {
      'id': '7',
      'name': 'Thực phẩm',
      'icon': Icons.restaurant,
      'color': Colors.red,
    },
    {
      'id': '8',
      'name': 'Khác',
      'icon': Icons.more_horiz,
      'color': Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 8,
          ),
          child: Text(
            'Danh mục',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 110, 
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, 
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: categories?.isNotEmpty == true 
                  ? (categories!.length > 8 ? 8 : categories!.length)
                  : _mockCategories.length,
              itemBuilder: (context, index) {
                if (categories?.isNotEmpty == true) {
                  final category = categories![index];
                  return _buildCategoryFromEntity(context, category);
                } else {
                  final category = _mockCategories[index];
                  return _buildCategoryFromMock(context, category);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFromEntity(BuildContext context, CategoryEntity category) {
    return GestureDetector(
      onTap: () {    
        Navigator.of(context).pushNamed(
          AppRouter.categoryDetail,
          arguments: {
            'categoryId': category.categoryId,
            'categoryName': category.categoryName,
          },
        ).then((result) {
          print('✅ Navigation completed with result: $result');
        }).catchError((error) {
          print('❌ Navigation error: $error');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, 
          children: [
            Container(
              width: 32, 
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: category.iconURL?.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        category.iconURL!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            color: Colors.blue,
                            size: 20,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.category,
                      color: Colors.blue,
                      size: 20,
                    ),
            ),
            const SizedBox(height: 6), 
            Flexible( 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  category.categoryName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFromMock(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        // Could navigate to a sample category page for demo
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, 
          children: [
            Container(
              width: 32, 
              height: 32,
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                category['icon'] as IconData,
                color: category['color'] as Color,
                size: 20,
              ),
            ),
            const SizedBox(height: 6), 
            Flexible( 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  category['name'],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
