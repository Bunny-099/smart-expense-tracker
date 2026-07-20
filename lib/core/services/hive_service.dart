import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static const String transactionBox = 'transactions_box';
  static const String settingsBox = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  static Future<void> clearBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).clear();
    }
  }

  static Future<void> closeAll() async {
    await Hive.close();
  }
}