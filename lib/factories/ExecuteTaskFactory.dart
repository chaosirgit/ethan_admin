import 'package:ethan_admin/factories/executes/AirdropLogsRandomExecute.dart';
import 'package:ethan_admin/factories/executes/AirdropLogsTopExecute.dart';
import 'package:ethan_admin/factories/executes/AirdropsExecute.dart';
import 'package:ethan_admin/factories/executes/LaunchpadLogsExecute.dart';
import 'package:ethan_admin/factories/executes/LaunchpadMasterExecute.dart';
import 'package:ethan_admin/factories/executes/LockLogsExecute.dart';
import 'package:ethan_admin/factories/executes/LocksLpMasterExecute.dart';
import 'package:ethan_admin/factories/executes/LocksNormalMasterExecute.dart';
import 'package:ethan_admin/factories/executes/StakesExecute.dart';
import 'package:ethan_admin/factories/executes/StakingLogsExecute.dart';
import 'package:ethan_admin/factories/executes/TokenMasterExecute.dart';
import 'package:ethan_admin/helpers/task.dart';

abstract class ExecuteTaskFactory {
  late Task task;
  static ExecuteTaskFactory getFactory(Task task) {
    switch (task.contractName){
      case "TokenMaster":
        return TokenMasterExecute(task);
      case "LaunchpadMaster":
        return LaunchpadMasterExecute(task);
      case "LaunchpadLogs":
        return LaunchpadLogsExecute(task);
      case "LockNormalMaster":
        return LocksNormalMasterExecute(task);
      case "LockLpMaster":
        return LocksLpMasterExecute(task);
      case "LockLogs":
        return LockLogsExecute(task);
      case "Stakes":
        return StakesExecute(task);
      case "StakingLogs":
        return StakingLogsExecute(task);
      case "Airdrops":
        return AirdropsExecute(task);
      case "AirdropLogsTop":
        return AirdropLogsTopExecute(task);
      case "AirdropLogsRandom":
        return AirdropLogsRandomExecute(task);
      default:
        throw TaskException("不支持的任务");
    }
  }
  // 获取开始索引
  Future<int> getStartIndex();
  // 获取链上记录总数
  Future<int> getTotalCount();
  // 插入新记录到数据库
  // @totalCount 总记录数量
  // @startIndex 开始索引
  Future<void> insertNewToDatabase(int totalCount, int startIndex);
  // 获取未解析的链上索引列表
  Future<List<BigInt>> getUnParsedChainIndexList();
  // 获取未解析地址列表
  Future<List<dynamic>> getUnParsedAddressList(List<BigInt> chainIndexList);
  // 根据未解析地址列表解析数据 返回进度
  // @seconds 间隔秒数
  Future<double> execute(int seconds);

  // 记录是否解析完毕
  bool isParsed(Map params);
}