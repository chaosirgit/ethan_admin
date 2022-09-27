import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Model.dart';
import 'dart:async';
import 'package:web3dart/credentials.dart';

class Tokens extends Model {
  @override
  final int? id;
  final int chainId;
  final int chainIndex;
  final String owner;
  final String tokenAddress;
  final int type;
  final String name;
  final String symbol;
  final int decimals;
  final String totalSupply;
  final String logo;
  final String inviteAddress;
  final int enableBot;
  final int isKyc;
  final int isAudit;
  final int isParsed;
  int? createdAt;
  int? updatedAt;

  @override
  // TODO: implement tableName
  get tableName => 'tokens';

  Tokens({
    this.owner = "",
    this.chainId = 0,
    this.tokenAddress = "",
    this.type = 0,
    this.id = null,
    this.chainIndex = 0,
    this.name = "",
    this.symbol = "",
    this.decimals = 18,
    this.totalSupply = "0",
    this.logo = "",
    this.inviteAddress = "",
    this.enableBot = -1,
    this.isKyc = 0,
    this.isAudit = 0,
    this.isParsed = 0,
    createdAt,
    updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      "owner": owner,
      "chain_id": chainId,
      "chain_index": chainIndex,
      "token_address": tokenAddress,
      "type": type,
      "name": name,
      "symbol": symbol,
      "decimals": decimals,
      "total_supply": totalSupply,
      "logo": logo,
      "invite_address": inviteAddress,
      "enable_bot": enableBot,
      "is_kyc": isKyc,
      "is_audit": isAudit,
      "is_parsed": isParsed,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
    if (id != null && id as int > 0) {
      map["id"] = id;
    }
    return map;
  }



  Tokens fromMap(Map first) {
    return Tokens(
      id: first["id"] ?? null,
      owner: first["owner"] ?? "",
      chainId: first["chain_id"] ?? 0,
      chainIndex: first["chain_index"] ?? 0,
      tokenAddress: first["token_address"] ?? "",
      type: first["type"] ?? 0,
      name: first["name"] ?? "",
      symbol: first["symbol"] ?? "",
      decimals: first["decimals"] ?? 0,
      totalSupply: first["total_supply"] ?? "0",
      logo: first["logo"] ?? "",
      inviteAddress: first["invite_address"] ?? "",
      enableBot: first["enable_bot"] ?? -1,
      isKyc: first["is_kyc"] ?? 0,
      isAudit: first["is_audit"] ?? 0,
      isParsed: first["is_parsed"] ?? 0,
      createdAt: first["created_at"] ?? null,
      updatedAt: first["updated_at"] ?? null,
    );
  }
}
