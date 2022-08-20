import 'dart:convert';
import 'package:flutter/material.dart';

abstract class APPURL {
  static const String symbolURL =
      'wss://ws.binaryws.com/websockets/v3?app_id=1089';
}

 class AppDefaultParams {
  static String activeParams =
      jsonEncode({"active_symbols": "brief", "product_type": "basic"});
  static String getPrice(String id) =>
      jsonEncode({"ticks": id, "subscribe" : 1});
}

abstract class AppTextStyle {
  static TextStyle chooseMarket =
      const TextStyle(fontSize: 16, color: Colors.black);
}
