import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';

typedef WidgetBuilder = Future<Future<void> Function()?> Function(
  WidgetTester tester,
  Future<void> Function(Widget widget) placeWidget,
);
Widget liquidFrame({
  required Key key,
  required Widget child,
  required bool isDark,
  required LdThemeSize size,
}) {
  final theme = LdTheme()..setThemeSize(size);
  return Localizations(
    delegates: const [
      GlobalWidgetsLocalizations.delegate,
      LiquidLocalizations.delegate,
      UrpUiLocalizations.delegate,
      ImpLocalizations.delegate,
    ],
    locale: const Locale('en'),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: LdThemeProvider(
        theme: theme,
        autoSize: false,
        brightnessMode:
            isDark ? LdThemeBrightnessMode.dark : LdThemeBrightnessMode.light,
        child: Builder(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: theme.radius(LdSize.m),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Center(key: key, child: child),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Future<void> multiGolden(
  WidgetTester tester,
  String name,
  Map<String, WidgetBuilder> widgets, {
  int width = 900,
}) async {
  ldDisableAnimations = true;
  urpUiDisableAnimations = true;
  await loadAppFonts();
  for (final entry in widgets.entries) {
    for (final themeSize in LdThemeSize.values) {
      for (final brightness in Brightness.values) {
        final slug = '${entry.key}/'
            "${themeSize.toString().split(".").last}"
            "-${brightness.toString().split(".").last}";
        await tester.binding.setSurfaceSize(
          Size(width.toDouble(), 1000),
        );
        final cleanup = await entry.value(tester, (widget) async {
          await tester.pumpWidget(
            liquidFrame(
              key: ValueKey(slug),
              child: widget,
              isDark: brightness == Brightness.dark,
              size: themeSize,
            ),
          );
        });
        final size =
            find.byKey(ValueKey(slug)).evaluate().single.size ?? Size.zero;
        await tester.binding.setSurfaceSize(
          Size(width.toDouble(), size.height + 64),
        );
        await tester.pump();
        await screenMatchesGolden(
          tester,
          '$name/$slug',
          customPump: (tester) async {
            await tester.pumpAndSettle();
          },
        );
        if (cleanup != null) {
          await cleanup();
        }
        await tester.pumpAndSettle();
      }
    }
  }
}