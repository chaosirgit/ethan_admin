import 'package:ethan_admin/models/Model.dart';

class LockLps extends Model {
  final int? id;
  final int chainId;
  final int chainIndex;
  final String tokenAddress;
  final String name;
  final String symbol;
  final int decimals;
  final String factoryAddress;
  final String token0Address;
  final String token0Name;
  final String token0Symbol;
  final int token0Decimals;
  final String token1Address;
  final String token1Name;
  final String token1Symbol;
  final int token1Decimals;
  final String currentAmount;
  final int isParsed;
  final int isRun;
  final int blockIndex;
  int? createdAt;
  int? updatedAt;

  LockLps(
      {this.id = null,
      this.chainId = 0,
      this.chainIndex = 0,
      this.tokenAddress = "",
      this.name = "",
      this.symbol = "",
      this.decimals = 0,
      this.factoryAddress = "",
      this.token0Address = "",
      this.token0Name = "",
      this.token0Symbol = "",
      this.token0Decimals = 0,
      this.token1Address = "",
      this.token1Name = "",
      this.token1Symbol = "",
      this.token1Decimals = 0,
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
  get tableName => 'lock_lps';

  @override
  Model fromMap(Map map) {
    return LockLps(
        id: map['id'] ?? null,
        chainId: map['chain_id'] ?? 0,
        chainIndex: map['chain_index'] ?? 0,
        tokenAddress: map['token_address'] ?? "",
        name: map['name'] ?? "",
        symbol: map['symbol'] ?? "",
        decimals: map['decimals'] ?? 0,
        factoryAddress: map['factory_address'] ?? "",
        token0Address: map['token0_address'] ?? "",
        token0Name: map['token0_name'] ?? "",
        token0Symbol: map['token0_symbol'] ?? "",
        token0Decimals: map['token0_decimals'] ?? 0,
        token1Address: map['token1_address'] ?? "",
        token1Name: map['token1_name'] ?? "",
        token1Symbol: map['token1_symbol'] ?? "",
        token1Decimals: map['token1_decimals'] ?? 0,
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
      'token_address' : tokenAddress,
      'name' : name,
      'symbol' : symbol,
      'decimals' : decimals,
      'factory_address': factoryAddress,
      'token0_address' : token0Address,
      'token0_name' : token0Name,
      'token0_symbol' : token0Symbol,
      'token0_decimals' : token0Decimals,
      'token1_address' : token1Address,
      'token1_name' : token1Name,
      'token1_symbol' : token1Symbol,
      'token1_decimals' : token1Decimals,
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
