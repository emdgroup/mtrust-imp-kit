import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/src/format_utils.dart';
import 'package:mtrust_imp_kit/src/imp_reader.dart';
import 'package:mtrust_imp_kit/src/ui/count_down_progress.dart';
import 'package:mtrust_imp_kit/src/ui/l10n/imp_localizations.dart';
import 'package:mtrust_imp_kit/src/ui/scanning_instruction.dart';
import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_ui/mtrust_urp_ui.dart';
import 'package:mtrust_urp_types/imp.pb.dart';

/// [ImpWidget] is a widget that guides the user through the p-Chip scanning
/// workflow.
class ImpWidget extends StatelessWidget {
  /// Creates a new instance of [ImpWidget]
  const ImpWidget({
    required this.connectionStrategy,
    required this.onIdentificationDone,
    required this.onIdentificationFailed,
    required this.chipIdFormat,
    this.storageAdapter,
    super.key,
  });

  final ChipIdFormat? chipIdFormat;

  /// The StorageAdapter to use for persisting the last connected and paired
  /// devices.
  final StorageAdapter? storageAdapter;

  /// The strategy to use for the connection.
  final ConnectionStrategy connectionStrategy;

  /// Will be called if a verification was successful.
  final void Function(UrpImpMeasurement measurement) onIdentificationDone;

  /// Will be called if a verification failed.
  final void Function() onIdentificationFailed;

  @override
  Widget build(BuildContext context) {
    return DeviceConnector(
      connectionStrategy: connectionStrategy,
      storageAdapter: storageAdapter,
      connectedBuilder: (BuildContext context) {
        return LdSubmit<bool>(
          config: LdSubmitConfig<bool>(
            loadingText: ImpLocalizations.of(context).primingTitle,
            autoTrigger: true,
            action: () async {
              final reader = ImpReader(
                connectionStrategy: connectionStrategy,
              );
              await reader.prime();
              return true;
            },
          ),
          builder: LdSubmitCustomBuilder<bool>(
            builder: (context, controller, stateType) {
              if (stateType == LdSubmitStateType.error) {
                return LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextH(
                      ImpLocalizations.of(context).primeFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      controller.state.error?.moreInfo ?? 'Unknown error',
                    ),
                    const Expanded(
                      child: IMPReaderVisualization(
                        ledColor: Colors.red,
                      ),
                    ),
                    LdButtonWarning(
                      onPressed: controller.trigger,
                      context: context,
                      child: Text(
                        ImpLocalizations.of(context).retry,
                      ),
                    ),
                  ],
                );
              }

              if (stateType == LdSubmitStateType.loading) {
                return Center(
                  child: LdAutoSpace(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    animate: true,
                    children: [
                      const LdLoader(),
                      LdTextL(
                        ImpLocalizations.of(context).primingTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return _ScanningView(
                chipIdFormat: chipIdFormat,
                strategy: connectionStrategy,
                onIdentificationDone: (measuremnt) {
                  controller.reset();
                  onIdentificationDone(measuremnt);
                },
                onVerificationFailed: () {
                  controller.reset();
                  onIdentificationFailed();
                },
              );
            },
          ),
        );
      },
      deviceTypes: const {UrpDeviceType.urpImp},
    );
  }
}

class _ScanningView extends StatelessWidget {
  const _ScanningView({
    required this.strategy,
    required this.onIdentificationDone,
    required this.onVerificationFailed,
    this.chipIdFormat,
  });

  final ChipIdFormat? chipIdFormat;
  final ConnectionStrategy strategy;
  final void Function(UrpImpMeasurement measurement) onIdentificationDone;
  final void Function() onVerificationFailed;

  String _getFormattedAddress(UrpImpMeasurement? measurement) {
    if (measurement == null || chipIdFormat == null) {
      return 'Unknown ID';
    }
    if (measurement.result.isEmpty) {
      return 'Unknown ID';
    }

    final id = measurement.result.first.id;
    return formatChipId(id, chipIdFormat!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LdSubmit<UrpImpMeasurement>(
        config: LdSubmitConfig<UrpImpMeasurement>(
          loadingText: ImpLocalizations.of(context).scanning,
          submitText: ImpLocalizations.of(context).startScan,
          timeout: const Duration(seconds: 35),
          action: () async {
            final reader = ImpReader(
              connectionStrategy: strategy,
            );
            return await reader.startMeasurement();
          },
        ),
        builder: LdSubmitCustomBuilder<UrpImpMeasurement>(
          builder: (context, measurementController, measurementStateType) {
            return switch (measurementStateType) {
              (LdSubmitStateType.loading) => LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      ImpLocalizations.of(context).scanning,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      ImpLocalizations.of(context).distanceHint,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(ImpLocalizations.of(context).holdTriggerHint),
                    ldSpacerL,
                    const Expanded(
                      child: ScanningInstruction(),
                    ),
                    ldSpacerL,
                    const CountDownProgress(),
                    ldSpacerL,
                  ],
                ),
              (LdSubmitStateType.result) => LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  animate: true,
                  children: [
                    LdTextHs(
                      ImpLocalizations.of(context).successfullyRead,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      _getFormattedAddress(
                        measurementController.state.result,
                      ),
                    ),
                    const LdIndicator(
                      type: LdIndicatorType.success,
                      size: LdSize.l,
                    ),
                    ldSpacerL,
                    LdButton(
                      onPressed: () => onIdentificationDone(
                        measurementController.state.result!,
                      ),
                      child: Text(
                        ImpLocalizations.of(context).done,
                      ),
                    ),
                  ],
                ),
              (LdSubmitStateType.idle) => LdAutoSpace(
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      ImpLocalizations.of(context).readyToScan,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      ImpLocalizations.of(context).timeHint,
                      textAlign: TextAlign.center,
                    ),
                    const Expanded(
                      child: IMPReaderVisualization(
                        ledColor: Colors.yellow,
                      ),
                    ),
                    LdButton(
                      onPressed: measurementController.trigger,
                      child: Text(
                        ImpLocalizations.of(context).startScan,
                      ),
                    ),
                  ],
                ).padL(),
              (LdSubmitStateType.error) => LdAutoSpace(
                  animate: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      ImpLocalizations.of(context).readingFailed,
                      textAlign: TextAlign.center,
                    ),
                    LdTextP(
                      ImpLocalizations.of(context).readingFailedMessage,
                      textAlign: TextAlign.center,
                    ),
                    const Expanded(
                      child: IMPReaderVisualization(
                        ledColor: Colors.red,
                      ),
                    ),
                    LdButtonWarning(
                      onPressed: onVerificationFailed,
                      context: context,
                      child: Text(
                        ImpLocalizations.of(context).done,
                      ),
                    ),
                  ],
                ).padL(),
            };
          },
        ),
      ),
    );
  }
}
