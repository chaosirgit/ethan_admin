import 'package:ethan_admin/models/Model.dart';

class LockLogs extends Model {
  final int? id;
  final int chainId;
  final int chainIndex;
  final int? chainLockId;
  final String tokenAddress;
  final String owner;
  final String amount;
  final int lockTime;
  final int firstUnlockTime;
  final int firstUnlockRate;
  final int unlockCycle;
  final int unlockCycleRate;
  final String alreadyUnlockAmount;
  final String description;
  final int isParsed;
  final int isRun;
  final int blockIndex;
  int? createdAt;
  int? updatedAt;

  LockLogs({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.chainLockId = null,
    this.tokenAddress = "",
    this.owner = "",
    this.amount = "0",
    this.lockTime = 0,
    this.firstUnlockTime = 0,
    this.firstUnlockRate = 0,
    this.unlockCycle = 0,
    this.unlockCycleRate = 0,
    this.alreadyUnlockAmount = "0",
    this.description = "",
    this.isParsed = 0,
    this.isRun = 0,
    this.blockIndex = 0,
    createdAt,
    updatedAt
  }){
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }


  @override
  Model fromMap(Map map) {
    // TODO: implement fromMap
    return LockLogs(
      id: map['id'] ?? null,
      chainId: map['chain_id'] ?? 0,
      chainIndex: map['chain_index'] ?? 0,
      chainLockId: map['chain_lock_id'] ?? null,
      tokenAddress: map['token_address'] ?? "",
      owner: map['owner'] ?? "",
      amount: map['amount'] ?? "0",
      lockTime: map['lock_time'] ?? 0,
      firstUnlockTime: map['first_unlock_time'] ?? 0,
      firstUnlockRate: map['first_unlock_rate'] ?? 0,
      unlockCycle: map['unlock_cycle'] ?? 0,
      unlockCycleRate: map['unlock_cycle_rate'] ?? 0,
      alreadyUnlockAmount: map['already_unlock_amount'] ?? "0",
      description: map['description'] ?? "",
      isParsed: map['is_parsed'] ?? 0,
      isRun: map['is_run'] ?? 0,
      blockIndex: map['block_index'] ?? 0,
      createdAt: map['created_at'] ?? null,
      updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  // TODO: implement tableName
  get tableName => "lock_logs";

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'chain_lock_id' : chainLockId,
      'token_address' : tokenAddress,
      'owner': owner,
      'amount': amount,
      'lock_time': lockTime,
      'first_unlock_time': firstUnlockTime,
      'first_unlock_rate': firstUnlockRate,
      'unlock_cycle': unlockCycle,
      'unlock_cycle_rate': unlockCycleRate,
      'already_unlock_amount': alreadyUnlockAmount,
      'description': description,
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