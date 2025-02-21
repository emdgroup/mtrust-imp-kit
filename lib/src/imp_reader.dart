import 'dart:io';

import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';

/// [ImpReader] is a class that provides a high-level API to interact with
/// an IMP reader.
class ImpReader extends CmdWrapper {
  ImpReader({
    required this.connectionStrategy,
    UrpDeviceIdentifier? target,
    UrpDeviceIdentifier? origin,
  }) : target = target ??
            UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpReader,
              deviceType: UrpDeviceType.urpImp,
            ),
        origin = origin ??
            UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpHost,
              deviceType: (Platform.isAndroid || Platform.isIOS)
                  ? UrpDeviceType.urpMobile
                  : UrpDeviceType.urpDesktop,
            );
  
  /// The connectionStrategy used to connect the device.
  final ConnectionStrategy connectionStrategy;

  /// The target device.
  final UrpDeviceIdentifier target;

  /// The origin device.
  final UrpDeviceIdentifier origin;

  /// Get ConnectionStatus.
  ConnectionStatus get status => connectionStrategy.status;

  int _requestTokenAmount = 10;

  /// Sets the amount of tokens to be requested if the device has no more
  /// tokens available. The default 10.
  void setTokenAmount(int amount) {
    _requestTokenAmount = amount;
    notifyListeners();
  }

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

  Future<UrpResponse> _addCommandToQueue({
    UrpCoreCommand? coreCommand, 
    UrpImpDeviceCommand? deviceCommand,
    Duration? timeout,
  }) async {
    return connectionStrategy.addQueue(
      UrpImpCommandWrapper(
        coreCommand: coreCommand,
        deviceCommand: deviceCommand,
      ).writeToBuffer(), 
      target, 
      origin,
      timeout: timeout,
    );
  }

  /// Pings the device.
  @override
  Future<void> ping() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpPing,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the device info. Throws an error if failed.
  @override
  Future<UrpDeviceInfo> info() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetInfo,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if (!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to get info');
    }
    return UrpDeviceInfo.fromBuffer(res.payload);
  }

  /// Returns the power state of the device. Throws an error if failed.
  @override
  Future<UrpPowerState> getPower() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetPower,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to get power state');
    }
    return UrpPowerState.fromBuffer(res.payload);
  }

  /// Sets the name of the device.
  @override
  Future<void> setName(String? name) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpSetName,
      setNameParameters: UrpSetNameParameters(name: name),
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the devic name. Throws an error if failed.
  @override
  Future<UrpDeviceName> getName() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetName,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to get name');
    }
    return UrpDeviceName.fromBuffer(res.payload);
  }

  /// Pair the device.
  @override
  Future<void> pair() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpPair,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Unpair the device.
  @override
  Future<void> unpair() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpUnpair,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Starts the DFU mode of the device.
  @override
  Future<void> startDFU() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStartDfu,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Stops the DFU mode of the device.
  @override
  Future<void> stopDFU() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStopDfu,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Puts the device to sleep mode. This will disconnect the device.
  @override
  Future<void> sleep() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpSleep,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Turns the device off. This will disconnect the device.
  @override
  Future<void> off() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpOff,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Reboots the device. This will disconnect the device.
  @override
  Future<void> reboot() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpReboot,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Prevents the device from going to sleep mode.
  @override
  Future<void> stayAwake() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStayAwake,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Returns the public key of the device. Throws an error if failed.
  @override
  Future<UrpPublicKey> getPublicKey() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetPublicKey,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to get public key');
    }
    return UrpPublicKey.fromBuffer(res.payload);
  }

  /// Return the device id. Throws an error if failed.
  @override
  Future<UrpDeviceId> getDeviceId() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpGetDeviceId,
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to get public key');
    }
    return UrpDeviceId.fromBuffer(res.payload);
  }

  /// Identify reader. Triggers the LED to identify the device.
  @override
  Future<void> identify() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpIdentify,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Connect AP. Throws an error if failed.
  @override
  Future<UrpWifiState> connectAP(String ssid, String apk) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpConnectAp,
      apParameters: UrpApParamters(ssid: ssid, password: apk),
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to connect to AP');
    }
    return UrpWifiState.fromBuffer(res.payload);
  }
  
  /// Disconnect AP.
  @override
  Future<void> disconnectAP() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpDisconnectAp,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }
  
  /// Start AP. Throws an error if failed.
  @override
  Future<UrpWifiState> startAP(String ssid, String apk) async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStartAp,
      apParameters: UrpApParamters(ssid: ssid, password: apk),
    );
    final res = await _addCommandToQueue(coreCommand: cmd);

    if(!res.hasPayload()) {
      throw ImpReaderException(message: 'Failed to start AP');
    }
    return UrpWifiState.fromBuffer(res.payload);
  }
  
  /// Stop AP.
  @override
  Future<void> stopAP() async {
    final cmd = UrpCoreCommand(
      command: UrpCommand.urpStopAp,
    );
    await _addCommandToQueue(coreCommand: cmd);
  }

  /// Prepares (primes) a measurement
  Future<UrpImpPrimeResponse?> prime([String? payload]) async {
    final cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpPrime,
      primeParameters: UrpImpPrimeParameters(payload: payload),
    );
    try {
      final res = await _addCommandToQueue(deviceCommand: cmd);
      return UrpImpPrimeResponse.fromBuffer(res.payload);
    } catch (e) {
      urpLogger.e(e);
      if(e is DeviceError) {
        if(e.errorCode == 4) {
          final publicKey = await getPublicKey();
          final oldToken = await requestToken();
          final newToken = await getToken(oldToken, publicKey);
          if(newToken == null) {
            throw ImpReaderException(
              message: 'Failed to get new token!',
              type: ImpReaderExceptionType.tokenFailed,
            );
          }
          await setToken(newToken);
          return await prime(payload);
        } else {
          rethrow;
        }
      }
    }
    return null;
  }

  /// Request the device to send a new token request
  Future<UrpSecureToken> requestToken() async {
    final UrpImpDeviceCommand cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpRequestToken,
      tokenRequest: UrpTokenRequest(
        amount: _requestTokenAmount
      ),
    );
    final res = await _addCommandToQueue(
      deviceCommand: cmd,
    );
    
    if(!res.hasPayload()) {
      throw ImpReaderException(
        message: 'Failed to request token!',
        type: ImpReaderExceptionType.tokenFailed,
      );
    }
    return UrpSecureToken.fromBuffer(res.payload);
  }

  /// Install a new token after a token request on the device
  Future<void> setToken(UrpSecureToken token) async {
    final UrpImpDeviceCommand cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpSetToken,
      secureToken: token,
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }

  /// Request the currently installed token from the device
  Future<UrpSecureToken> getCurrentToken() async {
    final UrpImpDeviceCommand cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpGetToken,
    );
    final res = await _addCommandToQueue(
      deviceCommand: cmd,
    );

    if(!res.hasPayload()) {
      throw ImpReaderException(
        message: 'Failed to get current token',
        type: ImpReaderExceptionType.tokenFailed,
      );
    }
    return UrpSecureToken.fromBuffer(res.payload);
  }

  /// Unprime a measurement
  Future<void> unprime() async {
    final cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpUnprime,
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }

  /// Measures until detection. Returns the result if successful.
  /// Triggers an error if failed.
  Future<UrpImpSecureMeasurement> startMeasurement() async {
    final cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpStartMeasurement,
    );
    final res = await _addCommandToQueue(
      deviceCommand: cmd, 
      timeout: const Duration(seconds: 30),
    );

    if (!res.hasPayload()) {
      throw ImpReaderException(
        message: 'Failed to measure.',
        type: ImpReaderExceptionType.measurementFailed,
      );
    }
    try {
      return UrpImpSecureMeasurement.fromBuffer(res.payload);
    } catch (e) {
      throw ImpReaderException(
        message: 'Incompatible device firmware version. Please update!',
        type: ImpReaderExceptionType.incompatibleFirmware,
      );
    }
  }

  /// Stop measurement
  Future<void> stopMeasurement() async {
    final cmd = UrpImpDeviceCommand(
      command: UrpImpCommand.urpImpStopMeasurement,
    );
    await _addCommandToQueue(deviceCommand: cmd);
  }
}
