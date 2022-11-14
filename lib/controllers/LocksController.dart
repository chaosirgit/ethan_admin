import 'package:ethan_admin/models/LaunchpadLogs.dart';
import 'package:ethan_admin/models/Locks.dart';
import 'package:get/get.dart';
import 'package:ethan_admin/models/Model.dart';

class LocksController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10,page = 1}) async {
    var pageData = await Locks().paginate(limit: limit, page: page);
    if (pageData.data.isNotEmpty) {
      pageData.data = pageData.data.map((e) {
        var d = Map.of(e);
        if (d['chain_id'] == 97){
          d['chain_name'] = "币安测试链";
        }else if (d['chain_id'] == 56) {
          d['chain_name'] = "币安链";
        }else if (d['chain_id'] == 1) {
          d['chain_name'] = "以太链";
        }else if (d['chain_id'] == 5) {
          d['chain_name'] = "以太测试链";
        }
        return d;
      }).toList();
    }
    return pageData;
  }
}