import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n.dart';
import 'pages/setup_page.dart';

void main() {
  runApp(const TimeBombApp());
}

class TimeBombApp extends StatefulWidget {
  const TimeBombApp({this.locale, super.key});

  final Locale? locale;

  static const coal = Color(0xFF171717);
  static const warningRed = Color(0xFFE5483F);
  static const signalYellow = Color(0xFFF4C95D);
  static const mint = Color(0xFF63C7A5);
  static const paper = Color(0xFFF5F3ED);

  @override
  State<TimeBombApp> createState() => _TimeBombAppState();
}

class _TimeBombAppState extends State<TimeBombApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }

  @override
  void didUpdateWidget(covariant TimeBombApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _locale = widget.locale;
    }
  }

  // null 表示跟随系统语言，其余值由用户在设置页主动选择。
  void _changeLocale(Locale? locale) {
    if (_locale == locale) return;
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: TimeBombApp.warningRed,
      brightness: Brightness.light,
      surface: TimeBombApp.paper,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // 系统语言不受支持时统一回退英语，避免依赖生成文件中的语言排序。
      localeListResolutionCallback: (locales, supportedLocales) {
        for (final locale in locales ?? const <Locale>[]) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return const Locale('en');
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: TimeBombApp.paper,
        fontFamilyFallback: const [
          'Microsoft YaHei',
          'PingFang SC',
          'Noto Sans CJK SC',
        ],
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: TimeBombApp.coal,
          displayColor: TimeBombApp.coal,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD7D3C9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD7D3C9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: TimeBombApp.coal, width: 2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      home: SetupPage(selectedLocale: _locale, onLocaleChanged: _changeLocale),
    );
  }
}
