// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_types/imp.pb.dart';

void main() {
  group(
    'Testing correct generation of byte array for device commands', 
    () {

      UrpMessage getUrpMessage({UrpCoreCommand? coreCmd, UrpImpDeviceCommand? deviceCmd}) {
        return UrpMessage(
          header: UrpMessageHeader(
            seqNr: 1,
            target: UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpReader,
              deviceType: UrpDeviceType.urpSec,
            ),
            origin: UrpDeviceIdentifier(
              deviceClass: UrpDeviceClass.urpHost,
              deviceType: UrpDeviceType.urpMobile,
            ),
          ),
          request: UrpRequest(
            payload: UrpImpCommandWrapper(
              coreCommand: coreCmd,
              deviceCommand: deviceCmd,
            ).writeToBuffer(),
          ),
        );
      }

      Uint8List int16ToBytes(int value) {
        if (value < -32768 || value > 32767) {
          throw ArgumentError('Value must be between -32768 and 32767.');
        }

        final bytes = Uint8List(2);

        // Store the two bytes in little-endian order
        bytes[0] = (value >> 8) & 0xFF; // Upper byte
        bytes[1] = value & 0xFF; // Lower byte

        return bytes;
      }

      test('Ping command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpPing,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 00';
        expect(hexString, equals(expected));
      });

      test('Get info command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpGetInfo,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 01';
        expect(hexString, equals(expected));
      });

      test('Get power command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpGetPower,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 02';
        expect(hexString, equals(expected));
      });

      test('Set name command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpSetName,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 03';
        expect(hexString, equals(expected));
      });

      test('Get name command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpGetName,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 04';
        expect(hexString, equals(expected));
      });

      test('Pair command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpPair,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 05';
        expect(hexString, equals(expected));
      });

      test('Unpair command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpUnpair,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 06';
        expect(hexString, equals(expected));
      });

      test('Start AP command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpStartAp,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 07';
        expect(hexString, equals(expected));
      });

      test('Stop AP command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpStopAp,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 08';
        expect(hexString, equals(expected));
      });

      test('Connect AP command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpConnectAp,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 09';
        expect(hexString, equals(expected));
      });

      test('Disconnect AP command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpDisconnectAp,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0a';
        expect(hexString, equals(expected));
      });

      test('Start DFU command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpStartDfu,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0b';
        expect(hexString, equals(expected));
      });

      test('Stop DFU command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpStopDfu,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0c';
        expect(hexString, equals(expected));
      });

      test('Sleep command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpSleep,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0d';
        expect(hexString, equals(expected));
      });

      test('Off command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpOff,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0e';
        expect(hexString, equals(expected));
      });

      test('Reboot command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpReboot,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 0f';
        expect(hexString, equals(expected));
      });

      test('Stay awake command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpStayAwake,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 10';
        expect(hexString, equals(expected));
      });

      test('Get public key command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpGetPublicKey,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 11';
        expect(hexString, equals(expected));
      });

      test('Get device id command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpGetDeviceId,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 12';
        expect(hexString, equals(expected));
      });

      test('Identify command', () {
        final cmd = UrpCoreCommand(
          command: UrpCommand.urpIdentify,
        );
        final message = getUrpMessage(coreCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 0a 02 08 13';
        expect(hexString, equals(expected));
      });

      test('Prime command', () {
        final cmd = UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpPrime,
        );
        final message = getUrpMessage(deviceCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 00';
        expect(hexString, equals(expected));
      });

      test('Unprime command', () {
        final cmd = UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpUnprime,
        );
        final message = getUrpMessage(deviceCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 01';
        expect(hexString, equals(expected));
      });

      test('Start measurement command', () {
        final cmd = UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpStartMeasurement,
        );
        final message = getUrpMessage(deviceCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 02';
        expect(hexString, equals(expected));
      });

      test('Stop measurement command', () {
        final cmd = UrpImpDeviceCommand(
          command: UrpImpCommand.urpImpStopMeasurement,
        );
        final message = getUrpMessage(deviceCmd: cmd);
        final bytes = message.writeToBuffer();
        final length = int16ToBytes(bytes.length);
        final messageBytes = length + bytes;
        final hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
        const expected = '00 18 0a 0e 08 01 22 04 08 02 10 04 2a 04 08 00 10 01 12 06 0a 04 12 02 08 03';
        expect(hexString, equals(expected));
      });
    },
  );
}