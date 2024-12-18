import 'dart:io';

import 'package:mtrust_imp_kit/src/imp_reader_exception.dart';
import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_types/imp.pb.dart';

/// [ImpReader] is a class that provides a high-level API to interact with
/// an IMP reader.
class ImpReader extends CmdWrapper {
  ImpReader({
    required ConnectionStrategy connectionStrategy,
    UrpDeviceIdentifier? target,
    UrpDeviceIdentifier? origin,
  }) : super(
          strategy: connectionStrategy,
          target: target ??
              UrpDeviceIdentifier(
                deviceClass: UrpDeviceClass.urpReader,
                deviceType: UrpDeviceType.urpImp,
              ),
          origin: origin ??
              UrpDeviceIdentifier(
                deviceClass: UrpDeviceClass.urpHost,
                deviceType: (Platform.isAndroid || Platform.isIOS)
                    ? UrpDeviceType.urpMobile
                    : UrpDeviceType.urpDesktop,
              ),
        );

  /// Get ConnectionStatus.
  ConnectionStatus get status => strategy.status;

  /// Find and connect to an IM reader using the given [strategy].
  /// If [deviceAddress] is provided, it will try to connect to the reader
  /// with the given address.
  static Future<ImpReader> findAndConnect(
    ConnectionStrategy strategy, {
    String? deviceAddress,
  }) async {
    final connected = await strategy.findAndConnectDevice(
      readerTypes: {UrpDeviceType.urpImp},
      deviceAddress: deviceAddress,
    );

    if (!connected) {
      throw ImpReaderException(message: 'Failed to connect to reader');
    }

    return ImpReader(connectionStrategy: strategy);
  }

  /// Returns a list of all available [UrpDeviceType.urpImp]
  static Stream<FoundDevice> findReaders(ConnectionStrategy strategy) {
    return strategy.findDevices({
      UrpDeviceType.urpImp,
    });
  }

  /// Connect to a [FoundDevice]
  Future<ImpReader> connectTo(
    FoundDevice reader,
    ConnectionStrategy strategy,
  ) async {
    final connected = await strategy.connectToFoundDevice(reader);

    if (!connected) {
      throw ImpReaderException(
        message: 'Failed to connect to found reader $reader',
      );
    }

    return ImpReader(connectionStrategy: strategy);
  }

  /// Prepares (primes) a measurement
  Future<void> prime() async {
    await strategy.addQueue(
      UrpImpCommandWrapper(
        deviceCommand: UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpPrime,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }

  /// Unprime a measurement
  Future<void> unprime() async {
    await strategy.addQueue(
      UrpImpCommandWrapper(
        deviceCommand: UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpPrime,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpImpMeasurement> startMeasurement() async {
    final result = await strategy.addQueue(
      UrpImpCommandWrapper(
        deviceCommand: UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpStartMeasurement,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
      timeout: const Duration(seconds: 30),
    );

    if (!result.hasPayload()) {
      throw Exception('Failed to measure.');
    }
    return UrpImpMeasurement.fromBuffer(result.payload);
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    await strategy.addQueue(
      UrpImpCommandWrapper(
        deviceCommand: UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpStopMeasurement,
        ),
      ).writeToBuffer(),
      super.target,
      super.origin,
    );
  }
}
