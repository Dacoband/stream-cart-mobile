import '../../../domain/entities/products/attribute_value_entity.dart';

class AttributeValueModel extends AttributeValueEntity {
  const AttributeValueModel({
    required super.id,
    required super.attributeId,
    required super.valueName,
    required super.createdAt,
    required super.createdBy,
    super.lastModifiedAt,
    super.lastModifiedBy,
  });

  factory AttributeValueModel.fromJson(Map<String, dynamic> json) {
    return AttributeValueModel(
      id: json['id'] as String,
      attributeId: json['attributeId'] as String,
      valueName: json['valueName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      lastModifiedAt: json['lastModifiedAt'] != null
          ? DateTime.parse(json['lastModifiedAt'] as String)
          : null,
      lastModifiedBy: json['lastModifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributeId': attributeId,
      'valueName': valueName,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastModifiedAt': lastModifiedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  factory AttributeValueModel.fromEntity(AttributeValueEntity entity) {
    return AttributeValueModel(
      id: entity.id,
      attributeId: entity.attributeId,
      valueName: entity.valueName,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      lastModifiedAt: entity.lastModifiedAt,
      lastModifiedBy: entity.lastModifiedBy,
    );
  }

  AttributeValueEntity toEntity() {
    return AttributeValueEntity(
      id: id,
      attributeId: attributeId,
      valueName: valueName,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModifiedAt: lastModifiedAt,
      lastModifiedBy: lastModifiedBy,
    );
  }

  @override
  AttributeValueModel copyWith({
    String? id,
    String? attributeId,
    String? valueName,
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastModifiedAt,
    String? lastModifiedBy,
  }) {
    return AttributeValueModel(
      id: id ?? this.id,
      attributeId: attributeId ?? this.attributeId,
      valueName: valueName ?? this.valueName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
    );
  }
}