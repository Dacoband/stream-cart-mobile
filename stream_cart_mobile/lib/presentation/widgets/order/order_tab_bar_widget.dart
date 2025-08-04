import 'package:flutter/material.dart';

// Tab bar cho filter status (Tất cả, Chờ xác nhận, Đang giao, Hoàn thành, Đã hủy)
class OrderTabBarWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;
  final VoidCallback? onTap;

  const OrderTabBarWidget({
    Key? key,
    required this.tabController,
    required this.tabs,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        onTap: (index) => onTap?.call(),
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabAlignment: TabAlignment.start,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: Colors.grey[600],
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: tabs.map((title) => Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        )).toList(),
      ),
    );
  }
}

// Alternative version with custom design
class CustomOrderTabBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final Function(int)? onTap;

  const CustomOrderTabBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.tabs,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected 
                        ? Theme.of(context).primaryColor
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tab bar with badge counts
class OrderTabBarWithBadgeWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;
  final List<int>? badgeCounts;
  final VoidCallback? onTap;

  const OrderTabBarWithBadgeWidget({
    Key? key,
    required this.tabController,
    required this.tabs,
    this.badgeCounts,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        onTap: (index) => onTap?.call(),
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabAlignment: TabAlignment.start,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: Colors.grey[600],
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final count = badgeCounts?[index];
          
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  if (count != null && count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}