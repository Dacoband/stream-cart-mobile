import 'package:flutter/material.dart';

class ReviewSkeletonList extends StatelessWidget {
  const ReviewSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, __) => const _ItemSkeleton(),
    );
  }
}

class _ItemSkeleton extends StatelessWidget {
  const _ItemSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 32, height: 32, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEFEFEF))),
          const SizedBox(width: 8),
          Container(width: 100, height: 12, color: const Color(0xFFEFEFEF)),
        ]),
        const SizedBox(height: 8),
        Container(width: 160, height: 12, color: const Color(0xFFEFEFEF)),
        const SizedBox(height: 8),
        Container(width: double.infinity, height: 12, color: const Color(0xFFEFEFEF)),
        const SizedBox(height: 8),
        Row(children: List.generate(3, (i) => Expanded(child: Container(height: 60, margin: EdgeInsets.only(right: i < 2 ? 8 : 0), color: const Color(0xFFEFEFEF))))),
      ]),
    );
  }
}
