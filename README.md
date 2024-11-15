# IMP-Kit

<img src="https://docs.mtrust.io/assets/images/imp_kit-9a1d7dfa9ce983c6affdc4b2c8599eef.png" alt="Description" width="200">

[![Documentation Status](https://img.shields.io/badge/Documentation-IMP--Kit%20Docs-blue?style=flat&logo=readthedocs)](https://docs.mtrust.io/sdks/imp-kit/)


[![pub package](https://img.shields.io/pub/v/mtrust_imp_kit.svg)](https://pub.dev/packages/mtrust_imp_kit)
[![likes](https://img.shields.io/pub/likes/mtrust_imp_kit)](https://pub.dev/packages/mtrust_imp_kit/score)
[![popularity](https://img.shields.io/pub/popularity/mtrust_imp_kit)](https://pub.dev/packages/mtrust_imp_kit/score)
[![pub points](https://img.shields.io/pub/points/mtrust_imp_kit)](https://pub.dev/packages/mtrust_imp_kit/score)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Overview

The M-Trust IMP-Kit allows you to integrate the IMP-Reader with your mobile applications.

## Prerequisites

- Flutter SDK installed on your system.
- Basic knowledge of Flutter development.
- Access to the M-Trust IMP-Reader hardware, or use the `mtrust_virtual_strategy` for development without the hardware.

## Getting started

## Installation

Add the `mtrust_imp_kit` package to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  mtrust_imp_kit: ˆ1.0.0
```


IMP-Kit can work with different URP Connection types. The default for IMP Readers is BLE. 
Add the ble connection strategy to your project by including it in your `pubspec.yaml` file.
```yaml

dependencies:
  mtrust_imp_kit: ˆ1.0.0
  # Add the BLE connection strategy
  urp_ble_strategy: ˆ8.0.1
```

Please follow the instructions for configuring BLE for your respective platform in the [README](https://github.com/emdgroup/mtrust-urp/blob/main/mtrust_urp_ble_strategy/README.md) of the `urp_ble_strategy`!


## Usage

### Fonts

IMP-Kit utilizes the Lato font and custom icons. To include these assets, update your `pubspec.yaml`:

```yaml
fluter:
  fonts: 
    - family: Lato
      fonts:
        - asset: packages/liquid_flutter/fonts/Lato-Regular.ttf
          weight: 500
        - asset: packages/liquid_flutter/fonts/Lato-Bold.ttf
          weight: 800
    - family: LiquidIcons
      fonts:
        - asset: packages/liquid_flutter/fonts/LiquidIcons.ttf
```

### Localization
To support multiple languages, add the necessary localization delegates to your application. For comprehensive guidance on internationalization, consult the [flutter documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization).

```dart
  return const MaterialApp(
    title: 'Your awesome application',
      localizationsDelegates: [
        ...LiquidLocalizations.delegate,
        ...UrpUiLocalizations.delegate,
        ...ImpLocalizations.localizationsDelegates,
      ],
      
      home: MyHomePage(),
    );
```

## Adding UI dependencies

To utilize IMC Kit's UI components, incorporate the following providers and portals:

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

## Use the IMP Sheet 

To display the IMP Sheet, utilize the `ImpSheet` widget. It requires a connection strategy, a payload, and callbacks for the verification process:


```dart
  ImpSheet(
    strategy: _connectionStrategy,
    payload: // Payload,
    onVerificationDone: () {},
    onVerificationFailed: () {},
    builder: (context, openSheet) {
      // Call openSheet to open the IMP Sheet
    },
  ),

```

## Configuration Options
- **Connection Strategies:** While BLE is the default, IMP-Kit supports various connection strategies. Ensure you include and configure the appropriate strategy package as needed.

## Troubleshooting
- **BLE Connectivity Issues:** Verify that your device's Bluetooth is enabled and that the M-Trust IMP-Reader is powered on and in range.

- **Font Rendering Problems:** Ensure that the font assets are correctly referenced in your `pubspec.yaml` and that the files exist in the specified paths.

## Contributing
We welcome contributions! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to our coding standards and includes appropriate tests.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
