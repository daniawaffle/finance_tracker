class AppConstants {
  static const String appName = 'Finance Tracker';
  static const String databaseName = 'finance_tracker.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String categoriesTable = 'categories';
  static const String transactionsTable = 'transactions';

  // Categories Table Columns
  static const String categoryIdColumn = 'id';
  static const String categoryNameColumn = 'name';
  static const String categoryColorColumn = 'color';
  static const String categoryDescriptionColumn = 'description';
  static const String categoryCreatedAtColumn = 'created_at';

  // Transactions Table Columns
  static const String transactionIdColumn = 'id';
  static const String transactionTitleColumn = 'title';
  static const String transactionAmountColumn = 'amount';
  static const String transactionTypeColumn = 'type';
  static const String transactionCategoryIdColumn = 'category_id';
  static const String transactionDescriptionColumn = 'description';
  static const String transactionDateColumn = 'date';
  static const String transactionCreatedAtColumn = 'created_at';
}
