
import 'package:ethan_admin/models/Model.dart';

class Stakes extends Model {
  final int? id;
  final int chainId;
  final int chainIndex;
  final String owner;
  final String stakingAddress;
  final String tokenAddress;
  final String tokenName;
  final String tokenSymbol;
  final int tokenDecimals;
  final String rewardAddress;
  final String rewardName;
  final String rewardSymbol;
  final int rewardDecimals;
  final int? type;
  final int startTime;
  final int endTime;
  final int lockPeriod;
  final int apr;
  final String poolCap;
  final String currentAmount;
  final String totalReward;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;

  Stakes({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.owner = "",
    this.stakingAddress = "",
    this.tokenAddress = "",
    this.tokenSymbol = "",
    this.tokenName = "",
    this.tokenDecimals = 0,
    this.rewardAddress = "",
    this.rewardName = "",
    this.rewardSymbol = "",
    this.rewardDecimals = 0,
    this.type = null,
    this.startTime = 0,
    this.endTime = 0,
    this.lockPeriod = 0,
    this.apr = 0,
    this.poolCap = "0",
    this.currentAmount = "0",
    this.totalReward = "0",
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
    return Stakes(
      id: map['id'] ?? null,
      chainId: map['chain_id'] ?? 0,
      chainIndex: map['chain_index'] ?? 0,
      owner: map['owner'] ?? "",
      stakingAddress: map['staking_address'] ?? "",
      tokenAddress: map['token_address'] ?? "",
      tokenName: map['token_name'] ?? "",
      tokenSymbol: map['token_symbol'] ?? "",
      tokenDecimals: map['token_decimals'] ?? 0,
      rewardAddress: map['reward_address'] ?? "",
      rewardName: map['reward_name'] ?? "",
      rewardSymbol: map['reward_symbol'] ?? "",
      rewardDecimals: map['reward_decimals'] ?? 0,
      type: map['type'] ?? null,
      startTime: map['start_time'] ?? 0,
      endTime: map['end_time'] ?? 0,
      lockPeriod: map['lock_period'] ?? 0,
      apr: map['apr'] ?? 0,
      poolCap: map['pool_cap'] ?? "0",
      currentAmount: map['current_amount'] ?? "0",
      totalReward: map['total_reward'] ?? "0",
      isParsed: map['is_parsed'] ?? 0,
      isRun: map['is_run'] ?? 0,
      createdAt: map['created_at'] ?? null,
      updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  // TODO: implement tableName
  get tableName => "stakes";

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'owner' : owner,
      'staking_address' : stakingAddress,
      'token_address' : tokenAddress,
      'token_name' : tokenName,
      'token_symbol' : tokenSymbol,
      'token_decimals' : tokenDecimals,
      'reward_address' : rewardAddress,
      'reward_name' : rewardName,
      'reward_symbol' : rewardSymbol,
      'reward_decimals' : rewardDecimals,
      'type': type,
      'start_time': startTime,
      'end_time': endTime,
      'lock_period': lockPeriod,
      'apr': apr,
      'pool_cap': poolCap,
      "current_amount" : currentAmount,
      'total_reward': totalReward,
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