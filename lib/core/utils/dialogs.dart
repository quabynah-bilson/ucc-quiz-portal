import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucc_quiz_portal/core/utils/extensions.dart';
import 'package:ucc_quiz_portal/generated/assets.dart';
import 'package:ucc_quiz_portal/ui/widgets/button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constant.dart';

Future<void> showExitAttemptSheet(BuildContext context) async =>
    await showCupertinoModalBottomSheet(
      context: context,
      enableDrag: false,
      backgroundColor: context.colorScheme.background,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, context.padding.bottom + 24),
        decoration: BoxDecoration(
          color: context.colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(Assets.animSecurityLock,
                height: context.height * 0.15),
            const SizedBox(height: 16),
            Text(
              'One more thing...',
              style: context.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'You have 3 exit attempts when the quiz starts. After the third attempt you will be logged out of the application.',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            AppButton(label: 'Okay, Got it!', onPressed: context.navigator.pop),
          ],
        ),
      ),
    );

Future<void> showStudentAppExitAttemptSheet(BuildContext context,
    {WebViewController? webViewController}) async {
  final formKey = GlobalKey<FormState>(),
      studentIdController = TextEditingController();
  await showCupertinoModalBottomSheet(
    context: context,
    backgroundColor: context.colorScheme.background,
    builder: (context) => Material(
      type: MaterialType.transparency,
      color: context.colorScheme.background,
      child: StatefulBuilder(
          builder: (context, setState) => Container(
                padding: EdgeInsets.fromLTRB(
                    24, 24, 24, context.padding.bottom + 24),
                decoration: BoxDecoration(
                  color: context.colorScheme.background,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you leaving?',
                        style: context.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'You tried leaving the quiz for the third time. Enter your student ID to confirm this action.',
                        style: context.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: studentIdController,
                        decoration: InputDecoration(
                          hintText: 'Student ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kDefaultRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your student ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      AppButton(
                          label: 'Okay, Got it!',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await webViewController?.clearCache();
                              await webViewController?.clearLocalStorage();
                              SystemNavigator.pop(animated: true);
                            }
                          }),
                    ],
                  ),
                ),
              )),
    ),
  );
}
