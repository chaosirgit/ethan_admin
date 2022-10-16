import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Model.dart';
import 'dart:async';

import 'package:web3dart/credentials.dart';

class Launchpads extends Model {
  @override
  final int? id;
  final int chainId;
  final int chainIndex;
  final String publisher;
  final String owner;
  final int type;
  final String contractAddress;
  final String presaleAddress;
  final String presaleName;
  final String presaleSymbol;
  final int presaleDecimals;
  final String payAddress;
  final String payName;
  final String paySymbol;
  final int payDecimals;
  final String routerAddress;
  final String inviteAddress;
  final String softCap;
  final String hardCap;
  final String minPurchase;
  final String maxPurchase;
  final int rate;
  final String price;
  final int tokenFee;
  final int payFee;
  final int rewardsTokenType;
  final int firstLevel;
  final int secondLevel;
  final int referralBuy;
  final int saleType;
  final int changePublic;
  final int undoneProcess;
  final int liquidityRate;
  final int liquidityLockTime;
  final int firstUnlockRate;
  final int nextUnlockRate;
  final int unlockCycleTime;
  final int beginAt;
  final int endAt;
  final int isKyc;
  final int isAudit;
  final String logo;
  final String website;
  final String twitter;
  final String telegram;
  final String discord;
  final String facebook;
  final String github;
  final String instagram;
  final String reddit;
  final String description;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;
  get tableName => "launchpads";

  Launchpads({
    this.id = null, 
    this.chainId = 0,
    this.chainIndex = 0,
    this.publisher = "",
    this.owner = "",
    this.type = 0,
    this.contractAddress = "",
    this.presaleAddress = "",
    this.presaleName = "",
    this.presaleSymbol = "",
    this.presaleDecimals = 0,
    this.payAddress = "",
    this.payName = "",
    this.paySymbol = "",
    this.payDecimals = 0,
    this.routerAddress = "",
    this.inviteAddress = "",
    this.softCap = "0",
    this.hardCap = "0",
    this.minPurchase = "0",
    this.maxPurchase = "0",
    this.rate = 0,
    this.price = "0",
    this.tokenFee = 0,
    this.payFee = 0,
    this.rewardsTokenType = 0,
    this.firstLevel = 0,
    this.secondLevel = 0,
    this.referralBuy = 0,
    this.saleType = 0,
    this.changePublic = 0,
    this.undoneProcess = 0,
    this.liquidityRate = 0,
    this.liquidityLockTime = 0,
    this.firstUnlockRate = 0,
    this.nextUnlockRate = 0,
    this.unlockCycleTime = 0,
    this.beginAt = 0,
    this.endAt  = 0,
    this.isKyc  = -1,
    this.isAudit = 0,
    this.logo = "",
    this.website = "",
    this.twitter = "",
    this.telegram = "",
    this.discord = "",
    this.facebook = "",
    this.github = "",
    this.instagram = "",
    this.reddit = "",
    this.description = "",
    this.isParsed = 0,
    this.isRun = 0,
    createdAt,
    updatedAt,
  }){
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'chain_id' : chainId,
      'chain_index' : chainIndex,
      'publisher' : publisher,
      'owner' : owner,
      'type' : type,
      'contract_address' : contractAddress,
      'presale_address' : presaleAddress,
      'presale_name' : presaleName,
      'presale_symbol' : presaleSymbol,
      'presale_decimals'  : presaleDecimals,
      'pay_address' : payAddress,
      'pay_name'  : payName,
      'pay_symbol' : paySymbol,
      'pay_decimals'  : payDecimals,
      'router_address' : routerAddress,
      'invite_address' : inviteAddress,
      'soft_cap' : softCap,
      'hard_cap' : hardCap,
      'min_purchase' : minPurchase,
      'max_purchase' : maxPurchase,
      'rate'  : rate,
      'price' : price,
      'token_fee'  : tokenFee,
      'pay_fee'  : payFee,
      'rewards_token_type'  : rewardsTokenType,
      'first_level'  : firstLevel,
      'second_level'  : secondLevel,
      'referral_buy'  : referralBuy,
      'sale_type'  : saleType,
      'change_public'  : changePublic,
      'undone_process'  : undoneProcess,
      'liquidity_rate'  : liquidityRate,
      'liquidity_lock_time'  : liquidityLockTime,
      'first_unlock_rate'  : firstUnlockRate,
      'next_unlock_rate'  : nextUnlockRate,
      'unlock_cycle_time'  : unlockCycleTime,
      'begin_at'  : beginAt,
      'end_at'  : endAt,
      'is_kyc'  : isKyc,
      'is_audit'  : isAudit,
      'logo' : logo,
      'website' : website,
      'twitter' : twitter,
      'telegram' : telegram,
      'discord' : discord,
      'facebook' : facebook,
      'github' : github,
      'instagram' : instagram,
      'reddit' : reddit,
      'description' : description,
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

  Launchpads fromMap(Map first) {
    return Launchpads(
        id: first['id'] ?? null,
        chainId: first['chain_id'] ?? 0,
        chainIndex: first['chain_index'] ?? 0,
        publisher: first['publisher'] ?? "",
        owner: first['owner'] ?? "",
        type: first['type'] ?? 0,
        contractAddress: first['contract_address'] ?? "",
        presaleAddress: first['presale_address'] ?? "",
        presaleName: first['presale_name'] ?? "",
        presaleSymbol: first['presale_symbol'] ?? "",
        presaleDecimals: first['presale_decimals'] ?? 0,
        payAddress: first['pay_address'] ?? "",
        payName: first['pay_name'] ?? "",
        paySymbol: first['pay_symbol'] ?? "",
        payDecimals: first['pay_decimals'] ?? 0,
        routerAddress: first['router_address'] ?? "",
        inviteAddress: first['invite_address'] ?? "",
        softCap: first['soft_cap'] ?? "0",
        hardCap: first['hard_cap'] ?? "0",
        minPurchase: first['min_purchase'] ?? "0",
        maxPurchase: first['max_purchase'] ?? "0",
        rate: first['rate'] ?? 0,
        price: first['price'] ?? "0",
        tokenFee: first['token_fee'] ?? 0,
        payFee: first['pay_fee'] ?? 0,
        rewardsTokenType: first['rewards_token_type'] ?? 0,
        firstLevel: first['first_level'] ?? 0,
        secondLevel: first['second_level'] ?? 0,
        referralBuy: first['referral_buy'] ?? 0,
        saleType: first['sale_type'] ?? 0,
        changePublic: first['change_public'] ?? 0,
        undoneProcess: first['undone_process'] ?? 0,
        liquidityRate: first['liquidity_rate'] ?? 0,
        liquidityLockTime: first['liquidity_lock_time'] ?? 0,
        firstUnlockRate: first['first_unlock_rate'] ?? 0,
        nextUnlockRate: first['next_unlock_rate'] ?? 0,
        unlockCycleTime: first['unlock_cycle_time'] ?? 0,
        beginAt: first['begin_at'] ?? 0,
        endAt: first['end_at'] ?? 0,
        isKyc: first['is_kyc'] ?? -1,
        isAudit: first['is_audit'] ?? 0,
        logo: first['logo'] ?? "",
        website: first['website'] ?? "",
        twitter: first['twitter'] ?? "",
        telegram: first['telegram'] ?? "",
        discord: first['discord'] ?? "",
        facebook: first['facebook'] ?? "",
        github: first['github'] ?? "",
        instagram: first['instagram'] ?? "",
        reddit: first['reddit'] ?? "",
        description: first['description'] ?? "",
        isParsed: first['is_parsed'] ?? 0,
        isRun: first['is_run'] ?? 0,
        createdAt: first['created_at'] ?? null,
        updatedAt: first['updated_at'] ?? null,
    );
  }
}
