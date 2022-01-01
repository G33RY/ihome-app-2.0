import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:ihome/helpers/utils.dart';

class MyButton extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final void Function()? onDoubleTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration? boxDecoration;
  final FeedbackType feedbackType;
  final bool playSound;

  const MyButton({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongTap,
    this.onDoubleTap,
    this.padding,
    this.margin,
    this.boxDecoration,
    this.feedbackType: FeedbackType.light,
    this.playSound: false,
  }) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  double scale = 1;
  late AnimationController _controller;

  @override
  initState() {
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0.98,
        upperBound: 1.0,
        duration: Duration(milliseconds: 50));
    _controller.addListener(controllerListener);
    super.initState();
  }

  controllerListener() {
    setState(() {
      scale = _controller.value;
    });
  }

  @override
  dispose() {
    if (mounted) {
      _controller.stop();
      _controller.removeListener(controllerListener);
      _controller.dispose(); // you need this
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _controller.reverse(),
      onTapUp: (details) => _controller.forward(from: 0.0),
      onLongPress: () => widget.onLongTap?.call(),
      onTap: () async {
        if (Utils.canVibrate) {
          Vibrate.feedback(widget.feedbackType);
        }
        if (widget.playSound) SystemSound.play(SystemSoundType.click);
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.forward(from: 0.0),
      onDoubleTap: widget.onDoubleTap,
      child: Container(
        padding: widget.padding,
        margin: widget.margin,
        decoration: widget.boxDecoration,
        transform: Transform.scale(scale: scale).transform,
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
