import 'package:ethan_admin/models/Model.dart';

class AirdropLogs extends Model{
  final int? id;
  final int chainId;
  final int chainIndex;
  final String airdropAddress;
  final int type;
  final String address;
  final String rewards;
  final String claimed;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;

  AirdropLogs({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.airdropAddress = "",
    this.type = 0,
    this.address = "",
    this.rewards = "0",
    this.claimed = "", // 此处为空 为了判断是否解析完成
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
    return AirdropLogs(
      id: map['id'] ?? null,
      chainId: map['chain_id'] ?? 0,
      chainIndex: map['chain_index'] ?? 0,
      airdropAddress: map['airdrop_address'] ?? "",
      type: map['type'] ?? 0,
      address: map['address'] ?? "",
      rewards: map['rewards'] ?? "0",
      claimed: map['claimed'] ?? "",
      isParsed: map['is_parsed'] ?? 0,
      isRun: map['is_run'] ?? 0,
      createdAt: map['created_at'] ?? null,
      updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  // TODO: implement tableName
  get tableName => 'airdrop_logs';

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'airdrop_address' : airdropAddress,
      'type' : type,
      'address' : address,
      'rewards' : rewards,
      'claimed' : claimed,
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