
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';

import 'golden_utils.dart';
import 'test_utils.dart';

void main() {
  testGoldens('ImpWidget', (WidgetTester test) async {
    urpUiDisableAnimations = true;

    await multiGolden(
      test,
      'ImpWidget',
      {
        'Idle': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();
          return null;
        },
        'Priming': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          return () async {
            strategy.primeCompleter.complete();
          };
        },
        'Waiting for measurement': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          return () async {
            strategy.startMeasurementCompleter.complete();
          };
        },
        'Measuring': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start reading'));

          await tester.pumpAndSettle();

          return () async {
            strategy.startMeasurementCompleter.complete();
          };
        },
        'Measure Fail': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start reading'));

          strategy.startMeasurementCompleter.completeError('');

          await tester.pumpAndSettle();

          return () async {};
        },
        'Measure Complete': (tester, place) async {
          final strategy = CompleterStrategy(withReaders: true);

          final storageAdapter = MockStorageAdapter();

          await place(
            AspectRatio(
              aspectRatio: 1,
              child: ImpWidget(
                connectionStrategy: strategy.strategy,
                storageAdapter: storageAdapter,
                chipIdFormat: ChipIdFormat.hex,
                onIdentificationDone: (_) async {},
                onIdentificationFailed: () async {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key('connect_button')));

          await tester.pumpAndSettle();

          strategy.primeCompleter.complete();

          await tester.pumpAndSettle();

          await tester.tap(find.text('Start reading'));

          strategy.startMeasurementCompleter.complete();

          await tester.pumpAndSettle();

          return () async {};
        },
      },
      width: 500,
    );
  });
}
