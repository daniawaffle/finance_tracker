import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../../core/constants/app_constants.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: AppConstants.transactionTypeEnumId)
enum TransactionTypeModel {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: AppConstants.transactionTypeId)
@JsonSerializable()
class TransactionModel extends Transaction {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final double amount;

  @HiveField(3)
  final TransactionTypeModel typeModel;

  @HiveField(4)
  final CategoryModel categoryModel;

  @HiveField(5)
  @override
  final String? description;

  @HiveField(6)
  @override
  final DateTime date;

  @HiveField(7)
  @override
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.typeModel,
    required this.categoryModel,
    this.description,
    required this.date,
    required this.createdAt,
  }) : super(
          id: id,
          title: title,
          amount: amount,
          type: _typeModelToEnum(typeModel),
          category: categoryModel.toEntity(),
          description: description,
          date: date,
          createdAt: createdAt,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      typeModel: _typeEnumToModel(transaction.type),
      categoryModel: CategoryModel.fromEntity(transaction.category),
      description: transaction.description,
      date: transaction.date,
      createdAt: transaction.createdAt,
    );
  }

  Transaction toEntity() => Transaction(
        id: id,
        title: title,
        amount: amount,
        type: _typeModelToEnum(typeModel),
        category: categoryModel.toEntity(),
        description: description,
        date: date,
        createdAt: createdAt,
      );

  static TransactionTypeModel _typeEnumToModel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return TransactionTypeModel.income;
      case TransactionType.expense:
        return TransactionTypeModel.expense;
    }
  }

  static TransactionType _typeModelToEnum(TransactionTypeModel typeModel) {
    switch (typeModel) {
      case TransactionTypeModel.income:
        return TransactionType.income;
      case TransactionTypeModel.expense:
        return TransactionType.expense;
    }
  }
}
