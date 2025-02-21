import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:mtrust_imp_kit/src/format_utils.dart';
import 'package:mtrust_imp_kit/src/imp_reader.dart';
import 'package:mtrust_imp_kit/src/ui/imp_result.dart';
import 'package:mtrust_imp_kit/src/ui/imp_widget.dart';
import 'package:mtrust_urp_core/mtrust_urp_core.dart';
import 'package:mtrust_urp_types/imp.pb.dart';

/// Shows a sheet that guides the user through the securalic workflow.
/// pass the [ConnectionStrategy] to the sheet.
/// The [onIdentificationDone] will be called if the verification was successful.
/// The [onIdentificationFailed] will be called if the verification failed.
/// Provide a [builder] that renders some UI with a callback to open the sheet.
class ImpModalBuilder extends StatelessWidget {
  /// Creates a new instance of [ImpModalBuilder]
  const ImpModalBuilder({
    required this.strategy,
    required this.onIdentificationDone,
    required this.onIdentificationFailed,
    required this.builder,
    this.chipIdFormat = ChipIdFormat.mac,
    this.payload,
    this.onDismiss,
    this.disconnectOnClose = true,
    this.turnOffOnClose = true,
    this.canDismiss = true,
    super.key,
  });

  /// Whether the connection should be disconnected when the sheet is closed.
  final bool disconnectOnClose;

  /// Whether the reader should be turned off when the sheet is closed.
  final bool turnOffOnClose;

  /// Called when the user dismisses the sheet.
  final void Function()? onDismiss;

  /// Whether the modal can be dismissed by the user
  final bool canDismiss;

  final ChipIdFormat? chipIdFormat;

  final String? payload;

  /// Strategy to use for the connection.
  final ConnectionStrategy strategy;

  /// Will be called if a verification was successful.
  final void Function(UrpImpSecureMeasurement measurement) onIdentificationDone;

  /// Will be called if a verification failed.
  final void Function() onIdentificationFailed;

  /// The builder that opens the sheet.
  final Widget Function(BuildContext context, Function openSheet) builder;

  @override
  Widget build(BuildContext context) {
    var topRadius = LdTheme.of(context).sizingConfig.radiusM;
    var bottomRadius = 0.0;
    var useSafeArea = true;
    var insets = EdgeInsets.zero;
    final screenRadius = LdTheme.of(context).screenRadius;

    if(screenRadius != 0) {
      topRadius = screenRadius - 1;
      bottomRadius = screenRadius - 1;
      if(!kIsWeb && Platform.isIOS) {
        useSafeArea = false;
        insets = const EdgeInsets.all(1);
      }
    }

    Future<void> handleClose() async {
      if(turnOffOnClose && strategy.status == ConnectionStatus.connected) {
        await ImpReader(connectionStrategy: strategy).off();
      }
      if(disconnectOnClose) {
        await strategy.disconnectDevice();
      }
    }

    return LdModalBuilder(
      builder: (context, openModal) {
        return builder(context, () async {
          final result = await openModal();
          if(result is ImpResultFailed) {
            onIdentificationFailed();
          } else if(result is ImpResultSuccess) {
            onIdentificationDone(result.measurement);
          } else {
            onDismiss?.call();
          }
          await handleClose();
        });
      }, 
      modal: impModal(
        canDismiss: canDismiss,
        insets: insets,
        topRadius: topRadius,
        bottomRadius: bottomRadius,
        useSafeArea: useSafeArea,
        strategy: strategy,
        chipFormat: chipIdFormat,
        payload: payload,
      ),
    );
  }
}

/// Returned in case of a successful IMP identification.
class ImpResultSuccess extends ImpResult {
  ///Creates a new instance of [ImpResultSuccess]
  ImpResultSuccess(this.measurement);

  final UrpImpSecureMeasurement measurement;
}

/// Returned in case of a dismissed IMP identification.
class ImpResultDismissed extends ImpResult {}

/// Returned in case of a failed IMP identification (e.g. timeout)
class ImpResultFailed extends ImpResult {}

LdModal impModal({
  /// Whether the modal can be dismissed by the user
  required bool canDismiss,

  /// The top radius of the modal
  required double topRadius,

  /// The bottom radius of the modal
  required double bottomRadius,

  /// The strategy to use for the connection
  required ConnectionStrategy strategy,

  /// The insets of the modal
  required EdgeInsets insets,

  /// Whether to use safe area inside the modal
  required bool useSafeArea,

  /// The chip format
  ChipIdFormat? chipFormat,

  /// The payload to send to the reader
  String? payload,
}) {
  return LdModal(
    disableScrolling: true,
    padding: EdgeInsets.zero,
    noHeader: true,
    userCanDismiss: canDismiss,
    topRadius: topRadius,
    fixedDialogSize: const Size(400, 400),
    bottomRadius: bottomRadius,
    useSafeArea: useSafeArea,
    insets: insets,
    size: LdSize.s,
    modalContent: (context) => AspectRatio(
      aspectRatio: 1,
      child: ImpWidget(
        connectionStrategy: strategy, 
        onIdentificationDone: (UrpImpSecureMeasurement measurement) async {
          Navigator.of(context).pop(ImpResultSuccess(measurement));
        }, 
        onIdentificationFailed: () async {
          Navigator.of(context).pop(ImpResultFailed());
        }, 
        chipIdFormat: chipFormat,
        payload: payload,
      ),
    ).padL(),
  );
}
