import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/services/StorageService.dart';
import 'package:ethan_admin/views/pages/Login.dart';
import 'package:get/get.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  int? priority;
  LoginMiddleware({this.priority});
  @override
  GetPage? onPageCalled(GetPage? page) {
    // TODO: implement onPageCalled
    final storage = Get.find<StorageService>();
    var a = storage.box.read("account");
    if ( a == null) {
      return GetPage(name: '/login', page: () => Login());
    }else {
      if (a != LOGIN_ADDRESS){
        Get.snackbar("Error", "Sorry, The account does not have permission.");
        return GetPage(name: '/login', page: () => Login());
      }
    }
    return super.onPageCalled(page);
  }
}
