import 'package:equatable/equatable.dart';

class ValueImagePair extends Equatable {
  final String value;
  final String? imageUrl;

  const ValueImagePair({
    required this.value,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [value, imageUrl];
}

class ProductDetailAttributeEntity extends Equatable {
  final String attributeName;
  final List<ValueImagePair> valueImagePairs;

  const ProductDetailAttributeEntity({
    required this.attributeName,
    required this.valueImagePairs,
  });

  @override
  List<Object> get props => [attributeName, valueImagePairs];
}