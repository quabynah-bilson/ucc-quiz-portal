import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ucc_quiz_portal/core/app.dart';
import 'package:ucc_quiz_portal/core/utils/dialogs.dart';
import 'package:ucc_quiz_portal/core/utils/logs.dart';
import 'package:ucc_quiz_portal/models/active.dart';

import 'active.dart';

class MyWidgetsBindingObserver with WidgetsBindingObserver {
  final ActiveState activeState;
  final StreamController<int> _activeCountStreamController =
      StreamController<int>.broadcast();

  Stream<int> get activeCountStream => _activeCountStreamController.stream;

  MyWidgetsBindingObserver(this.activeState) {
    activeState.activeObject?.getActives().listen((List<Active> actives) {
      // Assuming you have a function to get the count of stored items
      int itemCount = actives.length;

      // Update the active count stream
      _activeCountStreamController.sink.add(itemCount);

      logger.d('Stored Item Count: $itemCount');
    });
  }

  // @todo -> check if user is attempting to leave the app for a third time
  // @todo -> add show a dialog for the user to confirm their student ID
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      activeState.activeObject?.addActive(1);
      activeCountStream.listen((itemCount) {
        if(itemCount >= 3) {
          // showStudentAppExitAttemptSheet(context, webViewController: );
        }
      });


      // showDialog(
      //   barrierDismissible: false,
      //   context: navigatorKey.currentState!.overlay!.context,
      //   builder: (BuildContext context) {
      //     activeState.activeObject?.addActive(1);
      //
      //     // The active count stream will be updated automatically when the stream emits a new value
      //     // You can access the latest active count using _activeCountStreamController.stream
      //     return StreamBuilder<int>(
      //       stream: activeCountStream,
      //       builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //         if (snapshot.hasData) {
      //           int itemCount = snapshot.data!;
      //
      //           if (itemCount >= 4) {
      //             return AlertDialog(
      //               title: const Text('App Paused'),
      //               content: const Text(
      //                   'Your application has been paused due to unusual activity'),
      //               actions: [
      //                 TextButton(
      //                   child: const Text('Okay'),
      //                   onPressed: () {
      //                     // Navigator.of(context).pop();
      //                     closeAppUsingSystemPop();
      //                   },
      //                 ),
      //               ],
      //             );
      //           } else {
      //             return AlertDialog(
      //               title: const Text('Warning'),
      //               content: const Text(
      //                   'You are not allowed. You are trying to navigate outside your quiz / exams environment'),
      //               actions: [
      //                 TextButton(
      //                   child: const Text('Okay'),
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ],
      //             );
      //           }
      //         } else {
      //           // Handle the case where snapshot doesn't have data yet
      //           return const CircularProgressIndicator();
      //         }
      //       },
      //     );
      //   },
      // );
    }
  }

  void dispose() {
    // _activateSubscription?.cancel();
    _activeCountStreamController.close();
  }
}

void closeAppUsingSystemPop() async {
  await SystemNavigator.pop(animated: true);
  // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}
