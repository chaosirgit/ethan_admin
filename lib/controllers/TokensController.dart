import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/models/Tokens.dart';
import 'package:get/get.dart';

class TokensController extends GetxController {
  Future<PaginateResource> getPaginateList({limit = 10, page = 1}) async {
    var pageData = await Tokens().paginate(limit: limit, page: page);
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
        switch (d['type']) {
          case 0:
            d['type_name'] = '标准代币';
            break;
          case 1:
            d['type_name'] = '费用代币';
            break;
          case 2:
            d['type_name'] = '分红代币';
            break;
          case 3:
            d['type_name'] = '高级费用代币';
            break;
        }
        if (d['logo'] == "") {
          d['logo'] = "https://img.favpng.com/9/14/13/bitcoin-computer-icons-logo-cryptocurrency-png-favpng-qRmfiDeBXAFHgQSws0TGU75Ef.jpg";
        }
        return d;
      }).toList();
    }
    return pageData;
  }
}