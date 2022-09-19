import 'package:ethan_admin/config/constants.dart';
import 'package:ethan_admin/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginateListController extends GetxController {
  int total = 0; //总条数
  int page = 1; //当前页
  int limit = 10;
  List<String> attributes = [];
  List data = []; // 数据
  late  MyResponse Function(int page,int limit) getData;

  void changeLimit(int? newLimit) {
    limit = newLimit ?? 10;
    page = 1;
    data = [];
    update();
    setData();
  }

  void changePage(int newPage) {
    page = newPage;
    setData();
  }

  void setData(){
    MyResponse res = getData(page,limit);
    data = res.data['data'];
    total = res.data['total'];
    update();
  }

  MyResponse testData(int page,int limit) {
    var response = new MyResponse();
    response.data['total'] = 0;
    response.data['page'] = page;
    response.data['limit'] = limit;
    response.data['data'] = [];
    for (var i = 1; i <= limit; i++) {
      response.data['data']
          .add({"id": i + limit* (page - 1), "name": "Text Name Page $page"});
    }
    return response;
  }
}

// 分页列表
class PaginateList extends StatelessWidget {
  final PaginateListController plc = Get.put(PaginateListController());
  List<String> attributes;
  String? header;

  PaginateList({
    Key? key,
    required this.attributes,
    required MyResponse Function(int page,int limit) getData,
    this.header,
  }) {
    plc.attributes = this.attributes;
    plc.getData = getData;
    plc.setData();
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = attributes.map((e) {
      return DataColumn(label: Text(e));
    }).toList();
    List<DataRow> rows = plc.data.map((e) {
      return DataRow(cells:plc.attributes.map((k) => DataCell(Text(e[k].toString()))).toList());
    }).toList();
    return GetBuilder<PaginateListController>(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$header",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: defaultPadding,
              columns: columns,
              rows: rows,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(onPressed: () {}, child: Text('1')),
            ElevatedButton(onPressed: () {}, child: Text('2')),
            ElevatedButton(onPressed: () {}, child: Text('3')),
            ElevatedButton(onPressed: () {}, child: Text('4')),
          ],)
        ],
      );
    });
  }
}
