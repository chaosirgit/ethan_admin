import 'dart:io';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import '../views/pages/Init.dart';

class DbService extends GetxService {
  late final Database db;
  final InitController ic = Get.put(InitController());

  Future<DbService> init() async {
    ic.changeMessages(ServiceStatus(name: "数 据 库 服 务", successful:3));
    try {
      WidgetsFlutterBinding.ensureInitialized();
      db = await openDatabase(
        join(await getDatabasesPath(), 'admin.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          db.execute(
            'CREATE TABLE tokens(id INTEGER PRIMARY KEY AUTOINCREMENT, owner TEXT, token_address TEXT, type INTEGER, name TEXT, symbol TEXT,decimals INTEGER, total_supply REAL,logo TEXT,invite_address TEXT,enable_bot INTEGER, is_kyc INTEGER, is_audit INTEGER,is_parsed INTEGER,created_at INTEGER,updated_at INTEGER)',
          );
          var token_indexs = [
            'CREATE INDEX tokens_chain_id_index on tokens(chain_id)',
            'CREATE INDEX tokens_owner_index on tokens(owner)',
            'CREATE INDEX tokens_token_address_index on tokens(token_address)',
            'CREATE INDEX tokens_type_index on tokens(type)',
            'CREATE INDEX tokens_symbol_index on tokens(symbol)',
            'CREATE INDEX tokens_decimals_index on tokens(decimals)',
            'CREATE INDEX tokens_invite_address_index on tokens(invite_address)',
            'CREATE INDEX tokens_enable_bot_index on tokens(enable_bot)',
            'CREATE INDEX tokens_is_kyc_index on tokens(is_kyc)',
            'CREATE INDEX tokens_is_audit_index on tokens(is_audit)',
            'CREATE INDEX tokens_is_parsed_index on tokens(is_parsed)',
            'CREATE INDEX tokens_created_at_index on tokens(created_at)',
            'CREATE INDEX tokens_updated_at_index on tokens(updated_at)',
          ];
          token_indexs.map((e) => db.execute(e));
          // db.execute(
          //   'CREATE TABLE contract(id INTEGER PRIMARY KEY AUTOINCREMENT,chain_id INTEGER, name TEXT, public_key TEXT, abi TEXT)',
          // );
          return;
        },
        version: 1,
      );
      ic.changeMessages(ServiceStatus(name: "数 据 库 服 务",successful: 1));
      return this;
    } catch (e) {
      ic.changeMessages(ServiceStatus(name: "数 据 库 服 务",successful: 2));
      return this;
    }

  }
}
