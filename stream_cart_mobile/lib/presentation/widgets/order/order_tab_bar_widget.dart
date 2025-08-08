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
    const dark = Color(0xFF202328);
    const accent = Color(0xFFB0F847);
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: dark,
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
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
        // Pill indicator using accent color
        indicator: BoxDecoration(
          color: accent.withOpacity(0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent, width: 1),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: accent,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelColor: Colors.white70,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: tabs
            .map(
              (title) => Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
            .toList(),
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
    const dark = Color(0xFF202328);
    const accent = Color(0xFFB0F847);
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: dark,
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
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
                color: isSelected ? accent.withOpacity(0.14) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: accent, width: 1) : null,
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? accent : Colors.white70,
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
    const dark = Color(0xFF202328);
    const accent = Color(0xFFB0F847);
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: dark,
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
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
        indicator: BoxDecoration(
          color: accent.withOpacity(0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent, width: 1),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: accent,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelColor: Colors.white70,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final count = badgeCounts?[index];

          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
                        color: accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: dark,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
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