import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../../core/constants/app_constants.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Transaction {
  @override
  final String id;

  @override
  final String title;

  @override
  final double amount;

  final String typeString;

  final CategoryModel categoryModel;

  @override
  final String? description;

  @override
  final DateTime date;

  @override
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.typeString,
    required this.categoryModel,
    this.description,
    required this.date,
    required this.createdAt,
  }) : super(
         id: id,
         title: title,
         amount: amount,
         type: _stringToTransactionType(typeString),
         category: categoryModel.toEntity(),
         description: description,
         date: date,
         createdAt: createdAt,
       );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
    CategoryModel category,
  ) {
    return TransactionModel(
      id: map[AppConstants.transactionIdColumn] as String,
      title: map[AppConstants.transactionTitleColumn] as String,
      amount: map[AppConstants.transactionAmountColumn] as double,
      typeString: map[AppConstants.transactionTypeColumn] as String,
      categoryModel: category,
      description: map[AppConstants.transactionDescriptionColumn] as String?,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[AppConstants.transactionDateColumn] as int,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[AppConstants.transactionCreatedAtColumn] as int,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.transactionIdColumn: id,
      AppConstants.transactionTitleColumn: title,
      AppConstants.transactionAmountColumn: amount,
      AppConstants.transactionTypeColumn: typeString,
      AppConstants.transactionCategoryIdColumn: categoryModel.id,
      AppConstants.transactionDescriptionColumn: description,
      AppConstants.transactionDateColumn: date.millisecondsSinceEpoch,
      AppConstants.transactionCreatedAtColumn: createdAt.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      typeString: _transactionTypeToString(transaction.type),
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
    type: _stringToTransactionType(typeString),
    category: categoryModel.toEntity(),
    description: description,
    date: date,
    createdAt: createdAt,
  );

  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  static TransactionType _stringToTransactionType(String typeString) {
    switch (typeString) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      default:
        throw ArgumentError('Invalid transaction type: $typeString');
    }
  }
}
