import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';

class SearchDemoPage extends StatelessWidget {
  const SearchDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tính năng Search được phát triển',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            const Text(
              'API Endpoint: https://brightpa.me/api/products/search',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Basic Search Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.search);
              },
              icon: const Icon(Icons.search),
              label: const Text('Tìm kiếm cơ bản'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Advanced Search Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.advancedSearch);
              },
              icon: const Icon(Icons.tune),
              label: const Text('Tìm kiếm nâng cao'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Advanced Search with initial query
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  AppRouter.advancedSearch,
                  arguments: 'Gạo',
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Tìm kiếm "Gạo" (Demo)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Features List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tính năng đã phát triển:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    const FeatureItem(
                      icon: Icons.search,
                      title: 'Tìm kiếm theo từ khóa',
                      description: 'SearchTerm parameter với highlighted results',
                    ),
                    const FeatureItem(
                      icon: Icons.filter_list,
                      title: 'Bộ lọc nâng cao',
                      description: 'Category, Price range, Rating, Stock, Sale',
                    ),
                    const FeatureItem(
                      icon: Icons.sort,
                      title: 'Sắp xếp kết quả',
                      description: 'Relevance, Price, Rating, Newest, Best selling',
                    ),
                    const FeatureItem(
                      icon: Icons.history,
                      title: 'Lịch sử tìm kiếm',
                      description: 'Lưu và hiển thị các tìm kiếm gần đây',
                    ),
                    const FeatureItem(
                      icon: Icons.refresh,
                      title: 'Load more',
                      description: 'Pagination với hasNext, hasPrevious',
                    ),
                    const FeatureItem(
                      icon: Icons.lightbulb_outline,
                      title: 'Gợi ý từ khóa',
                      description: 'Suggested keywords khi không có kết quả',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
