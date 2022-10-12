import 'dart:core';
import 'dart:io';

import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:ethan_admin/models/Model.dart';
import 'package:ethan_admin/views/components/Search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginateListController extends GetxController {
  int total = 0; //总条数
  int page = 1; //当前页
  int limit = 10;
  List<String> attributes = [];
  List<String> attributeNames = [];
  List data = []; // 数据
  late Future<PaginateResource> Function(int page, int limit) getData;
  bool inputPage = false;
  bool loading = true;

  Future<void> change() async {
    loading = true;
    update();
    var res = await getData.call(page, limit);
    loading = false;
    data = res.data;
    total = res.total;
    update();
  }

  get pages => (total + limit - 1) ~/ limit;

  get firstPage => page <= 1
      ? null
      : () {
          page = 1;
          change();
        };

  get beforePage => page <= 1
      ? null
      : () {
          page -= 1;
          change();
        };

  get nextPage => page >= pages
      ? null
      : () {
          page += 1;
          change();
        };

  get lastPage => page >= pages
      ? null
      : () {
          page = pages;
          change();
        };

  get selectPage => () {
        inputPage = !inputPage;
        update();
      };

  get currentWidget {
    if (!inputPage) {
      return Text("$page/$pages");
    } else {
      return SizedBox(
          width: 37,
          height: 16,
          child: TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            cursorColor: Colors.white70,
            onSubmitted: (d) {
              page = int.parse(d);
              inputPage = false;
              change();
            },
          ));
    }
  }

  static Future<MyResponse> testData(int page, int limit) async {
    var response = MyResponse();
    response.data['total'] = 1000;
    response.data['page'] = page;
    response.data['limit'] = limit;
    response.data['data'] = [];
    if (page <= (1000 + limit - 1) ~/ limit) {
      for (var i = 1; i <= limit; i++) {
        response.data['data'].add(
            {"id": i + limit * (page - 1), "name": "Text Name Page $page"});
      }
    }
    await Future.delayed(Duration(milliseconds: 300));
    return response;
  }
}

// 分页列表
class PaginateList extends StatelessWidget {
  final PaginateListController plc = Get.put(PaginateListController());

  String? header;

  PaginateList({
    Key? key,
    required List<String> attributes,
    List<String>? attributeNames,
    required Future<PaginateResource> Function(int page, int limit) getData,
    this.header,
  }) {
    plc.attributes = attributes;
    plc.attributeNames = attributeNames ?? [];
    plc.getData = getData;
    plc.change();
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = plc.attributeNames.isNotEmpty ? plc.attributeNames.map((e) {
      return DataColumn(label: Text(e));
    }).toList() : plc.attributes.map((e) {
      return DataColumn(label: Text(e));
    }).toList();
    return GetBuilder<PaginateListController>(builder: (_) {
      List<DataRow> rows = plc.data.map((e) {
        return DataRow(
            cells: plc.attributes.map((k) {
                  if (k == "logo"){
                    return DataCell(Image.network(e[k].toString(),width: 50,height: 50,));
                  }else {
                    return DataCell(Text(e[k].toString()));
                  }
            }).toList());
      }).toList();†
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "$header",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: SizedBox(
              width: double.infinity,
              child: plc.loading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: defaultPadding,
                  columns: columns,
                  rows: rows,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: plc.firstPage,
                  child: Icon(Icons.first_page),
                ),
                ElevatedButton(
                    onPressed: plc.beforePage,
                    child: Icon(Icons.navigate_before)),
                ElevatedButton(
                    onPressed: plc.selectPage, child: plc.currentWidget),
                ElevatedButton(
                    onPressed: plc.nextPage, child: Icon(Icons.navigate_next)),
                ElevatedButton(
                    onPressed: plc.lastPage, child: Icon(Icons.last_page)),
              ],
            ),
          )
        ],
      );
    });
  }
}
