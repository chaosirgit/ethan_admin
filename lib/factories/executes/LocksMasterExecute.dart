import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Locks.dart';

import '../ExecuteTaskFactory.dart';

class LocksMasterExecute implements ExecuteTaskFactory {
  @override
  Task task;
  LocksMasterExecute(this.task);

  @override
  Future<double> execute(int seconds) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  Future<int> getStartIndex() async {
    return await Locks().count(where: "chain_id = ?", whereArgs: [task.chainId]);
  }

  @override
  Future<int> getTotalCount() {
    // TODO: implement getTotalCount
    throw UnimplementedError();
  }

  @override
  Future<List> getUnParsedAddressList(List<BigInt> chainIndexList) {
    // TODO: implement getUnParsedAddressList
    throw UnimplementedError();
  }

  @override
  Future<List<BigInt>> getUnParsedChainIndexList() {
    // TODO: implement getUnParsedChainIndexList
    throw UnimplementedError();
  }

  @override
  Future<void> insertNewToDatabase(int totalCount, int startIndex) {
    // TODO: implement insertNewToDatabase
    throw UnimplementedError();
  }

  @override
  bool isParsed(Map params) {
    // TODO: implement isParsed
    throw UnimplementedError();
  }

}