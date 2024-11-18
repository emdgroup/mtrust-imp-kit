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

class _AdvancedWorkflowState extends State<AdvancedWorkflow> {

  final UrpBleStrategy _bleStrategy = UrpBleStrategy();
  late final ImpReader _impReader = ImpReader(connectionStrategy: _bleStrategy);

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
    print('Measurement Result: ${response.result.first.id}');
    return response.result.first.id;
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
        child: ElevatedButton(
          onPressed: primeReader, 
          child: const Text(
            'Prime reader and start Measurement',
          ),
        ),
      );
    }
  }
  
  @override
  bool get wantKeepAlive => true;
}
