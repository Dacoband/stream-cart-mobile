class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? phone;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.phone,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? email;
  }

  String get displayName {
    return fullName.isNotEmpty ? fullName : email;
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0].toUpperCase()}${lastName![0].toUpperCase()}';
    }
    if (firstName != null) {
      return firstName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? json['firstName'],
      lastName: json['last_name'] ?? json['lastName'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      phone: json['phone'],
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : json['createdAt'] != null 
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'])
          : json['updatedAt'] != null 
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phone,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
