import 'package:ethan_admin/models/LaunchpadLogs.dart';
import 'package:ethan_admin/models/LockLogs.dart';
import 'package:ethan_admin/models/Locks.dart';
import 'package:get/get.dart';
import 'package:ethan_admin/models/Model.dart';

class LockLogsController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10,page = 1}) async {
    var pageData = await LockLogs().paginate(limit: limit, page: page);
    if (pageData.data.isNotEmpty) {
      pageData.data = pageData.data.map((e) {
        var d = Map.of(e);
        if (d['chain_id'] == 97){
          d['chain_name'] = "币安测试链";
        }
        d['lock_time_format'] = DateTime.fromMillisecondsSinceEpoch(d['lock_time'] * 1000).toString();
        d['first_unlock_time_format'] = DateTime.fromMillisecondsSinceEpoch(d['first_unlock_time'] * 1000).toString();
        return d;
      }).toList();
    }
    return pageData;
  }
}