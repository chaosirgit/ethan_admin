import 'dart:io';

import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/helpers/task.dart';
import 'package:ethan_admin/models/Tokens.dart';
import 'package:ethan_admin/services/Web3Service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class PullChainDataController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;
  final web3 = Get.find<Web3Service>();
  bool check = false;

  Future<void> init() async {
    if (tasks.value.isEmpty) {
      for (var i = 0; i < web3.chains.length; i++) {
        if (web3.chains[i].saleMaster != "") {
            tasks.add(await Task.generateTask(web3.chains[i], "TokenMaster"));
            tasks.add(await Task.generateTask(web3.chains[i], "LaunchpadMaster"));
            tasks.add(await Task.generateTask(web3.chains[i], "LaunchpadLogs"));
            tasks.add(await Task.generateTask(web3.chains[i], "LockNormalMaster"));
            tasks.add(await Task.generateTask(web3.chains[i], "LockLpMaster"));
            tasks.add(await Task.generateTask(web3.chains[i], "LockLogs"));
            tasks.add(await Task.generateTask(web3.chains[i], "Stakes"));
            tasks.add(await Task.generateTask(web3.chains[i], "StakingLogs"));
            tasks.add(await Task.generateTask(web3.chains[i], "Airdrops"));
            tasks.add(await Task.generateTask(web3.chains[i], "AirdropLogsTop"));
            tasks.add(await Task.generateTask(web3.chains[i], "AirdropLogsRandom"));
            syncChainData();
        }
      }
    }
  }

  Future<void> stop() async {
    for (var i = 0; i < tasks.value.length; i++) {
      tasks.value[i].cancel();
      update();
    }
    check = false;
    update();
  }

  Future<void> start() async {
    for (var i = 0; i < tasks.value.length; i++) {
      tasks.value[i].start();
      update();
    }
    syncChainData();
    update();
  }

  Future<void> syncChainData() async {
    for (var i = 0; i < tasks.length; i++) {
      //异步 发送任务
      if (tasks.value[i].progress <= 1.0) {
        try {
          tasks.value[i].execute();
          update();
        } on SocketException catch (e) {
          print("连接断开: " + tasks.value[i].web3.chainId.toString());
          Get.snackbar("Error", "RPC 连接丢失 3 秒后尝试重连");
          await Future.delayed(Duration(seconds: 3));
          tasks.value[i].web3.resetClient();
          init();
          break;
        } on TaskException catch (e) {
          Get.snackbar("Error", "$e");
          break;
        } catch (e) {
          print("$e");
          break;
        }
      }
    }
    check = true;
    // 每秒检查进度
    while (check) {
      await Future.delayed(Duration(seconds:1), () async {
        var done = tasks.value.where((task) {
          return task.running == 1;
        }).toList();
        if (done.isEmpty) {
          check = false;
          Get.snackbar("Success", "所有数据同步完成");
        }
        update();
      });
    }
  }
}

class PullChainData extends StatelessWidget {
  PullChainData({Key? key}) : super(key: key);
  final PullChainDataController pcdc = Get.put(PullChainDataController());

  @override
  Widget build(BuildContext context) {
    pcdc.init();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "数据同步进度",
                    style: TextStyle(fontSize: smallTitle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              pcdc.start();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStatePropertyAll<Color>(
                                    Colors.green)),
                            child: Icon(Icons.play_arrow)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              pcdc.stop();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.red)),
                            child: Icon(Icons.pause_sharp)),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
          Expanded(
            child: GetBuilder<PullChainDataController>(
              builder: (_) {
                var children = <Widget>[];
                for (var i = 0; i < pcdc.tasks.length; i++) {
                  var icon = Icon(Icons.access_time_filled);
                  if (pcdc.tasks.value[i].running == 1) {
                    icon = Icon(Icons.downloading,color: Colors.orangeAccent,);
                  }else if (pcdc.tasks.value[i].running == 3){
                    icon = Icon(Icons.check_circle,color: Colors.green);
                  }else {
                    icon = Icon(Icons.pause_sharp,color: Colors.red);
                  }
                  children.add(Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pcdc.tasks.value[i].chainName +
                                    "-" +
                                    pcdc.tasks.value[i].name,
                                style: TextStyle(fontSize: title),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            icon,
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        LinearProgressIndicator(
                          backgroundColor: Colors.white70,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: pcdc.tasks.value[i].progress,
                        ),
                      ],
                    ),
                  ));
                }
                return ListView(
                  children: children,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
