import 'package:equatable/equatable.dart';

class Category extends Equatable {
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
  List<Object?> get props => [
        id,
        name,
        color,
        description,
        createdAt,
      ];
}
