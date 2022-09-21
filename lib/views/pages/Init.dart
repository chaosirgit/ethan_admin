
import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/services/DbService.dart';
import 'package:ethan_admin/services/StorageService.dart';
import 'package:ethan_admin/services/Web3Service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ServiceStatus {
  String name;
  int successful; // 0 waiting 1 success, 2 error
  ServiceStatus({this.name = "",this.successful = 0});
}

class InitController extends GetxController {
  List<ServiceStatus> initMessages = [
    ServiceStatus(name: "数 据 库 服 务",successful: 0),
    ServiceStatus(name: "缓  存  服  务",successful: 0),
    ServiceStatus(name: "以太坊 Web3 通信",successful: 0),
    ServiceStatus(name: "币安链 Web3 通信",successful: 0),
    ServiceStatus(name: "币安测试 Web3 通信",successful: 0),
  ];

  void changeMessages(ServiceStatus message) {
    this.initMessages = this.initMessages.map((m){
      if (m.name == message.name) {
        m.successful = message.successful;
      }
      return m;
    }).toList();
    update();

  }


  Future<void> initService() async {
    await Get.putAsync(() => DbService().init());
    await Get.putAsync(() => StorageService().init());
    await Get.putAsync(() => Web3Service().init());
    var err = this.initMessages.where((e) => e.successful != 1).toList();
    if (err.length == 0) {
      Get.offAllNamed("/");
    }
  }
}

class Init extends StatelessWidget {

  final InitController ic = Get.put(InitController());

  // Widget child;
  @override
  Widget build(BuildContext context) {
    ic.initService();
    return Scaffold(
        body: SafeArea(
      //异形屏适配
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          flex: 5,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "Check and install services",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                /// Name 输入框
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SizedBox(
                    height: 400,
                    width: 600,
                    child: GetBuilder<InitController>(
                      builder: (_) {
                        return ListView(
                          padding: EdgeInsets.all(defaultPadding),

                          children: ic.initMessages.map((ss) {
                            var color = Colors.white;
                            var icon = Icons.sync;
                            if (ss.successful == 1){
                              color = Colors.lightGreenAccent;
                              icon = Icons.check_circle;
                            }else if (ss.successful == 2){
                              color = Colors.red;
                              icon = Icons.cancel;
                            }else if (ss.successful == 3){
                              color = Colors.yellowAccent;
                              icon = Icons.access_time_filled;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ss.name,style: TextStyle(color: color),),
                                  Text("-----------------------------",style: TextStyle(color: color),),
                                  Icon(icon,color: color,),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
