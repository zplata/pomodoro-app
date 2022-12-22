// import 'package:flutter/widgets.dart';
// import 'package:rive/rive.dart';
// import 'package:rive/math.dart';

// class RiveWrapper extends StatefulWidget {
//   /// Fit for the animation in the widget
//   final BoxFit? fit;

//   /// Alignment for the animation in the widget
//   final Alignment? alignment;

//   /// Widget displayed while the rive is loading
//   final Widget? placeHolder;

//   @override
//   RiveAnimationState createState() => RiveAnimationState();
// }

// class RiveAnimationState extends State<RiveWrapper> {
//   /// Active artboard
//   Artboard? _artboard;

//   Vec2D? _toArtboard(Offset local) {
//     RiveRenderObject? riveRenderer;
//     var renderObject = context.findRenderObject();
//     if (renderObject is! RenderBox) {
//       return null;
//     }
//     renderObject.visitChildren(
//       (child) {
//         if (child is RiveRenderObject) {
//           riveRenderer = child;
//         }
//       },
//     );
//     if (riveRenderer == null) {
//       return null;
//     }
//     var globalCoordinates = renderObject.localToGlobal(local);

//     return riveRenderer!.globalToArtboard(globalCoordinates);
//   }

//   Widget _optionalHitTester(BuildContext context, Widget child) {
//     assert(_artboard != null);
//     var hasHitTesting = _artboard!.animationControllers.any(
//       (controller) =>
//           controller is StateMachineController &&
//           (controller.hitShapes.isNotEmpty ||
//               controller.hitNestedArtboards.isNotEmpty),
//     );

//     if (hasHitTesting) {
//       void hitHelper(PointerEvent event,
//           void Function(StateMachineController, Vec2D) callback) {
//         var artboardPosition = _toArtboard(event.localPosition);
//         if (artboardPosition != null) {
//           var stateMachineControllers = _artboard!.animationControllers
//               .whereType<StateMachineController>();
//           for (final stateMachineController in stateMachineControllers) {
//             callback(stateMachineController, artboardPosition);
//           }
//         }
//       }

//       return Listener(
//         onPointerDown: (details) => hitHelper(
//           details,
//           (controller, artboardPosition) =>
//               controller.pointerDown(artboardPosition, details),
//         ),
//         onPointerUp: (details) => hitHelper(
//           details,
//           (controller, artboardPosition) =>
//               controller.pointerUp(artboardPosition),
//         ),
//         onPointerHover: (details) => hitHelper(
//           details,
//           (controller, artboardPosition) =>
//               controller.pointerMove(artboardPosition),
//         ),
//         onPointerMove: (details) => hitHelper(
//           details,
//           (controller, artboardPosition) =>
//               controller.pointerMove(artboardPosition),
//         ),
//         child: child,
//       );
//     }

//     return child;
//   }

//   @override
//   Widget build(BuildContext context) => _artboard != null
//       ? _optionalHitTester(
//           context,
//           Rive(
//             artboard: _artboard!,
//             fit: widget.fit,
//             alignment: widget.alignment,
//           ),
//         )
//       : widget.placeHolder ?? const SizedBox();
// }
