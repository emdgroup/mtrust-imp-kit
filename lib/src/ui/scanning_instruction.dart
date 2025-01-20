import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';

/// ScanningInstruction is a widget that guides the user to the correct
/// scanning position.
class ScanningInstruction extends StatefulWidget {
  /// Creates a new instance of [ScanningInstruction]
  const ScanningInstruction({super.key});

  @override
  State<ScanningInstruction> createState() => _ScanningInstructionState();
}

class _ScanningInstructionState extends State<ScanningInstruction>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  Future<void> _startAnimation() async {
    if (!mounted) {
      return;
    }
    await _controller.forward();
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }
    await _controller.reverse();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      unawaited(_startAnimation());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final value = CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ).value;
            final color = Color.alphaBlend(
              LdTheme.of(context).primaryColor.withAlpha((255 * value).toInt()),
              LdTheme.of(context).errorColor,
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 100 + (100 * value).toInt(),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/imp_reader_side.png',
                        package: 'mtrust_imp_kit',
                        alignment: Alignment.centerRight,
                        fit: BoxFit.fitHeight,
                        height: double.infinity,
                      ),
                      const Align(
                        alignment: Alignment(0.9, -0.3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_left),
                            LdTextLs("Press\ntrigger"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ldSpacerS,
                Expanded(
                  flex: 200 - (50 * value).toInt(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                          ),
                          Container(
                            height: 16,
                            width: 2,
                            color: color,
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: color,
                            ),
                          ),
                          ldSpacerS,
                          Expanded(
                            flex: 2,
                            child: LdTextL(
                              '${(5 + 10 * (1 - value)).toStringAsFixed(1)}mm',
                              color: color,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          ldSpacerS,
                          Expanded(
                            child: Container(
                              height: 2,
                              color: color,
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 2,
                            color: color,
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: (-1 + value * 2).clamp(0, 1),
                        child: const LdIndicator(type: LdIndicatorType.success),
                      ),
                    ],
                  ),
                ),
                ldSpacerS,
              ],
            );
          },
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  LdTheme.of(context).background,
                  LdTheme.of(context).background.withAlpha(0),
                  LdTheme.of(context).background.withAlpha(0),
                  LdTheme.of(context).background,
                ],
                stops: const [0, 0.1, 0.9, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
