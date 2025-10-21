import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/bluetooth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/sensor_data_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SmartBLESensorApp());
}

class SmartBLESensorApp extends StatelessWidget {
  const SmartBLESensorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => SensorDataProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'SmartBLESensor',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2196F3), // 蓝色主题
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
            ),
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateTitle: (context) =>
                AppLocalizations.of(context).appTitle,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return localeProvider.locale;
              }
              return supportedLocales.firstWhere(
                (supported) => supported.languageCode == locale.languageCode,
                orElse: () => supportedLocales.first,
              );
            },
          );
        },
      ),
    );
  }
}
