import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';
import 'package:mtrust_imp_kit/src/ui/count_down_progress.dart';

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
    this.readerConnectorMode = ReaderConnectorMode.preferLastConnected,
    this.payload,
    this.tokenAmount,
    super.key,
  });

  final ChipIdFormat? chipIdFormat;

  /// The StorageAdapter to use for persisting the last connected and paired
  /// devices.
  final StorageAdapter? storageAdapter;

  /// The mode to use when connecting to a device.
  final ReaderConnectorMode readerConnectorMode;

  /// The strategy to use for the connection.
  final ConnectionStrategy connectionStrategy;

  /// Will be called if a verification was successful.
  final void Function(UrpImpSecureMeasurement measurement) onIdentificationDone;

  /// Will be called if a verification failed.
  /// The [exception] parameter contains details about the failure.
  final void Function(ImpReaderException exception) onIdentificationFailed;

  /// The payload to send to the reader.
  final String? payload;

  /// Amount of token to be requested on token refresh.
  final int? tokenAmount;

  @override
  Widget build(BuildContext context) {
    return DeviceConnector(
      connectionStrategy: connectionStrategy,
      storageAdapter: storageAdapter,
      mode: readerConnectorMode,
      connectedBuilder: (BuildContext context) {
        return LdSubmit<UrpImpPrimeResponse?>(
          config: LdSubmitConfig<UrpImpPrimeResponse?>(
            loadingText: ImpLocalizations.of(context).primingTitle,
            autoTrigger: true,
            action: () async {
              final reader = ImpReader(
                connectionStrategy: connectionStrategy,
              );

              // TODO: Add back in then firmware compatibility check feature is working as expected
              // final info = await reader.info();
              // final compatible =
              //     await reader.compatibilityCheck(info.fwVersion);
              // final requiredFirmware = await reader.requiredFirmwareRange();
              // if (!compatible) {
              //   throw ImpReaderException(
              //     type: ImpReaderExceptionType.incompatibleFirmware,
              //     message: 'Required version: $requiredFirmware',
              //   );
              // }

              if (tokenAmount != null) {
                reader.setTokenAmount(tokenAmount!);
              }
              return await reader.prime(payload);
            },
          ),
          builder: LdSubmitCustomBuilder<UrpImpPrimeResponse?>(
            builder: (context, controller, stateType) {
              if (stateType == LdSubmitStateType.error) {
                String message =
                    controller.state.error?.message ?? 'Unknown error';
                if (controller.state.error?.exception is ImpReaderException) {
                  final ImpReaderException error =
                      controller.state.error?.exception as ImpReaderException;
                  if (error.type == ImpReaderExceptionType.tokenFailed) {
                    message = ImpLocalizations.of(context).tokenFailed;
                  }
                  if (error.type ==
                      ImpReaderExceptionType.incompatibleFirmware) {
                    final fwRange = message.split('Required version: ').last;
                    return LdAutoSpace(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LdTextHs(
                          ImpLocalizations.of(context).incompatibleFirmware,
                          textAlign: TextAlign.center,
                        ),
                        ldSpacerL,
                        LdTextP(
                          '${ImpLocalizations.of(context).requiredFirmware} $fwRange',
                          textAlign: TextAlign.center,
                        ),
                        ldSpacerS,
                        LdMute(
                          child: LdTextP(
                            ImpLocalizations.of(context).firmwareHint,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ldSpacerL,
                        LdButtonWarning(
                          onPressed: connectionStrategy.disconnectDevice,
                          context: context,
                          child: Text(
                            ImpLocalizations.of(context).disconnect,
                          ),
                        ),
                      ],
                    );
                  }
                }
                if (controller.state.error?.exception.runtimeType ==
                    ApiException) {
                  message = ImpLocalizations.of(context).tokenFailed;
                }
                return LdAutoSpace(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LdTextHs(
                      ImpLocalizations.of(context).primeFailed,
                      textAlign: TextAlign.center,
                    ),
                    const Expanded(
                      child: IMPReaderVisualization(
                        ledColor: Colors.red,
                      ),
                    ),
                    LdTextP(
                      message,
                      textAlign: TextAlign.center,
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
                remainingScans: controller.state.result?.gsa,
                strategy: connectionStrategy,
                onIdentificationDone: (measurement) {
                  controller.reset();
                  onIdentificationDone(measurement);
                },
                onVerificationFailed: (exception) {
                  controller.reset();
                  onIdentificationFailed(exception);
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
    this.remainingScans,
    this.chipIdFormat,
  });

  final ChipIdFormat? chipIdFormat;
  final int? remainingScans;
  final ConnectionStrategy strategy;
  final void Function(UrpImpSecureMeasurement measurement) onIdentificationDone;
  final void Function(ImpReaderException exception) onVerificationFailed;

  String _getFormattedAddress(UrpImpSecureMeasurement? measurement) {
    if (measurement == null || chipIdFormat == null) {
      return 'Unknown ID';
    }
    if (measurement.measurement.id.isNaN) {
      return 'Unknown ID';
    }

    final id = measurement.measurement.id;
    return formatChipId(id, chipIdFormat!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LdSubmit<UrpImpSecureMeasurement>(
        config: LdSubmitConfig<UrpImpSecureMeasurement>(
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
        builder: LdSubmitCustomBuilder<UrpImpSecureMeasurement>(
          builder: (context, measurementController, measurementStateType) {
            switch (measurementStateType) {
              case (LdSubmitStateType.loading):
                {
                  return LdAutoSpace(
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
                      LdMute(
                        child: LdTextPs(
                          ImpLocalizations.of(context).holdTriggerHint,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ldSpacerL,
                      const Expanded(
                        child: ScanningInstruction(),
                      ),
                      ldSpacerL,
                      const CountDownProgress(),
                      ldSpacerL,
                    ],
                  );
                }
              case (LdSubmitStateType.result):
                {
                  return LdAutoSpace(
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
                        textAlign: TextAlign.center,
                      ),
                      ldSpacerL,
                      const Expanded(
                        child: IMPReaderVisualization(
                          ledColor: Colors.green,
                        ),
                      ),
                      ldSpacerL,
                      LdButtonVague(
                        width: double.infinity,
                        borderRadius: LdTheme.of(context).radius(LdSize.l),
                        size: LdSize.l,
                        onPressed: () => onIdentificationDone(
                          measurementController.state.result!,
                        ),
                        child: Text(
                          ImpLocalizations.of(context).done,
                        ),
                      ),
                    ],
                  );
                }
              case (LdSubmitStateType.idle):
                {
                  return LdAutoSpace(
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
                      LdMute(
                        child: LdTextPs(
                          ImpLocalizations.of(context).readingsLeft(
                            remainingScans?.toString() ??
                                ImpLocalizations.of(context).unknown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      LdButtonVague(
                        onPressed: measurementController.trigger,
                        borderRadius: LdTheme.of(context).radius(LdSize.l),
                        width: double.infinity,
                        size: LdSize.l,
                        child: Text(
                          ImpLocalizations.of(context).startScan,
                        ),
                      ),
                    ],
                  );
                }
              case (LdSubmitStateType.error):
                {
                  String message =
                      ImpLocalizations.of(context).readingFailedMessage;
                  ImpReaderException exception = ImpReaderException(
                    type: ImpReaderExceptionType.measurementFailed,
                    message: message,
                  );
                  if (measurementController
                          .state.error?.exception.runtimeType ==
                      ImpReaderException) {
                    exception = measurementController.state.error?.exception
                        as ImpReaderException;
                    if (exception.type ==
                        ImpReaderExceptionType.incompatibleFirmware) {
                      message =
                          ImpLocalizations.of(context).incompatibleFirmware;
                    }
                  }
                  return LdAutoSpace(
                    animate: true,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LdTextHs(
                        ImpLocalizations.of(context).readingFailed,
                        textAlign: TextAlign.center,
                      ),
                      LdTextP(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      const Expanded(
                        child: IMPReaderVisualization(
                          ledColor: Colors.red,
                        ),
                      ),
                      LdButtonWarning(
                        width: double.infinity,
                        borderRadius: LdTheme.of(context).radius(LdSize.l),
                        size: LdSize.l,
                        onPressed: () => onVerificationFailed(exception),
                        context: context,
                        child: Text(
                          ImpLocalizations.of(context).done,
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
