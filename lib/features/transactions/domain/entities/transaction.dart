import 'package:finance_tracker/features/categories/domain/entities/category.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final Category category;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    required this.date,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.category == category &&
        other.description == description &&
        other.date == date &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        category.hashCode ^
        description.hashCode ^
        date.hashCode ^
        createdAt.hashCode;
  }
}
