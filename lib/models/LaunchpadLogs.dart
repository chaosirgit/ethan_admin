import 'package:ethan_admin/models/Model.dart';

class LaunchpadLogs extends Model{
  final int? id;
  final int chainId;
  final int chainIndex;
  final String launchpadAddress;
  final String address;
  final String amount;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;

  LaunchpadLogs({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.launchpadAddress = "",
    this.address = "",
    this.amount = "0",
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
    return LaunchpadLogs(
      id: map['id'] ?? null,
      chainId: map['chain_id'] ?? 0,
      chainIndex: map['chain_index'] ?? 0,
      launchpadAddress: map['launchpad_address'] ?? "",
      address: map['address'] ?? "",
      amount: map['amount'] ?? "0",
      isParsed: map['is_parsed'] ?? 0,
      isRun: map['is_run'] ?? 0,
      createdAt: map['created_at'] ?? null,
      updatedAt: map['updated_at'] ?? null,
    );
  }

  @override
  // TODO: implement tableName
  get tableName => 'launchpad_logs';

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'launchpad_address' : launchpadAddress,
      'address' : address,
      'amount' : amount,
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