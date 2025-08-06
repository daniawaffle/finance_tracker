import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';
import '../../../../core/constants/app_constants.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Category {
  @override
  final String id;

  @override
  final String name;

  @override
  final String color;

  @override
  final String? description;

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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[AppConstants.categoryIdColumn] as String,
      name: map[AppConstants.categoryNameColumn] as String,
      color: map[AppConstants.categoryColorColumn] as String,
      description: map[AppConstants.categoryDescriptionColumn] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppConstants.categoryCreatedAtColumn] as int,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.categoryIdColumn: id,
      AppConstants.categoryNameColumn: name,
      AppConstants.categoryColorColumn: color,
      AppConstants.categoryDescriptionColumn: description,
      AppConstants.categoryCreatedAtColumn: createdAt.millisecondsSinceEpoch,
    };
  }

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
