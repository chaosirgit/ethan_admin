import 'package:ethan_admin/models/Model.dart';

class Locks extends Model {
  final int? id;
  final int chainId;
  final int chainIndex;
  final int type;
  final String tokenAddress;
  final String name;
  final String symbol;
  final int decimals;
  final String factoryAddress;
  final String currentAmount;
  final int isParsed;
  final int isRun;
  final int blockIndex;
  int? createdAt;
  int? updatedAt;

  Locks(
      {this.id = null,
      this.chainId = 0,
      this.chainIndex = 0,
      this.type = 0,
      this.tokenAddress = "",
      this.name = "",
      this.symbol = "",
      this.decimals = 0,
      this.factoryAddress = "",
      this.currentAmount = "0",
      this.isParsed = 0,
      this.isRun = 0,
      this.blockIndex = 0,
      createdAt,
      updatedAt}) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  @override
  // TODO: implement tableName
  get tableName => 'locks';

  @override
  Model fromMap(Map map) {
    return Locks(
        id: map['id'] ?? null,
        chainId: map['chain_id'] ?? 0,
        chainIndex: map['chain_index'] ?? 0,
        type: map['type'] ?? 0,
        tokenAddress: map['token_address'] ?? "",
        name: map['name'] ?? "",
        symbol: map['symbol'] ?? "",
        decimals: map['decimals'] ?? 0,
        factoryAddress: map['factory_address'] ?? "",
        currentAmount: map['current_amount'] ?? "0",
        isParsed: map['is_parsed'] ?? 0,
        isRun: map['is_run'] ?? 0,
        blockIndex: map['block_index'] ?? 0,
        createdAt: map['created_at'] ?? null,
        updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'type' : type,
      'token_address' : tokenAddress,
      'name' : name,
      'symbol' : symbol,
      'decimals' : decimals,
      'factory_address': factoryAddress,
      'current_amount': currentAmount,
      'is_parsed'  : isParsed,
      'is_run' : isRun,
      'block_index': blockIndex,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
    if (id != null && id as int > 0) {
      map["id"] = id;
    }
    return map;
  }
}
