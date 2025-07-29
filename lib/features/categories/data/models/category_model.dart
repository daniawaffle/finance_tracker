import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';
import '../../../../core/constants/app_constants.dart';

part 'category_model.g.dart';

@HiveType(typeId: AppConstants.categoryTypeId)
@JsonSerializable()
class CategoryModel extends Category {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String color;

  @HiveField(3)
  @override
  final String? description;

  @HiveField(4)
  @override
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    required this.createdAt,
  }) : super(
          id: id,
          name: name,
          color: color,
          description: description,
          createdAt: createdAt,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      color: category.color,
      description: category.description,
      createdAt: category.createdAt,
    );
  }

  Category toEntity() => Category(
        id: id,
        name: name,
        color: color,
        description: description,
        createdAt: createdAt,
      );
}
