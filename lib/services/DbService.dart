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
        onCreate: (db, version) async {
          // Run the CREATE TABLE statement on the database.
          var tokens = [
            'CREATE TABLE tokens(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER,owner TEXT, token_address TEXT, type INTEGER, name TEXT, symbol TEXT,decimals INTEGER, total_supply TEXT,logo TEXT,invite_address TEXT,enable_bot INTEGER, is_kyc INTEGER, is_audit INTEGER,is_parsed INTEGER,created_at INTEGER,updated_at INTEGER);',
            'CREATE INDEX tokens_chain_id_index on tokens(chain_id);',
            'CREATE INDEX tokens_chain_index_index on tokens(chain_index);',
            'CREATE INDEX tokens_owner_index on tokens(owner);',
            'CREATE INDEX tokens_token_address_index on tokens(token_address);',
            'CREATE INDEX tokens_type_index on tokens(type);',
            'CREATE INDEX tokens_symbol_index on tokens(symbol);',
            'CREATE INDEX tokens_decimals_index on tokens(decimals);',
            'CREATE INDEX tokens_invite_address_index on tokens(invite_address);',
            'CREATE INDEX tokens_enable_bot_index on tokens(enable_bot);',
            'CREATE INDEX tokens_is_kyc_index on tokens(is_kyc);',
            'CREATE INDEX tokens_is_audit_index on tokens(is_audit);',
            'CREATE INDEX tokens_is_parsed_index on tokens(is_parsed);',
            'CREATE INDEX tokens_created_at_index on tokens(created_at);',
            'CREATE INDEX tokens_updated_at_index on tokens(updated_at);',
            'CREATE UNIQUE INDEX tokens_chain_id_chain_index_unique on tokens(chain_id,chain_index)',
          ];
          for (var i = 0; i < tokens.length; i++){
            await db.execute(tokens[i]);
          }
          var launchpads = [
            'CREATE TABLE launchpads(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER,publisher TEXT, owner TEXT, type INTEGER,contract_address TEXT, presale_address TEXT, pay_address TEXT, pay_symbol TEXT,router_address TEXT, invite_address TEXT, soft_cap TEXT, hard_cap TEXT,min_purchase TEXT,max_purchase TEXT,rate INTEGER,price TEXT,token_fee INTEGER,pay_fee INTEGER,rewards_token_type INTEGER,first_level INTEGER,second_level INTEGER,referral_buy INTEGER,sale_type INTEGER, change_public INTEGER, undone_process INTEGER, liquidity_rate INTEGER,liquidity_lock_time INTEGER,first_unlock_rate INTEGER,next_unlock_rate INTEGER,unlock_cycle_time INTEGER,begin_at INTEGER,end_at INTEGER,is_kyc INTEGER,is_audit INTEGER,logo TEXT, website TEXT, twitter TEXT, telegram TEXT, discord TEXT,facebook TEXT, github TEXT,instagram TEXT,reddit TEXT, description TEXT,is_parsed INTEGER,is_run INTEGER,created_at INTEGER,updated_at INTEGER);',
            'CREATE INDEX launchpads_chain_id_index on launchpads(chain_id);',
            'CREATE INDEX launchpads_chain_index_index on launchpads(chain_index);',
            'CREATE INDEX launchpads_publisher_index on launchpads(publisher);',
            'CREATE INDEX launchpads_owner_index on launchpads(owner);',
            'CREATE INDEX launchpads_type_index on launchpads(type);',
            'CREATE INDEX launchpads_contract_address_index on launchpads(contract_address);',
            'CREATE INDEX launchpads_presale_address_index on launchpads(presale_address);',
            'CREATE INDEX launchpads_pay_address_index on launchpads(pay_address);',
            'CREATE INDEX launchpads_router_address_index on launchpads(router_address);',
            'CREATE INDEX launchpads_invite_address_index on launchpads(invite_address);',
            'CREATE INDEX launchpads_pay_symbol_index on launchpads(pay_symbol);',
            'CREATE INDEX launchpads_rewards_token_type_index on launchpads(rewards_token_type);',
            'CREATE INDEX launchpads_sale_type_index on launchpads(sale_type);',
            'CREATE INDEX launchpads_undone_process_index on launchpads(undone_process);',
            'CREATE INDEX launchpads_begin_at_index on launchpads(begin_at);',
            'CREATE INDEX launchpads_end_at_index on launchpads(end_at);',
            'CREATE INDEX launchpads_is_kyc_index on launchpads(is_kyc);',
            'CREATE INDEX launchpads_is_audit_index on launchpads(is_audit);',
            'CREATE INDEX launchpads_is_parsed_index on launchpads(is_parsed);',
            'CREATE INDEX launchpads_is_run_index on launchpads(is_run);',
            'CREATE INDEX launchpads_created_at_index on launchpads(created_at);',
            'CREATE INDEX launchpads_updated_at_index on launchpads(updated_at);',
            'CREATE UNIQUE INDEX launchpads_chain_id_chain_index_unique on launchpads(chain_id,chain_index)',
          ];
          for (var i = 0; i < launchpads.length; i++){
            await db.execute(launchpads[i]);
          }

          var locks = [
            'CREATE TABLE locks(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, type INTEGER, token_address TEXT, name TEXT, symbol TEXT, decimals INTEGER, factory_address TEXT, current_amount TEXT, is_parsed INTEGER,is_run INTEGER, block_index INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX locks_chain_id_index on locks(chain_id);',
            'CREATE INDEX locks_chain_index_index on locks(chain_index);',
            'CREATE INDEX locks_type_index on locks(type);',
            'CREATE INDEX locks_token_address_index on locks(token_address);',
            'CREATE INDEX locks_symbol_index on locks(symbol);',
            'CREATE INDEX locks_decimals_index on locks(decimals);',
            'CREATE INDEX locks_factory_address_index on locks(factory_address);',
            'CREATE INDEX locks_is_parsed_index on locks(is_parsed);',
            'CREATE INDEX locks_is_run_index on locks(is_run);',
            'CREATE INDEX locks_block_index_index on locks(block_index);',
            'CREATE UNIQUE INDEX locks_chain_id_chain_index_type_unique on locks(chain_id,chain_index,type)',
          ];
          for (var i = 0; i < locks.length; i++){
            await db.execute(locks[i]);
          }

          var lock_logs = [
            'CREATE TABLE lock_logs(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, chain_lock_id INTEGER, token_address TEXT, owner TEXT, amount TEXT, lock_time INTEGER, first_unlock_time INTEGER, first_unlock_rate INTEGER, already_unlock_amount TEXT, available_unlock_amount TEXT, description TEXT, is_parsed INTEGER, is_run INTEGER,block_index INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX lock_logs_chain_id_index on lock_logs(chain_id);',
            'CREATE INDEX lock_logs_chain_index_index on lock_logs(chain_index)',
            'CREATE INDEX lock_logs_chain_lock_id_index on lock_logs(chain_lock_id);',
            'CREATE INDEX lock_logs_token_address_index on lock_logs(token_address);',
            'CREATE INDEX lock_logs_owner_index on lock_logs(owner);',
            'CREATE INDEX lock_logs_is_parsed_index on lock_logs(is_parsed);',
            'CREATE INDEX lock_logs_is_run_index on lock_logs(is_run);',
            'CREATE INDEX lock_logs_block_index_index on lock_logs(block_index);',
            'CREATE UNIQUE INDEX lock_logs_chain_id_chain_lock_id_unique on lock_logs(chain_id,chain_lock_id);',
          ];
          for (var i = 0; i < lock_logs.length; i++){
            await db.execute(lock_logs[i]);
          }
          // db.execute(
          //   'CREATE TABLE contract(id INTEGER PRIMARY KEY AUTOINCREMENT,chain_id INTEGER, name TEXT, public_key TEXT, abi TEXT)',
          // );
          return;
        },
        version: 2,
      );
      ic.changeMessages(ServiceStatus(name: "数 据 库 服 务",successful: 1));
      return this;
    } catch (e) {
      print(e);
      ic.changeMessages(ServiceStatus(name: "数 据 库 服 务",successful: 2));
      return this;
    }

  }
}
