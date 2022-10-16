import 'package:ethan_admin/models/Launchpads.dart';
import 'package:get/get.dart';
import 'package:ethan_admin/models/Model.dart';

class LaunchpadsController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10,page = 1}) async {
    var pageData = await Launchpads().paginate(limit: limit, page: page);
    if (pageData.data.isNotEmpty) {
      pageData.data = pageData.data.map((e) {
        var d = Map.of(e);
        if (d['chain_id'] == 97){
          d['chain_name'] = "币安测试链";
        }
        switch (d['type']) {
          case 0:
            d['type_name'] = 'Normal';
            break;
          case 1:
            d['type_name'] = 'Fair';
            break;
        }
        return d;
      }).toList();
    }
    return pageData;
  }
}