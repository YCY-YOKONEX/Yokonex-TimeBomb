// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yokonex_time_bomb/l10n/l10n.dart';
import 'package:yokonex_time_bomb/main.dart';
import 'package:yokonex_time_bomb/pages/game_page.dart';

Widget localizedTestApp({
  required Widget home,
  Locale locale = const Locale('zh'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  test('支持全部目标语言', () {
    expect(
      AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
      containsAll(['zh', 'en', 'fr', 'de', 'nl', 'es', 'ko', 'ja', 'it', 'ru']),
    );
  });

  testWidgets('未分配并测试通道时不能开始游戏', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TimeBombApp(locale: Locale('zh')));

    expect(find.text('役次元-时间炸弹'), findsOneWidget);
    expect(find.text('玩家 1'), findsWidgets);
    expect(find.textContaining('强度'), findsNothing);
    expect(find.widgetWithText(TextField, '60'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('开始点火'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    final startButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '开始点火'),
    );
    expect(startButton.onPressed, isNull);
    expect(find.textContaining('已绑定 0 / 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('运行时隐藏时间，暂停交接时显示时间', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    expect(find.text('准备点火'), findsOneWidget);
    expect(find.text('累计炸弹：10 克 · 原味'), findsOneWidget);
    expect(find.text('这颗炸弹还不够上头'), findsOneWidget);
    expect(find.text('本轮添加克数'), findsOneWidget);
    expect(find.byKey(const ValueKey('gram-key-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('gram-key-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('gram-backspace')), findsOneWidget);
    expect(find.text('加麻'), findsOneWidget);
    expect(find.text('加辣'), findsOneWidget);

    await tester.tap(find.text('开始点火'));
    await tester.pump(const Duration(milliseconds: 2000));

    expect(find.text('现在是'), findsOneWidget);
    expect(find.text('暂停并传给下一位'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            RegExp(r'^\d{3}\.\d{3}$').hasMatch(widget.data ?? ''),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('把手机交给'), findsOneWidget);
    expect(find.text('玩家 2'), findsWidgets);
    expect(find.text('剩余时间'), findsOneWidget);
    expect(find.text('累计炸弹：11 克 · 原味'), findsOneWidget);
    expect(find.byKey(const ValueKey('remaining-time')), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('remaining-time')))
          .style
          ?.fontSize,
      48,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            RegExp(r'^\d{3}\.\d{3}$').hasMatch(widget.data ?? ''),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('结束时先添加调料再播放爆炸动画', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(microseconds: 1),
        ),
      ),
    );

    await tester.tap(find.text('加麻'));
    await tester.tap(find.text('加辣'));
    await tester.tap(find.text('开始点火'));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('正在添加调料'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('seasoning-current'))).data,
      '装填 11 克炸弹',
    );

    await tester.pump(const Duration(milliseconds: 650));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('seasoning-current'))).data,
      '加入麻料 ×1',
    );

    await tester.pump(const Duration(milliseconds: 650));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('seasoning-current'))).data,
      '加入辣料 ×1',
    );

    await tester.pump(const Duration(milliseconds: 650));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('seasoning-current'))).data,
      '封装完成',
    );

    await tester.pump(const Duration(milliseconds: 650));
    expect(find.byKey(const ValueKey('blast')), findsOneWidget);
    expect(find.text('砰！'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('接受惩罚'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('每轮添加的克数和麻味会持续累计并允许重复添加', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    await tapVisible(tester, find.byKey(const ValueKey('gram-key-5')));
    await tester.tap(find.text('加麻'));
    await tapVisible(tester, find.text('开始点火'));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('累计炸弹：15 克 · 加麻'), findsOneWidget);

    await tapVisible(tester, find.byKey(const ValueKey('gram-key-3')));
    await tester.tap(find.text('加辣'));
    await tapVisible(tester, find.text('接过炸弹'));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('累计炸弹：18 克 · 加麻 ×1 · 加辣 ×1'), findsOneWidget);

    await tester.tap(find.text('加麻'));
    await tapVisible(tester, find.text('接过炸弹'));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('累计炸弹：19 克 · 加麻 ×2 · 加辣 ×1'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('平板横屏交接页操作区完整可见', (tester) async {
    const surfaceSize = Size(1194, 768);
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    await tester.tap(find.text('开始点火'));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));

    final takeBomb = find.text('接过炸弹');
    expect(takeBomb, findsOneWidget);
    expect(tester.getBottomRight(takeBomb).dy, lessThan(surfaceSize.height));
    expect(tester.getTopLeft(find.text('加麻')).dy, greaterThan(0));
    expect(
      tester.getBottomRight(find.text('加辣')).dy,
      lessThan(surfaceSize.height),
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('英文系统语言显示英文界面', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        locale: const Locale('en'),
        home: const GamePage(
          players: ['Player 1', 'Player 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    expect(find.text('Ready to Ignite'), findsOneWidget);
    expect(find.text('Bomb total: 10 g · Original'), findsOneWidget);
    expect(find.text('Grams to add this turn'), findsOneWidget);
    expect(find.text('Start Ignition'), findsOneWidget);
    expect(find.textContaining('累计炸弹'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('数字键盘支持输入清空和退格', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    await tapVisible(tester, find.byKey(const ValueKey('gram-key-7')));
    await tapVisible(tester, find.byKey(const ValueKey('gram-key-0')));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('pending-grams'))).data,
      '70',
    );

    await tapVisible(tester, find.byKey(const ValueKey('gram-backspace')));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('pending-grams'))).data,
      '7',
    );

    await tapVisible(tester, find.byKey(const ValueKey('gram-clear')));
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('pending-grams'))).data,
      '0',
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('英文设置页在窄屏正常显示', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const TimeBombApp(locale: Locale('en')));

    expect(find.text('Yokonex Time Bomb'), findsOneWidget);
    expect(find.text('Connect Devices'), findsOneWidget);
    expect(find.text('Game Settings'), findsOneWidget);
    expect(find.text('Assign Players'), findsOneWidget);
    expect(find.text('Player 1'), findsWidgets);
    expect(find.textContaining('连接电击器'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('可在应用内切换语言并更新默认玩家名', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const TimeBombApp(locale: Locale('zh')));
    await tester.tap(find.byTooltip('语言'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.ancestor(
        of: find.text('English'),
        matching: find.byWidgetPredicate(
          (widget) => widget is CheckedPopupMenuItem<String>,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yokonex Time Bomb'), findsOneWidget);
    expect(find.text('Connect Devices'), findsOneWidget);
    expect(find.text('Player 1'), findsWidgets);
    expect(find.text('玩家 1'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('系统语言不受支持时回退到英语', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('pt')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const TimeBombApp());
    await tester.pump();

    expect(find.text('Yokonex Time Bomb'), findsOneWidget);
    expect(find.text('Connect Devices'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('新增语言设置页均可正常加载', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const sectionTitles = {
      'fr': 'Connecter les appareils',
      'de': 'Geräte verbinden',
      'nl': 'Apparaten verbinden',
      'es': 'Conectar dispositivos',
      'ko': '장치 연결',
      'ja': 'デバイスを接続',
      'it': 'Collega dispositivi',
      'ru': 'Подключить устройства',
    };

    for (final entry in sectionTitles.entries) {
      await tester.pumpWidget(TimeBombApp(locale: Locale(entry.key)));
      await tester.pump();

      expect(find.text(entry.value), findsOneWidget, reason: entry.key);
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });

  testWidgets('平板竖屏和横屏使用双栏设置布局', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1024, 1366));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const TimeBombApp(locale: Locale('zh')));

    final deviceTop = tester.getTopLeft(find.text('连接电击器')).dy;
    final settingsTop = tester.getTopLeft(find.text('游戏参数')).dy;
    expect((deviceTop - settingsTop).abs(), lessThan(4));
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1366, 768));
    await tester.pump();

    expect(find.text('连接电击器'), findsOneWidget);
    expect(find.text('游戏参数'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('平板横屏可完成点火和交接', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1366, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      localizedTestApp(
        home: const GamePage(
          players: ['玩家 1', '玩家 2'],
          duration: Duration(seconds: 60),
        ),
      ),
    );

    expect(find.text('累计炸弹：10 克 · 原味'), findsOneWidget);
    await tapVisible(tester, find.text('开始点火'));
    await tester.pump(const Duration(milliseconds: 2000));
    expect(find.byKey(const ValueKey('running')), findsOneWidget);

    await tester.tap(find.text('暂停并传给下一位'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('handoff')), findsOneWidget);
    expect(find.text('剩余时间'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
