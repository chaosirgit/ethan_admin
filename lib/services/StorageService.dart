
import 'package:ethan_admin/views/pages/Init.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage box;
  final InitController ic = Get.put(InitController());
  Future<StorageService> init() async {
    try {
      ic.changeMessages(ServiceStatus(name: "缓存服务", successful:3));
      GetStorage.init();
      box = GetStorage();
      print("storage service started...");
      ic.changeMessages(ServiceStatus(name: "缓存服务", successful:1));
      return this;
    } catch (e) {
      ic.changeMessages(ServiceStatus(name: "缓存服务",successful: 2));
      return this;
    }

  }
}