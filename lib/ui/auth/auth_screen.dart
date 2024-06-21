// import 'package:flutter/material.dart';
//
// import 'auth_card.dart';
// import 'app_banner.dart';
//
// class AuthScreen extends StatelessWidget {
//   static const routeName = '/auth';
//
//   const AuthScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.sizeOf(context);
//     return Scaffold(
//       // resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color.fromRGBO(6, 59, 112, 1.0).withOpacity(0.5),
//                   const Color.fromRGBO(208, 38, 220, 1.0).withOpacity(0.9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: const [0, 1],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: SizedBox(
//               height: deviceSize.height,
//               width: deviceSize.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   const Flexible(
//                     child: AppBanner(),
//                   ),
//                   Flexible(
//                     flex: deviceSize.width > 600 ? 2 : 1,
//                     child: const AuthCard(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// code tren của minh
// import 'package:flutter/material.dart';
//
// import 'auth_card.dart';
//
// class AuthScreen extends StatelessWidget {
//   static const routeName = '/auth';
//
//   const AuthScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.sizeOf(context);
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // Container(
//           //     decoration: const BoxDecoration(
//           //       image: DecorationImage(
//           //         image: AssetImage('assets/images/wallpaper.jpg'),
//           //         fit: BoxFit.cover,
//           //       ),
//           //     )),
//           SingleChildScrollView(
//             padding: const EdgeInsets.only(top: 100),
//             child: Flex(
//               direction: Axis.vertical,
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: deviceSize.height - 100,
//                   width: deviceSize.width,
//                   child: const Column(
//                     children: <Widget>[
//                       Flexible(child: AuthCard()),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
//
// import 'auth_card.dart';
// import 'app_banner.dart';
//
// class AuthScreen extends StatelessWidget {
//   static const routeName = '/auth';
//
//   const AuthScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(height: deviceSize.height * 0.1),
//                   AppBanner(), // Hiển thị banner ứng dụng
//                   SizedBox(height: deviceSize.height * 0.1),
//                   AuthCard(), // Hiển thị form đăng nhập
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromRGBO(6, 59, 112, 1.0).withOpacity(0.8),
//                           Color.fromRGBO(208, 38, 220, 1.0).withOpacity(0.8),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         stops: const [0, 1],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'auth_card.dart';


class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(28, 101, 12, 1.0).withOpacity(0.8),
                  const Color.fromRGBO(13, 54, 2, 1.0).withOpacity(1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: deviceSize.width * 0.95,
                height: deviceSize.height * 0.85,
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white, // Màu trắng cho AuthCard
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AuthCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
