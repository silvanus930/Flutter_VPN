import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/model.dart';
import '../resources/environment.dart';

abstract class HttpConnection {
  final BuildContext context;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: endpoint,
    sendTimeout: 20000,
    connectTimeout: 20000,
    receiveTimeout: 20000,
    maxRedirects: 5,
  ));

  HttpConnection(this.context);

  Future get<T>(String url, {Map<String, String>? params, dynamic headers, bool pure = false, bool printDebug = false}) async {
    try {
      _printRequest("GET", url, body: params, showDebug: printDebug);
      var resp = await _dio.get(url + paramsToString(params), options: Options(headers: headers));
      _printResponse(resp, printDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse<T>.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  Future post<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false, bool printDebug = false}) async {
    try {
      _printRequest("POST", url, body: params, showDebug: printDebug);
      var resp = await _dio.post(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp, printDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse<T>.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  Future put<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false, bool printDebug = false}) async {
    try {
      _printRequest("PUT", url, body: params, showDebug: printDebug);
      var resp = await _dio.put(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp, printDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse<T>.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  Future delete<T>(String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false, bool printDebug = false}) async {
    try {
      _printRequest("DELETE", url, body: params, showDebug: printDebug);
      var resp = await _dio.delete(url + paramsToString(params), data: body, options: Options(headers: headers));
      _printResponse(resp, printDebug);
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse<T>.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  static String paramsToString(Map<String, String>? params) {
    if (params == null) return "";
    String output = "?";
    params.forEach((key, value) {
      output += "$key=$value&";
    });
    return output.substring(0, output.length - 1);
  }

  void _printRequest(String type, String url, {Map<String, dynamic>? body, bool showDebug = false}) {
    if (kDebugMode && showDebug) {
      log("${type.toUpperCase()} REQUEST : $url \n");
      if (body != null) {
        try {
          JsonEncoder encoder = const JsonEncoder.withIndent('  ');
          String prettyprint = encoder.convert(body);
          log("BODY / PARAMETERS : $prettyprint");
        } catch (e) {
          log("CAN'T FETCH BODY");
        }
      }
    }
  }

  void _printResponse(dynamic response, [bool showDebug = false]) {
    String? prettyprint;
    if (response is Map) {
      try {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        prettyprint = encoder.convert(response);
        // ignore: empty_catches
      } catch (e) {}
    }
    if (kDebugMode && showDebug) {
      log(prettyprint ?? response.toString());
      log("=======================================================\n\n");
    }
  }
}

class ApiResponse<T> extends Model {
  ApiResponse({
    this.success = false,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  T? data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}
