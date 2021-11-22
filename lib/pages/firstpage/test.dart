// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class CustomRefresher extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CustomRefresherState();
//   }
// }

// class _CustomRefresherState extends State<CustomRefresher>
//     with TickerProviderStateMixin {
//   late AnimationController _anicontroller, _scaleController;
//   RefreshController _refreshController = RefreshController();

//   @override
//   void initState() {
//     _anicontroller = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 2000));
//     _scaleController =
//         AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
//     _refreshController.headerMode!.addListener(() {
//       if (_refreshController.headerStatus == RefreshStatus.idle) {
//         _scaleController.value = 0.0;
//         _anicontroller.reset();
//       } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
//         _anicontroller.repeat();
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     _scaleController.dispose();
//     _anicontroller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SmartRefresher(
//         controller: _refreshController,
//         onRefresh: ,
//         onLoading: ,
//         child: ,
//         header: CustomHeader(
//           refreshStyle: RefreshStyle.Behind,
//           onOffsetChange: (offset) {
//             if (_refreshController.headerMode!.value !=
//                 RefreshStatus.refreshing)
//               _scaleController.value = offset / 80.0;
//           },
//           builder: (_, __) {
//             return Container(
//               child: FadeTransition(
//                 opacity: _scaleController,
//                 child: ScaleTransition(
//                   child: SpinKitChasingDots(
//                     size: 30.0,
//                     color: Colors.white,
//                   ),
//                   scale: _scaleController,
//                 ),
//               ),
//               alignment: Alignment.center,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
