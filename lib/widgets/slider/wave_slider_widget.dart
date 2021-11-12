// import 'dart:math';

// import 'package:flutter/material.dart';

// List<int> bars = [];
// const barWidth = 5.0;
// late double screenWidth;
// late int numberOfBars;

// // void main() {
// //   runApp(MyApp());
// // }

// // // class MyApp extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: Home(),
// // //     );
// // //   }
// // // }

// void randomNumberGenerator() {
//   Random r = Random();
//   for (var i = 0; i < numberOfBars; i++) {
//     bars.add(r.nextInt(40) + 10);
//   }
// }

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     if (bars.isEmpty) {
//       screenWidth = MediaQuery.of(context).size.width;
//       numberOfBars = screenWidth ~/ barWidth;
//       randomNumberGenerator();
//     }
//     return Container(child: WaveSlider());
//   }
// }

// class WaveSlider extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => WaveSliderState();
// }

// class WaveSliderState extends State<WaveSlider> {
//   double bar2Position = 180.0;

//   _onTapDown(TapDownDetails details) {
//     var x = details.globalPosition.dx;
//     print("tap down " + x.toString());
//     setState(() {
//       bar2Position = x;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int barItem = 0;
//     return Scaffold(
//       body: Center(
//         child: Stack(
//           alignment: Alignment.centerLeft,
//           children: <Widget>[
//             GestureDetector(
//               onTapDown: (TapDownDetails details) => _onTapDown(details),
//               onHorizontalDragUpdate: (DragUpdateDetails details) {
//                 setState(() {
//                   bar2Position = details.globalPosition.dx;
//                 });
//               },
//               child: Container(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: bars.map((int height) {
//                     Color color = barItem + 1 < bar2Position / barWidth
//                         ? Colors.deepPurple
//                         : Colors.blueGrey;
//                     barItem++;
//                     return Container(
//                       color: color,
//                       height: height.toDouble(),
//                       width: 5.0,
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
