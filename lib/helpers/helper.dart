import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class MyResponse {
  int code;
  String message;
  Map data;

  MyResponse({this.code = 200, this.message = "", data}) : data = data ?? {};


  static MyResponse fromJsonString(String jsonString) {
    try {
      var json = jsonDecode(jsonString);
      return MyResponse(
          code: json['code'], message: json['message'], data: json['data']);
    } on FormatException catch (_) {
      return MyResponse(code: 400400, message: "Json Format Error", data: {});
    } catch (e) {
      return MyResponse(code: 400500, message: "Json Parsed Error", data: {});
    }
  }

  @override
  String toString() {
    return "MyResponse: {code: $code, message: $message, data: $data}";
  }
}

class MyRequest extends GetConnect {
  MyRequest();

  static Future<MyResponse> getFromUrl(String url,
      {Map<String, dynamic>? query}) async {
    var req = GetConnect();
    var res = await req.get(url, query: query);
    return MyResponse.fromJsonString(res.bodyString as String);
  }

  static Future<MyResponse> postFromUrl(String url, dynamic data) async {
    var req = GetConnect();
    var res = await req.post(url, data);
    return MyResponse.fromJsonString(res.bodyString as String);
  }

  static Future<Response> getUrl(String url) async {
    var req = GetConnect();
    var res = await req.get(url);
    return res;
  }
}

Future<DeployedContract> getContract(String filename,String address) async {
  var abiStr = await rootBundle.loadString('lib/resources/abis/$filename');
  var Contract = DeployedContract(ContractAbi.fromJson(abiStr, ''), EthereumAddress.fromHex(address));
  return Contract;
}
