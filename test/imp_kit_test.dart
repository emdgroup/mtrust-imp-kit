import 'package:flutter_test/flutter_test.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';

import 'test_utils.dart';

void main() {

  const runTest = bool.fromEnvironment('run_test', defaultValue: false);

  // NOTE: Run this test only if the device simulator is running
  // The firmware compatibility check is using this test to check compatibility
  if(runTest) {
    final strategy = WifiStrategy();
    final reader = ImpReader(connectionStrategy: strategy);

    group('Firmware Compatibility Check', () {
      test('Test that the Kit can connect to a reader', () async {
        final res = await strategy.findAndConnectDevice(
          deviceAddress: 'localhost:8080',
        );
        expect(res, true);
      });

      test('Get Device Info', () async {
        final res = await reader.info();
        expect(res, isA<UrpDeviceInfo>());
      });

      test('Get Public Key', () async {
        final res = await reader.getPublicKey();
        expect(res, isA<UrpPublicKey>());
      });

      test('Get Name', () async {
        final res = await reader.getName();
        expect(res, isA<UrpDeviceName>());
      });

      //! Add back in when Simulator is updated to support these commands
      // test('Get Device ID', () async {
      //   final res = await reader.getDeviceId();
      //   expect(res, isA<UrpDeviceId>());
      // });

      // test('Get Prime Reader', () async {
      //   final res = await reader.prime();
      //   expect(res, isA<UrpImpPrimeResponse>());
      // });

      // test('Perform measurement', () async {
      //   final res = await reader.startMeasurement();
      //   expect(res, isA<UrpImpSecureMeasurement>());
      // });

    });
  }
  
}