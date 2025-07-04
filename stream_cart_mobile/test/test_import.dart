import 'package:flutter/material.dart';
import '../lib/presentation/widgets/home/category_section.dart';

void main() {
  // Test basic import
  print('Testing CategorySection...');
  
  // Test constructor
  const widget = CategorySection(categories: null);
  print('CategorySection created: ${widget.runtimeType}');
}
