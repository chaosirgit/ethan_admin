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
    tasks.value = [];
    for (var i = 0; i < web3.chains.length; i++) {
      if (web3.chains[i].saleMaster != "") {
        try {
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
          update();
        } on SocketException catch (e) {
          print("连接断开: " + web3.chains[i].chainId.toString());
          Get.snackbar("Error", "RPC 连接丢失 3 秒后尝试重连");
          await Future.delayed(Duration(seconds: 3));
          web3.init();
          init();
        } on TaskException catch (e) {
          print("$e");
        } catch (e) {
          print("$e");
        }
      }
    }
  }

  Future<void> stop() async {
    for (var i = 0; i < tasks.value.length; i++) {
      tasks.value[i].cancel();
    }
    check = false;
    update();
  }

  Future<void> start() async {
    for (var i = 0; i < tasks.value.length; i++) {
      tasks.value[i].start();
    }
    check = true;
    update();
  }

  Future<void> syncChainData() async {
    for (var i = 0; i < tasks.length; i++) {
      //异步 发送任务
      if (tasks.value[i].progress < 1.0) {
        tasks.value[i].execute();
      }
    }
    check = true;
    // 每秒检查进度
    while (check) {
      await Future.delayed(Duration(seconds:1), () async {
        var done = tasks.value.where((task) {
          return task.progress < 1.0;
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
                              pcdc.init();
                            },
                            child: Icon(Icons.sync)),
                      ),
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
                  children.add(Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Text(
                          pcdc.tasks.value[i].chainName +
                              "-" +
                              pcdc.tasks.value[i].name,
                          style: TextStyle(fontSize: title),
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
