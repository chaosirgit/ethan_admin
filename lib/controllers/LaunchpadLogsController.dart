import 'package:ethan_admin/models/LaunchpadLogs.dart';
import 'package:get/get.dart';
import 'package:ethan_admin/models/Model.dart';

class LaunchPadLogsController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10,page = 1}) async {
    var pageData = await LaunchpadLogs().paginate(limit: limit, page: page,orderBy: 'launchpad_address asc,chain_index desc');
    if (pageData.data.isNotEmpty) {
      pageData.data = pageData.data.map((e) {
        var d = Map.of(e);
        if (d['chain_id'] == 97){
          d['chain_name'] = "币安测试链";
        }
        return d;
      }).toList();
    }
    return pageData;
  }
}