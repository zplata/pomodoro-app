import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:rive/rive.dart';

/// An example showing how to drive two boolean state machine inputs.
class TomatoDisplay extends StatefulWidget {
  const TomatoDisplay({Key? key}) : super(key: key);

  @override
  _TomatoDisplay createState() => _TomatoDisplay();
}

class _TomatoDisplay extends State<TomatoDisplay> {
  bool isMainTaskTimer = true;
  Timer? timerTracker;
  int mainTime = 6000;
  int breakTime = 3000;
  // The Work Start state plays twice due to layering in the State Machine, so
  // we set this to true when the true Work Start state should play
  bool isWorkStarted = false;
  late SMIInput<double> _timeInput;

  void _startTimer(bool isMainTimer) {
    Timer.periodic(const Duration(milliseconds: 5), (timer) {
      timerTracker = timer;
      if (isMainTimer) {
        // The state machine goes off a 0-6000ms blend state, so for this example of 6s, increment accordingly
        setState(() => mainTime -= 5);
        _timeInput.value = _timeInput.value + 5;
        if (mainTime == 0) {
          isMainTaskTimer = false;
          timer.cancel();
        }
      } else {
        setState(() => breakTime -= 5);
        _timeInput.value = _timeInput.value + 10;
        if (breakTime == 0) {
          isMainTaskTimer = true;
          timer.cancel();
        }
      }
    });
  }

  void _riveStateChangeHandler(String smName, String toState) {
    if (toState == "Work Start") {
      if (isWorkStarted == false) {
        isWorkStarted = true;
      } else {
        _startTimer(true);
      }
    } else if (toState == "Stop") {
      if (timerTracker != null) {
        timerTracker!.cancel();
      }
    } else if (toState == "Play Dummy") {
      _startTimer(isMainTaskTimer);
    } else if (toState == "Restart" ||
        toState == "Work Finish" ||
        toState == "Break Finish") {
      // Restart timer and time input value
      timerTracker!.cancel();
      mainTime = 6000;
      breakTime = 3000;
      _timeInput.value = 0;
    } else if (toState == "Break Start") {
      _startTimer(false);
    }
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'State Machine 3',
        onStateChange: _riveStateChangeHandler);
    artboard.addController(controller!);
    _timeInput = controller.findInput<double>('time') as SMINumber;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RiveAnimation.asset(
          'assets/toemater_timer.riv',
          onInit: _onRiveInit,
        ),
        Positioned.fill(
          top: 50,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              isMainTaskTimer ? 'Work' : 'Break',
              style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 200,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "${isMainTaskTimer ? mainTime : breakTime}",
              style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
