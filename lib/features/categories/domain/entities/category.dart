class Category {
  final String id;
  final String name;
  final String color;
  final String? description;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        color.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
