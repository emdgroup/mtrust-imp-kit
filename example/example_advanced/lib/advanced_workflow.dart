import 'package:flutter/material.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';
import 'package:mtrust_urp_ble_strategy/mtrust_urp_ble_strategy.dart';

class AdvancedWorkflow extends StatefulWidget {

  const AdvancedWorkflow({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdvancedWorkflowState();
  }
}

// The WidgetsBindingObserver is used to disconnect the reader
// if the app is moved to background
class _AdvancedWorkflowState extends State<AdvancedWorkflow> 
  with WidgetsBindingObserver {

  final UrpBleStrategy _bleStrategy = UrpBleStrategy();
  late final ImpReader _impReader = ImpReader(connectionStrategy: _bleStrategy);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Disconnect the device if the app is paused
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        if(_bleStrategy.status == ConnectionStatus.connected) {
          _bleStrategy.disconnectDevice();
        }
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  // Find and connect a IMP Reader
  Future<void> findAndConnect() async {
    await _bleStrategy.findAndConnectDevice(
      readerTypes: {UrpDeviceType.urpImp}
    );
  }

  Future<void> disconnect() async {
    await _bleStrategy.disconnectDevice();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _bleStrategy, 
      builder: (context, child) {
        switch(_bleStrategy.status) {
          case ConnectionStatus.idle:
            return Center(
              child: ElevatedButton(
                onPressed: findAndConnect, 
                child: const Text(
                  'Find and connect IMP Reader',
                ),
              ),
            );
          case ConnectionStatus.searching:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionStatus.connecting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionStatus.connected:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReaderWidget(reader: _impReader),
                const SizedBox(height: 40.0,),
                ElevatedButton(
                  onPressed: disconnect, 
                  child: const Text(
                    'Disconnect Reader',
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class ReaderWidget extends StatefulWidget {

  const ReaderWidget({
    required this.reader,
    super.key,
  });

  final ImpReader reader;

  @override
  State<StatefulWidget> createState() {
    return _ReaderWidgetState();
  }
}

class _ReaderWidgetState extends State<ReaderWidget> with AutomaticKeepAliveClientMixin {

  late bool primeAndMeasure;
  late Future<int> measuring;

  // Priming the reader in order to start a measurement
  Future<void> primeReader() async {
    await widget.reader.prime();
    measuring = measure();
    setState(() {
      primeAndMeasure = true;
    });
  }

  // Start measurement
  Future<int> measure() async {
    final response = await widget.reader.startMeasurement();
    // ignore: avoid_print
    print('Measurement Result: ${response.measurement.id}');
    return response.measurement.id;
  }

  @override
  void initState() {
    super.initState();
    primeAndMeasure = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(primeAndMeasure) {
      return Center(
        child: FutureBuilder(
          future: measuring, 
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return Center(
                child: Text('An error occured: ${snapshot.error}'),
              );
            }
            if(snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Result: ${snapshot.data}'),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () {
                      // Reset UI
                      setState(() {
                        primeAndMeasure = false;
                      });
                    }, 
                    child: const Text('OK'),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: widget.reader.getName, 
              child: const Text(
                'Get name',
              ),
            ),
            ElevatedButton(
              onPressed: primeReader, 
              child: const Text(
                'Prime reader and start Measurement',
              ),
            ),
          ],
        )
      );
    }
  }
  
  @override
  bool get wantKeepAlive => true;
}
