import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_providers.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../../categories/presentation/pages/manage_categories_page.dart';
import 'add_transaction_page.dart';
import 'edit_transaction_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionNotifierProvider);
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ManageCategoriesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(transactionNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (transactions) => _buildTransactionsList(context, ref, transactions),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await categoriesAsync.when(
            loading: () => _showLoadingDialog(context),
            error: (error, stack) => _showErrorDialog(context, error.toString()),
            data: (categories) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTransactionPage(categories: categories),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context, WidgetRef ref, List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first transaction',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final balance = totalIncome - totalExpense;

    return Column(
      children: [
        // Balance Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Income', style: TextStyle(color: Colors.white70)),
                      Text(
                        '\$${totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Expense', style: TextStyle(color: Colors.white70)),
                      Text(
                        '\$${totalExpense.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Transactions List
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) => _buildTransactionItem(context, ref, transactions[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, WidgetRef ref, Transaction transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(transaction.category.color)),
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.category.name),
            Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.type == TransactionType.income ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, ref, value, transaction),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action, Transaction transaction) {
    if (action == 'edit') {
      _editTransaction(context, ref, transaction);
    } else if (action == 'delete') {
      _deleteTransaction(context, ref, transaction);
    }
  }

  void _editTransaction(BuildContext context, WidgetRef ref, Transaction transaction) async {
    final categoriesAsync = ref.read(categoryNotifierProvider);
    await categoriesAsync.when(
      loading: () => _showLoadingDialog(context),
      error: (error, stack) => _showErrorDialog(context, error.toString()),
      data: (categories) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTransactionPage(
            transaction: transaction,
            categories: categories,
          ),
        ),
      ),
    );
  }

  void _deleteTransaction(BuildContext context, WidgetRef ref, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Are you sure you want to delete "${transaction.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(transactionNotifierProvider.notifier).deleteTransaction(transaction.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Loading categories...'),
          ],
        ),
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String error) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to load categories: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
