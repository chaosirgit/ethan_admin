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
      print(await getDatabasesPath());
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
            'CREATE TABLE launchpads(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER,publisher TEXT, owner TEXT, type INTEGER,contract_address TEXT, presale_address TEXT, presale_name TEXT, presale_symbol TEXT, presale_decimals INTEGER,pay_address TEXT, pay_name TEXT,pay_symbol TEXT, pay_decimals INTEGER, router_address TEXT, invite_address TEXT, soft_cap TEXT, hard_cap TEXT,min_purchase TEXT,max_purchase TEXT,rate INTEGER,price TEXT,token_fee INTEGER,pay_fee INTEGER,rewards_token_type INTEGER,first_level INTEGER,second_level INTEGER,referral_buy INTEGER,sale_type INTEGER, change_public INTEGER, undone_process INTEGER, liquidity_rate INTEGER,liquidity_lock_time INTEGER,first_unlock_rate INTEGER,next_unlock_rate INTEGER,unlock_cycle_time INTEGER,begin_at INTEGER,end_at INTEGER,is_kyc INTEGER,is_audit INTEGER,logo TEXT, website TEXT, twitter TEXT, telegram TEXT, discord TEXT,facebook TEXT, github TEXT,instagram TEXT,reddit TEXT, description TEXT,is_parsed INTEGER,is_run INTEGER,created_at INTEGER,updated_at INTEGER);',
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

          var launchpad_logs = [
            'CREATE TABLE launchpad_logs(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, launchpad_address TEXT, address TEXT, amount TEXT, is_parsed INTEGER, is_run INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX launchpad_logs_chain_id_index on launchpad_logs(chain_id);',
            'CREATE INDEX launchpad_logs_chain_index_index on launchpad_logs(chain_index)',
            'CREATE INDEX launchpad_logs_launchpad_address_index on launchpad_logs(launchpad_address);',
            'CREATE INDEX launchpad_logs_address_index on launchpad_logs(address);',
            'CREATE INDEX launchpad_logs_is_parsed_index on launchpad_logs(is_parsed);',
            'CREATE INDEX launchpad_logs_is_run_index on launchpad_logs(is_run);',
            'CREATE UNIQUE INDEX launchpad_logs_chain_id_chain_index_unique on launchpad_logs(chain_id,chain_index,launchpad_address);',
          ];
          for (var i = 0; i < launchpad_logs.length; i++) {
            await db.execute(launchpad_logs[i]);
          }

          var locks = [
            'CREATE TABLE locks(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, token_address TEXT, name TEXT, symbol TEXT, decimals INTEGER, current_amount TEXT, is_parsed INTEGER,is_run INTEGER, block_index INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX locks_chain_id_index on locks(chain_id);',
            'CREATE INDEX locks_chain_index_index on locks(chain_index);',
            'CREATE INDEX locks_token_address_index on locks(token_address);',
            'CREATE INDEX locks_symbol_index on locks(symbol);',
            'CREATE INDEX locks_decimals_index on locks(decimals);',
            'CREATE INDEX locks_is_parsed_index on locks(is_parsed);',
            'CREATE INDEX locks_is_run_index on locks(is_run);',
            'CREATE INDEX locks_block_index_index on locks(block_index);',
            'CREATE UNIQUE INDEX locks_chain_id_chain_index_unique on locks(chain_id,chain_index)',
          ];
          for (var i = 0; i < locks.length; i++){
            await db.execute(locks[i]);
          }

          var lock_lps = [
            'CREATE TABLE lock_lps(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, token_address TEXT, name TEXT, symbol TEXT, decimals INTEGER, factory_address TEXT, token0_address TEXT, token0_name TEXT, token0_symbol TEXT, token0_decimals INTEGER,token1_address TEXT, token1_name TEXT, token1_symbol TEXT, token1_decimals INTEGER,current_amount TEXT, is_parsed INTEGER,is_run INTEGER, block_index INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX lock_lps_chain_id_index on lock_lps(chain_id);',
            'CREATE INDEX lock_lps_chain_index_index on lock_lps(chain_index);',
            'CREATE INDEX lock_lps_token_address_index on lock_lps(token_address);',
            'CREATE INDEX lock_lps_symbol_index on lock_lps(symbol);',
            'CREATE INDEX lock_lps_decimals_index on lock_lps(decimals);',
            'CREATE INDEX lock_lps_factory_address_index on lock_lps(factory_address);',
            'CREATE INDEX lock_lps_token0_address_index on lock_lps(token0_address);',
            'CREATE INDEX lock_lps_token0_symbol_index on lock_lps(token0_symbol);',
            'CREATE INDEX lock_lps_token0_decimals_index on lock_lps(token0_decimals);',
            'CREATE INDEX lock_lps_token1_address_index on lock_lps(token1_address);',
            'CREATE INDEX lock_lps_token1_symbol_index on lock_lps(token1_symbol);',
            'CREATE INDEX lock_lps_token1_decimals_index on lock_lps(token1_decimals);',
            'CREATE INDEX lock_lps_is_parsed_index on lock_lps(is_parsed);',
            'CREATE INDEX lock_lps_is_run_index on lock_lps(is_run);',
            'CREATE INDEX lock_lps_block_index_index on lock_lps(block_index);',
            'CREATE UNIQUE INDEX lock_lps_chain_id_chain_index_unique on lock_lps(chain_id,chain_index)',
          ];
          for (var i = 0; i < lock_lps.length; i++){
            await db.execute(lock_lps[i]);
          }

          var lock_logs = [
            'CREATE TABLE lock_logs(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, chain_lock_id INTEGER, token_address TEXT, owner TEXT, amount TEXT, lock_time INTEGER, first_unlock_time INTEGER, first_unlock_rate INTEGER, unlock_cycle INTEGER, unlock_cycle_rate INTEGER, already_unlock_amount TEXT,description TEXT, is_parsed INTEGER, is_run INTEGER,block_index INTEGER, created_at INTEGER,updated_at INTEGER)',
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

          var stakes = [
            'CREATE TABLE stakes(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, staking_address TEXT, token_address TEXT, token_name TEXT, token_symbol TEXT, token_decimals INTEGER, reward_address TEXT, reward_name TEXT, reward_symbol TEXT, reward_decimals INTEGER, type INTEGER, start_time INTEGER, end_time INTEGER, lock_period INTEGER, apr INTEGER, pool_cap TEXT, total_reward TEXT, is_parsed INTEGER, is_run INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX stakes_chain_id_index on stakes(chain_id);',
            'CREATE INDEX stakes_chain_index_index on stakes(chain_index)',
            'CREATE INDEX stakes_staking_address_index on stakes(staking_address);',
            'CREATE INDEX stakes_token_address_index on stakes(token_address);',
            'CREATE INDEX stakes_reward_address_index on stakes(reward_address);',
            'CREATE INDEX stakes_type_index on stakes(type);',
            'CREATE INDEX stakes_is_parsed_index on stakes(is_parsed);',
            'CREATE INDEX stakes_is_run_index on stakes(is_run);',
            'CREATE UNIQUE INDEX stakes_chain_id_chain_index_unique on stakes(chain_id,chain_index);',
          ];
          for (var i = 0; i < stakes.length; i++){
            await db.execute(stakes[i]);
          }

          var staking_logs = [
            'CREATE TABLE staking_logs(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, staking_address TEXT, owner TEXT, amount TEXT, unlock_time INTEGER, last_time INTEGER, is_parsed INTEGER, is_run INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX staking_logs_chain_id_index on staking_logs(chain_id);',
            'CREATE INDEX staking_logs_chain_index_index on staking_logs(chain_index)',
            'CREATE INDEX staking_logs_staking_address_index on staking_logs(staking_address);',
            'CREATE INDEX staking_logs_owner_index on staking_logs(owner);',
            'CREATE INDEX staking_logs_unlock_time_index on staking_logs(unlock_time);',
            'CREATE INDEX staking_logs_last_time_index on staking_logs(last_time);',
            'CREATE INDEX staking_logs_is_parsed_index on staking_logs(is_parsed);',
            'CREATE INDEX staking_logs_is_run_index on staking_logs(is_run);',
            'CREATE UNIQUE INDEX staking_logs_chain_id_chain_index_unique on staking_logs(chain_id,chain_index,staking_address);',
          ];
          for (var i = 0; i < staking_logs.length; i++){
            await db.execute(staking_logs[i]);
          }

          var airdrops = [
            'CREATE TABLE airdrops(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, name TEXT, owner TEXT,contract_address TEXT, token_address TEXT, token_name TEXT, token_symbol TEXT,token_decimals INTEGER, invite_address TEXT, start_time INTEGER, end_time INTEGER,top_count INTEGER,top_rewards TEXT,random_count INTEGER,random_rewards TEXT,logo TEXT,website TEXT,banner TEXT,twitter_task TEXT,twitter_point INTEGER,tweets_task TEXT,tweets_point INTEGER, telegram_group_task TEXT, telegram_group_point INTEGER, telegram_channel_task TEXT, telegram_channel_point INTEGER, discord_task TEXT, discord_point INTEGER, youtube_task TEXT, youtube_point INTEGER, custom_task TEXT, custom_point INTEGER, refer_task TEXT, refer_point INTEGER, description TEXT,is_parsed INTEGER,is_run INTEGER,created_at INTEGER,updated_at INTEGER);',
            'CREATE INDEX airdrops_chain_id_index on airdrops(chain_id);',
            'CREATE INDEX airdrops_chain_index_index on airdrops(chain_index);',
            'CREATE INDEX airdrops_owner_index on airdrops(owner);',
            'CREATE INDEX airdrops_contract_address_index on airdrops(contract_address);',
            'CREATE INDEX airdrops_token_address_index on airdrops(token_address);',
            'CREATE INDEX airdrops_invite_address_index on airdrops(invite_address);',
            'CREATE INDEX airdrops_start_time_index on airdrops(start_time);',
            'CREATE INDEX airdrops_end_time_index on airdrops(end_time);',
            'CREATE INDEX airdrops_is_parsed_index on airdrops(is_parsed);',
            'CREATE INDEX airdrops_is_run_index on airdrops(is_run);',
            'CREATE INDEX airdrops_created_at_index on airdrops(created_at);',
            'CREATE INDEX airdrops_updated_at_index on airdrops(updated_at);',
            'CREATE UNIQUE INDEX airdrops_chain_id_chain_index_unique on airdrops(chain_id,chain_index)',
          ];
          for (var i = 0; i < airdrops.length; i++){
            await db.execute(airdrops[i]);
          }

          var airdrop_logs = [
            'CREATE TABLE airdrop_logs(id INTEGER PRIMARY KEY AUTOINCREMENT, chain_id INTEGER,chain_index INTEGER, airdrop_address TEXT, type INTEGER, address TEXT, rewards TEXT, claimed TEXT, is_parsed INTEGER, is_run INTEGER, created_at INTEGER,updated_at INTEGER)',
            'CREATE INDEX airdrop_logs_chain_id_index on airdrop_logs(chain_id);',
            'CREATE INDEX airdrop_logs_chain_index_index on airdrop_logs(chain_index)',
            'CREATE INDEX airdrop_logs_airdrop_address_index on airdrop_logs(airdrop_address);',
            'CREATE INDEX airdrop_logs_type_index on airdrop_logs(type);',
            'CREATE INDEX airdrop_logs_address_index on airdrop_logs(address);',
            'CREATE INDEX airdrop_logs_is_parsed_index on airdrop_logs(is_parsed);',
            'CREATE INDEX airdrop_logs_is_run_index on airdrop_logs(is_run);',
            'CREATE UNIQUE INDEX airdrop_logs_chain_id_chain_index_unique on airdrop_logs(chain_id,chain_index,airdrop_address,type);',
          ];
          for (var i = 0; i < airdrop_logs.length; i++){
            await db.execute(airdrop_logs[i]);
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
