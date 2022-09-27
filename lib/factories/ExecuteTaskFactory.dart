import 'package:ethan_admin/factories/executes/LaunchpadMasterExecute.dart';
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