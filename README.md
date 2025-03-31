

# IMP-Kit

<img src="https://github.com/emdgroup/mtrust-imp-kit/blob/main/banner.png?raw=true" alt="Description" width="200">

[![Documentation Status](https://img.shields.io/badge/Documentation-IMP--Kit%20Docs-blue?style=flat&logo=readthedocs)](https://docs.mtrust.io/sdks/imp-kit/)


[![pub package](https://img.shields.io/pub/v/mtrust_imp_kit.svg)](https://pub.dev/packages/mtrust_imp_kit)
[![pub points](https://img.shields.io/pub/points/mtrust_imp_kit)](https://pub.dev/packages/mtrust_imp_kit/score)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Overview

The M-Trust IMP-Kit allows you to integrate the IMP-Reader with your mobile applications.

## Prerequisites

- Flutter SDK installed on your system.
- Basic knowledge of Flutter development.
- Access to the M-Trust IMP-Reader hardware, or use the `mtrust_urp_virtual_strategy` for development without the hardware.

## Getting started

## Installation

Add the `mtrust_imp_kit` package to your Flutter project via the pub add command 
```
flutter pub add mtrust_imp_kit
```

IMP-Kit can work with different URP Connection types. The default for IMP Readers is BLE. 
Add the ble connection strategy to your project by including it in your `pubspec.yaml` file via pub add command.
```
flutter pub add mtrust_urp_ble_strategy
```

Please follow the instructions for configuring BLE for your respective platform in the [README](https://github.com/emdgroup/mtrust-urp/blob/main/mtrust_urp_ble_strategy/README.md) of the `mtrust_urp_ble_strategy`!


## How to use
### Basic Example

#### Localization
To support multiple languages, add the necessary localization delegates to your application. For comprehensive guidance on internationalization, consult the [flutter documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization). Please note that you do not need the `LiquidLocalizations.delegate` and `UrpUiLocalizations.delegate` if
you do not use the IMP Kit's UI components.

```dart
return const MaterialApp(
  title: 'Your awesome application',
  localizationsDelegates: [
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    LiquidLocalizations.delegate,
    UrpUiLocalizations.delegate,
    ImpLocalizations.delegate,
  ],
  home: MyHomePage(),
);
```

### Adding UI dependencies

To utilize IMP Kit's UI components, incorporate the following providers and portals:

1. **Theme Provider:** Wrap your app with LdThemeProvider:
```dart
    LdThemeProvider(
        child: MaterialApp(
          home: MyHomePage(),
        ),
    )
```

2. **Portal:** Enclose your Scaffold with LdPortal:

```dart
    LdPortal(
      child: Scaffold(
        ...
      ),
    )
```

In case you do not want to use IMP Kit's UI components, you can control the IMP Reader using the `ImpReader` class.
For more information please refer to [Use ImpReader to build custom workflows](#use-impreader-to-build-custom-workflows)

### Use the IMP Modal 

To display the IMP Modal, utilize the `ImpModalBuilder` widget. It requires a connection strategy, a payload, and callbacks for the verification process:


```dart
  ImpModalBuilder(
    strategy: _connectionStrategy,
    payload: // Payload,
    onVerificationDone: (measurement) {},
    onVerificationFailed: () {},
    onDismiss: () {}, // Optionally
    canDismiss: true, // Define wether the user can dismiss the modal
    builder: (context, openModal) {
      // Call openModal to open the IMP Sheet
    }
  ),

```

### Custom UI Example (10 step integration)

To build custom workflows, utilize the `ImpReader` class. It requires a connection strategy to handle the connection between the device and the reader. 

1. Create a new Flutter application e.g. using VSCode:  
```bash
Command + Shift + P -> Flutter: New Project -> Empty Application
```

2. Install flutter dependencies:
```bash
flutter pub add mtrust_imp_kit mtrust_urp_ble_strategy
```

3. Add permission configuration to the `info.plist` for iOS:
```plist
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>This app always needs Bluetooth to function</string>
  <key>NSBluetoothPeripheralUsageDescription</key>
  <string>This app needs Bluetooth Peripheral to function</string>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>This app always needs location and when in use to function</string>
  <key>NSLocationAlwaysUsageDescription</key>
  <string>This app always needs location to function</string>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This app needs location when in use to function</string>
```

4. Assign a developer team to the iOS solution. Open the `ios` folder in xCode and assign yourself or your team to the signature of your Runner.

5. Now we are ready to create an instance of a IMP Reader in the code.
```dart
  final reader = ImpReader(
    connectionStrategy: _bleStrategy,
  );
```

6. As the `ImpReader` expects a connection strategy, we also need to create this one:
```dart
  final UrpBleStrategy _bleStrategy = UrpBleStrategy();
```

7. Now we can create `connect` and `disconnect` methods already:
```dart
  Future<void> findAndConnect() async {
    await _bleStrategy.findAndConnectDevice(
      readerTypes: {UrpDeviceType.urpImp}
    );
  }

  Future<void> disconnect() async {
    await _bleStrategy.disconnectDevice();
  }
```

8. Finally we can create a minimal UI to display the buttons. Change your MainApp from a `Stateless` to a `Statefull` widget.
```dart
Center(
  child: ListenableBuilder(
    listenable: _bleStrategy,
    builder: (context, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Reader: ${reader.connectionStrategy.status}"),
          reader.connectionStrategy.status == ConnectionStatus.connected ? Column(
            children: [
              ElevatedButton(
                onPressed: disconnect,
                child: const Text('Disconnect'),
              )
            ],
          ) : ElevatedButton(
            onPressed: findAndConnect,
              child: const Text('Find and Connect'),
            ),
        ],
      );
    }
  ),
),
```

9. Great, we are able to connect to our device and disconnect it again. Let's continue with a measurement. Lets add a `measure` method for this:
```dart
  Future<UrpImpMeasurement> measure() async {
    await reader.prime();
    final measurement = await reader.startMeasurement();
    print(measurement);
    return measurement.measurement;
  }
```

10. And finally add a button to start the measurement:
```dart
  ElevatedButton(
    onPressed: measure,
    child: const Text('Measure'),
  )
```

With the `ImpReader` you can access all methods required to build workflows that meet your specific requirements. Please refer to the `example_advanced` for an example on how to build custom workflows.

## Configuration Options
- **Connection Strategies:** While BLE is the default, IMP-Kit supports various connection strategies. Ensure you include and configure the appropriate strategy package as needed.

## Troubleshooting
- **BLE Connectivity Issues:** Verify that your device's Bluetooth is enabled and that the M-Trust IMP-Reader is powered on and in range.

- **Font Rendering Problems:** Ensure that the font assets are correctly referenced in your `pubspec.yaml` and that the files exist in the specified paths.

## Contributing
We welcome contributions! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to our coding standards and includes appropriate tests.

## License
This project is licensed under the Apache 2.0 License. See the [LICENSE](./LICENSE) file for details.