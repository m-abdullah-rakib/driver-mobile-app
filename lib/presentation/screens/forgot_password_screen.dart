import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../data/constants/rest_api_call.dart';
import '../../data/models/request/forgot_pass_request.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool hasEmailFieldError = false;

  final dio = Dio();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(context),
          body: Form(
              key: _formKey,
              child: Container(
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.h, vertical: 17.v),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Forgot Password?",
                                style: theme.textTheme.headlineLarge)),
                        SizedBox(height: 9.v),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                width: 291.h,
                                margin: EdgeInsets.only(right: 35.h),
                                child: Text(
                                    "Don't worry! It occurs. Please enter the email address linked with your account.",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles
                                        .titleMediumBluegray200
                                        .copyWith(height: 1.65)))),
                        SizedBox(height: 32.v),
                        CustomTextFormField(
                            controller: emailController,
                            hintText: "Enter your email",
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.emailAddress),
                        hasEmailFieldError
                            ? const SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      ' You need to fill this field first',
                                      // Label text
                                      style: kErrorTextStyle,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: 24.v),
                        CustomElevatedButton(
                          text: "Send Code",
                          navigationPath: '/main-screen',
                          context: context,
                          press: () => {
                            if (emailController.text.isEmpty)
                              {
                                setState(() {
                                  hasEmailFieldError = true;
                                })
                              }
                            else
                              {callAPI()}
                          },
                        ),
                        const Spacer(),
                        SizedBox(height: 5.v),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/sign-in-screen',
                            );
                          },
                          child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Remember Password?",
                                    style: CustomTextStyles
                                        .titleMediumOnPrimary_1),
                                const TextSpan(text: " "),
                                TextSpan(
                                    text: "Sign In",
                                    style: CustomTextStyles.titleMediumPrimary)
                              ]),
                              textAlign: TextAlign.left),
                        )
                      ])))),
    );
  }

  Future<void> callAPI() async {
    setState(() {
      hasEmailFieldError = false;
    });

    EasyLoading.show(status: 'loading...', dismissOnTap: false);

    ForgotPassRequest forgotPassRequest =
        ForgotPassRequest(emailController.text.toString());

    try {
      var response = await dio.post(
        RestAPICall.baseURL + RestAPICall.resetPinLinkEndPoint,
        data: jsonEncode(forgotPassRequest.toJsonLink()),
        options: Options(
          validateStatus: (status) {
            return status == null ||
                (status >= 200 && status < 300) ||
                status == 404;
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.toString());

        EasyLoading.dismiss();
        emailController.text = '';
        Navigator.pushNamed(
          context,
          '/forgot-password-token-screen',
        );
      } else if ((response.statusCode == 404)) {
        Map<String, dynamic> responseData = json.decode(response.toString());
        EasyLoading.dismiss();
        EasyLoading.showError(responseData['errors']![0]['msg']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Sorry! Something went wrong.');
    }
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: double.maxFinite,
        leading: AppbarLeadingIconButton(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.fromLTRB(24.h, 7.v, 310.h, 7.v),
            onTap: () {
              onTapArrowLeft(context);
            }));
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    if (EasyLoading.isShow) {
    } else {
      Navigator.pop(context);
    }
  }
}
