import 'package:ethan_admin/services/DbService.dart';
import 'package:get/get.dart';

abstract class Model {
  late final int? id;
  static final dbService = Get.find<DbService>();
  get tableName;
  Map<String, Object?> toMap();
  Model fromMap(Map<String, Object?> map);

  Future<Model> save() async {
    if (id == null || id as int <= 0) {
      id = await dbService.db.insert(tableName, toMap());
    } else {
      if (await exists()) {
        var m = toMap();
        m['updated_at'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await Model.dbService.db
            .update(tableName, m, where: 'id = ?', whereArgs: [id]);
      }
    }
    return this;
  }

  Future<int> delete() async {
    if (id != null && id as int > 0) {
      if (await exists()) {
        return await dbService.db
            .delete(tableName, where: 'id = ?', whereArgs: [id]);
      }
    }
    return 0;
  }

  Future<bool> exists() async {
    if (id != null && id as int > 0) {
      var data = await find(id as int);
      if (data.isNotEmpty && data["id"] as int > 0) {
        return true;
      }
    }
    return false;
  }

  Future<Map<String, Object?>> find(int id) async {
    List<Map<String, Object?>> results =
        await dbService.db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return results.first;
  }

  Future<List<Map<String, Object?>>> all() async {
    var results = <Map<String, Object?>>[];
    List<Map<String,Object?>> rows = await dbService.db.query(tableName);
    if (rows.isNotEmpty) {
      return rows;
    }
    return results;
  }

  Future<List<Map<String, Object?>>> get(
      {String? where,
      List<Object?>? whereArgs,
      int? limit,
      int? offset,
      String? orderBy}) async {
    var results = <Map<String,Object?>>[];
    List<Map<String, Object?>> rows = await dbService.db.query(tableName,
        where: where,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset,
        orderBy: orderBy);
    if (rows.isNotEmpty) {
      return rows;
    }
    return results;
  }

  Future<int> count({String? where, List<Object?>? whereArgs}) async {
    var rows = await dbService.db.query(tableName,
        where: where, whereArgs: whereArgs, columns: ['count(*) as total']);
    if (rows.isNotEmpty) {
      return rows.first['total'] as int;
    }
    return 0;
  }

  Future<Map<String, Object?>> first({String? where, List<Object?>? whereArgs, String orderBy = 'id desc'}) async {
    List<Map<String, Object?>> rows = await get(
        where: where, whereArgs: whereArgs, limit: 1, orderBy: orderBy);
    if (rows.isNotEmpty) {
      return Map.of(rows.first);
    }
    return fromMap({}).toMap();
  }


}
