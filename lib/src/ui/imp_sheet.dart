import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/mtrust_imp_kit.dart';

/// Shows a sheet that guides the user through the securalic workflow.
/// pass the [ConnectionStrategy] to the sheet.
/// The [onIdentificationDone] will be called if the verification was successful.
/// The [onIdentificationFailed] will be called if the verification failed.
/// Provide a [builder] that renders some UI with a callback to open the sheet.
class ImpSheet extends StatelessWidget {
  /// Creates a new instance of [ImpSheet]
  const ImpSheet({
    required this.strategy,
    required this.onIdentificationDone,
    required this.onIdentificationFailed,
    required this.builder,
    this.onDismiss,
    this.disconnectOnClose = true,
    this.turnOffOnClose = true,
    this.chipIdFormat = ChipIdFormat.mac,
    super.key,
  });

  final ChipIdFormat? chipIdFormat;

  /// Whether the connection should be disconnected when the sheet is closed.
  final bool disconnectOnClose;

  /// Whether the reader should be turned off when the sheet is closed.
  final bool turnOffOnClose;

  /// Strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// Will be called if a verification was successful.
  final void Function(UrpImpMeasurement measurement) onIdentificationDone;

  /// Will be called if a verification failed.
  final void Function() onIdentificationFailed;

  /// Called when the user dismisses the sheet.
  final void Function()? onDismiss;

  /// The builder that opens the sheet.
  final Widget Function(BuildContext context, Function openSheet) builder;

  @override
  Widget build(BuildContext context) {
    return LdButtonSheet(
      buttonBuilder: builder,
      sheetBuilder: (context, dismissSheet, isOpen) {
        Future<void> dismiss() async {
          if (turnOffOnClose && strategy.status == ConnectionStatus.connected) {
            await ImpReader(connectionStrategy: strategy).off();
          }
          if (disconnectOnClose) {
            await strategy.disconnectDevice();
          }
          dismissSheet();
          onDismiss?.call();
        }

        return LdSheet(
          customDetachedSize: const Size(450, 450),
          open: isOpen,
          initialSize: 1,
          disableScroll: true,
          minInsets: LdTheme.of(context).pad(LdSize.m),
          noHeader: true,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ImpWidget(
                  chipIdFormat: chipIdFormat,
                  connectionStrategy: strategy,
                  onIdentificationDone: (UrpImpMeasurement measurement) async {
                    onIdentificationDone(measurement);
                    await dismiss();
                  },
                  onIdentificationFailed: () async {
                    onIdentificationFailed();
                    await dismiss();
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IntrinsicHeight(
                    child: LdButton(
                      size: LdSize.s,
                      mode: LdButtonMode.vague,
                      onPressed: () {
                        strategy.disconnectDevice();
                        dismiss();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).padL(),
        );
      },
    );
  }
}
