
import 'Model.dart';

class StakingLogs extends Model {
  final int? id;
  final int chainId;
  final int chainIndex;
  final String stakingAddress;
  final String owner;
  final String amount;
  final int unlockTime;
  final int lastTime;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;

  StakingLogs({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.stakingAddress = "",
    this.owner = "",
    this.amount = "0",
    this.unlockTime = 0,
    this.lastTime = 0,
    this.isParsed = 0,
    this.isRun = 0,
    createdAt,
    updatedAt
  }){
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  @override
  Model fromMap(Map map) {
    // TODO: implement fromMap
    return StakingLogs(
      id: map['id'] ?? null,
      chainId: map['chain_id'] ?? 0,
      chainIndex: map['chain_index'] ?? 0,
      stakingAddress: map['staking_address'] ?? "",
      owner: map['owner'] ?? "",
      amount: map['amount'] ?? "0",
      unlockTime: map['unlock_time'] ?? 0,
      lastTime: map['last_time'] ?? 0,
      isParsed: map['is_parsed'] ?? 0,
      isRun: map['is_run'] ?? 0,
      createdAt: map['created_at'] ?? null,
      updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  // TODO: implement tableName
  get tableName => 'staking_logs';

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'staking_address' : stakingAddress,
      'owner' : owner,
      'amount' : amount,
      'unlock_time' : unlockTime,
      'last_time' : lastTime,
      'is_parsed'  : isParsed,
      'is_run' : isRun,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
    };
    if (id != null && id as int > 0) {
      map["id"] = id;
    }
    return map;
  }

}