import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/services/hive_service.dart';
import 'data/local/hive_adapters/transaction_adapter.dart';
import 'data/models/transaction_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await HiveService.init();

  Hive.registerAdapter(TransactionAdapter());

  await HiveService.openBox<TransactionModel>(HiveService.transactionBox);
  await HiveService.openBox(HiveService.settingsBox);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}