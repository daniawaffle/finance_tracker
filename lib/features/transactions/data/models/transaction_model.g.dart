// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      typeModel: fields[3] as TransactionTypeModel,
      categoryModel: fields[4] as CategoryModel,
      description: fields[5] as String?,
      date: fields[6] as DateTime,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.typeModel)
      ..writeByte(4)
      ..write(obj.categoryModel)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeModelAdapter extends TypeAdapter<TransactionTypeModel> {
  @override
  final int typeId = 2;

  @override
  TransactionTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionTypeModel.income;
      case 1:
        return TransactionTypeModel.expense;
      default:
        return TransactionTypeModel.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionTypeModel obj) {
    switch (obj) {
      case TransactionTypeModel.income:
        writer.writeByte(0);
        break;
      case TransactionTypeModel.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      typeModel: $enumDecode(_$TransactionTypeModelEnumMap, json['typeModel']),
      categoryModel:
          CategoryModel.fromJson(json['categoryModel'] as Map<String, dynamic>),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'typeModel': _$TransactionTypeModelEnumMap[instance.typeModel]!,
      'categoryModel': instance.categoryModel,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TransactionTypeModelEnumMap = {
  TransactionTypeModel.income: 'income',
  TransactionTypeModel.expense: 'expense',
};
