import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';
import 'package:mtrust_urp_ble_strategy/mtrust_urp_ble_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final UrpBleStrategy _bleStrategy = UrpBleStrategy();

  // Will be called if a identifcation was successful. Add the logic here to
  // control what should happen after a successful identification.
  void onIdentificationDone(UrpImpSecureMeasurement content) {
    // ignore: avoid_print
    print("Measurement successful: ${content.toDebugString()}");
  }

  // Will be called if a identifcation failed. Add the logic here to control
  // what should happen after a failed identification.
  void onIdentificationFailed() {
    // ignore: avoid_print
    print("Measurement failed.");
  }

  @override
  Widget build(BuildContext context) {
    return LdThemeProvider(
      child: LdThemedAppBuilder(
        appBuilder: (context, theme) => MaterialApp(
          theme: theme,
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            ImpLocalizations.delegate,
            UrpUiLocalizations.delegate,
            LiquidLocalizations.delegate,
          ],

          debugShowCheckedModeBanner:
              false, //Disable debug banner (top right) in debug mode
          home: LdPortal(
            child: Scaffold(
                appBar: LdAppBar(
                  context: context,
                  title: const Text('IMP Example Application'),
                ),
                body: ImpModalBuilder(
                  turnOffOnClose: false,
                  disconnectOnClose: true,
                  strategy: _bleStrategy,
                  onIdentificationDone: (content) {
                    onIdentificationDone(content);
                  },
                  onIdentificationFailed: () {},
                  builder: (BuildContext context, Function openSheet) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LdButton(
                            onPressed: openSheet,
                            child: const Text('Start Identification'),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
