import 'package:ethan_admin/models/Model.dart';

class Airdrops extends Model{
  @override
  final int? id;
  final int chainId;
  final int chainIndex;
  final String name;
  final String owner;
  final String contractAddress;
  final String tokenAddress;
  final String tokenName;
  final String tokenSymbol;
  final int tokenDecimals;
  final String inviteAddress;
  final int startTime;
  final int endTime;
  final int topCount;
  final String topRewards;
  final int randomCount;
  final String randomRewards;
  final String logo;
  final String website;
  final String banner;
  final String twitterTask;
  final int twitterPoint;
  final String tweetsTask;
  final int tweetsPoint;
  final String telegramGroupTask;
  final int telegramGroupPoint;
  final String telegramChannelTask;
  final int telegramChannelPoint;
  final String discordTask;
  final int discordPoint;
  final String youtubeTask;
  final int youtubePoint;
  final String customTask;
  final int customPoint;
  final String referTask;
  final int referPoint;
  final String description;
  final int isParsed;
  final int isRun;
  int? createdAt;
  int? updatedAt;
  get tableName => "airdrops";

  Airdrops({
    this.id = null,
    this.chainId = 0,
    this.chainIndex = 0,
    this.name = "",
    this.owner = "",
    this.contractAddress = "",
    this.tokenAddress = "",
    this.tokenName = "",
    this.tokenSymbol = "",
    this.tokenDecimals = 0,
    this.inviteAddress = "",
    this.startTime = 0,
    this.endTime = 0,
    this.topCount = 0,
    this.topRewards = "0",
    this.randomCount = 0,
    this.randomRewards = "0",
    this.logo = "",
    this.website = "",
    this.banner = "",
    this.twitterTask = "",
    this.twitterPoint = 0,
    this.tweetsTask = "",
    this.tweetsPoint = 0,
    this.telegramGroupTask = "",
    this.telegramGroupPoint = 0,
    this.telegramChannelTask = "",
    this.telegramChannelPoint = 0,
    this.discordTask = "",
    this.discordPoint = 0,
    this.youtubeTask = "",
    this.youtubePoint = 0,
    this.customTask = "",
    this.customPoint = 0,
    this.referTask = "",
    this.referPoint = 0,
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
      'name' : name,
      'owner' : owner,
      'contract_address' : contractAddress,
      'token_address' : tokenAddress,
      'token_name' : tokenName,
      'token_symbol' : tokenSymbol,
      'token_decimals' : tokenDecimals,
      'invite_address' : inviteAddress,
      'start_time' : startTime,
      'end_time' : endTime,
      'top_count' : topCount,
      'top_rewards' : topRewards,
      'random_count'  : randomCount,
      'random_rewards' : randomRewards,
      'logo'  : logo,
      'website'  : website,
      'banner'  : banner,
      'twitter_task'  : twitterTask,
      'twitter_point' : twitterPoint,
      'tweets_task' : tweetsTask,
      'tweets_point' : tweetsPoint,
      'telegram_group_task' : telegramGroupTask,
      'telegram_group_point' : telegramGroupPoint,
      'telegram_channel_task' : telegramChannelTask,
      'telegram_channel_point' : telegramChannelPoint,
      'discord_task' : discordTask,
      'discord_point' : discordPoint,
      'youtube_task' : youtubeTask,
      'youtube_point' : youtubePoint,
      'custom_task' : customTask,
      'custom_point' : customPoint,
      'refer_task' : referTask,
      'refer_point' : referPoint,
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

  Airdrops fromMap(Map first) {
    return Airdrops(
      id: first['id'] ?? null,
      chainId: first['chain_id'] ?? 0,
      chainIndex: first['chain_index'] ?? 0,
      name: first['name'] ?? "",
      owner: first['owner'] ?? "",
      contractAddress: first['contract_address'] ?? "",
      tokenAddress: first['token_address'] ?? "",
      tokenName: first['token_name'] ?? "",
      tokenSymbol: first['token_symbol'] ?? "",
      tokenDecimals: first['token_decimals'] ?? 0,
      inviteAddress: first['invite_address'] ?? "",
      startTime: first['start_time'] ?? 0,
      endTime: first['end_time'] ?? 0,
      topCount: first['top_count'] ?? 0,
      topRewards: first['top_rewards'] ?? "0",
      randomCount: first['random_count'] ?? 0,
      randomRewards: first['random_rewards'] ?? "0",
      logo: first['logo'] ?? "",
      website: first['website'] ?? "",
      banner: first['banner'] ?? "",
      twitterTask: first['twitter_task'] ?? "",
      twitterPoint: first['twitter_point'] ?? 0,
      tweetsTask: first['tweets_task'] ?? "",
      tweetsPoint: first['tweets_point'] ?? 0,
      telegramGroupTask: first['telegram_group_task'] ?? "",
      telegramGroupPoint: first['telegram_group_point'] ?? 0,
      telegramChannelTask: first['telegram_channel_task'] ?? "",
      telegramChannelPoint: first['telegram_channel_point'] ?? 0,
      discordTask: first['discord_task'] ?? "",
      discordPoint: first['discord_point'] ?? 0,
      youtubeTask: first['youtube_task'] ?? "",
      youtubePoint: first['youtube_point'] ?? 0,
      customTask: first['custom_task'] ?? "",
      customPoint: first['custom_point'] ?? 0,
      referTask: first['refer_task'] ?? "",
      referPoint: first['refer_point'] ?? 0,
      description: first['description'] ?? "",
      isParsed: first['is_parsed'] ?? 0,
      isRun: first['is_run'] ?? 0,
      createdAt: first['created_at'] ?? null,
      updatedAt: first['updated_at'] ?? null,
    );
  }
}