import 'package:equatable/equatable.dart';
import 'package:finance_tracker/features/categories/domain/entities/category.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
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
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        category,
        description,
        date,
        createdAt,
      ];
}
