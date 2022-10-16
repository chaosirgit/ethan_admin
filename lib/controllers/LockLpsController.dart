import 'package:ethan_admin/models/LaunchpadLogs.dart';
import 'package:ethan_admin/models/LockLps.dart';
import 'package:ethan_admin/models/Locks.dart';
import 'package:get/get.dart';
import 'package:ethan_admin/models/Model.dart';

class LockLpsController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10,page = 1}) async {
    var pageData = await LockLps().paginate(limit: limit, page: page);
    if (pageData.data.isNotEmpty) {
      pageData.data = pageData.data.map((e) {
        var d = Map.of(e);
        if (d['chain_id'] == 97){
          d['chain_name'] = "币安测试链";
        }
        d['pair_name'] = d['token0_symbol'] + '/' + d['token1_symbol'];
        return d;
      }).toList();
    }
    return pageData;
  }
}