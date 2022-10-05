// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinerModelAdapter extends TypeAdapter<MinerModel> {
  @override
  final int typeId = 1;

  @override
  MinerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinerModel(
      minerID: fields[0] as String,
      phoneNumber: fields[7] as String,
      minerAvatar: fields[2] as int,
      accounts: (fields[6] as List).cast<dynamic>(),
      productPurchased: fields[4] as int,
      numberOfProducts: fields[3] as int,
      productSold: fields[1] as int,
      totalRevenue: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MinerModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.minerID)
      ..writeByte(1)
      ..write(obj.productSold)
      ..writeByte(2)
      ..write(obj.minerAvatar)
      ..writeByte(3)
      ..write(obj.numberOfProducts)
      ..writeByte(4)
      ..write(obj.productPurchased)
      ..writeByte(5)
      ..write(obj.totalRevenue)
      ..writeByte(6)
      ..write(obj.accounts)
      ..writeByte(7)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
