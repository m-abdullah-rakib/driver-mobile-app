import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driver_app/presentation/screens/sign_in_screen.dart';
import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../data/constants/rest_api_call.dart';
import '../../data/models/request/forgot_pass_request.dart';

class ForgotPasswordTokenScreen extends StatefulWidget {
  const ForgotPasswordTokenScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordTokenScreenState createState() =>
      ForgotPasswordTokenScreenState();
}

class ForgotPasswordTokenScreenState extends State<ForgotPasswordTokenScreen> {
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  FocusNode? newPassFocusNode;
  FocusNode? confirmNewPassFocusNode;

  final newPassController = TextEditingController();
  final confirmNewPassController = TextEditingController();
  bool hasNewPassFieldError = false;
  bool hasConfirmNewPassFieldError = false;
  final controllerField1 = TextEditingController();
  final controllerField2 = TextEditingController();
  final controllerField3 = TextEditingController();
  final controllerField4 = TextEditingController();
  final controllerField5 = TextEditingController();
  final controllerField6 = TextEditingController();

  String otpText = '';
  bool hasOtpFieldError = false;

  final dio = Dio();

  @override
  void initState() {
    super.initState();

    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    newPassFocusNode = FocusNode();
    confirmNewPassFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
    newPassFocusNode!.dispose();
    confirmNewPassFocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  OutlineInputBorder outlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF757575)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 17.v),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Reset password",
                        style: theme.textTheme.headlineLarge)),
                SizedBox(height: 9.v),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 291.h,
                        margin: EdgeInsets.only(right: 35.h),
                        child: Text(
                            "Please enter the verification code sent to your email address.",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.titleMediumBluegray200
                                .copyWith(height: 1.65)))),
                SizedBox(height: 32.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonInputField(
                        controllerField1, pin1FocusNode!, pin2FocusNode!),
                    const SizedBox(width: 5),
                    commonInputField(
                        controllerField2, pin2FocusNode!, pin3FocusNode!),
                    const SizedBox(width: 5),
                    commonInputField(
                        controllerField3, pin3FocusNode!, pin4FocusNode!),
                    const SizedBox(width: 5),
                    commonInputField(
                        controllerField4, pin4FocusNode!, pin5FocusNode!),
                    const SizedBox(width: 5),
                    commonInputField(
                        controllerField5, pin5FocusNode!, pin6FocusNode!),
                    const SizedBox(width: 5),
                    commonInputField(
                        controllerField6, pin6FocusNode!, pin6FocusNode!),
                  ],
                ),
                hasOtpFieldError
                    ? const SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              ' You need to fill this field first',
                              style: kErrorTextStyle,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: 20.v),
                _buildPassword(context, newPassController, newPassFocusNode!,
                    'Enter new password'),
                hasNewPassFieldError
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
                SizedBox(height: 20.v),
                _buildPassword(context, confirmNewPassController,
                    confirmNewPassFocusNode!, 'Confirm new password'),
                hasConfirmNewPassFieldError
                    ? const Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'New password and confirm new password didn\'t match',
                            style: kErrorTextStyle,
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: 24.v),
                CustomElevatedButton(
                  text: "Save",
                  navigationPath: '/main-screen',
                  context: context,
                  press: () => {
                    if (otpText.length != 6)
                      {
                        setState(() {
                          hasOtpFieldError = true;
                          hasNewPassFieldError = false;
                          hasConfirmNewPassFieldError = false;
                        })
                      }
                    else if (newPassController.text.isEmpty)
                      {
                        setState(() {
                          hasNewPassFieldError = true;
                          hasOtpFieldError = false;
                          hasConfirmNewPassFieldError = false;
                        })
                      }
                    else if (confirmNewPassController.text.isEmpty ||
                        newPassController.text != confirmNewPassController.text)
                      {
                        setState(() {
                          hasConfirmNewPassFieldError = true;
                          hasOtpFieldError = false;
                          hasNewPassFieldError = false;
                        })
                      }
                    else
                      {
                        setState(() {
                          hasOtpFieldError = false;
                          hasNewPassFieldError = false;
                          hasConfirmNewPassFieldError = false;
                        }),
                        apiCall(),
                      }
                  },
                ),
                const Spacer(),
              ],
            )),
      ),
    );
  }

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

  /// Section Widget
  Widget _buildPassword(
      BuildContext context,
      TextEditingController controllerName,
      FocusNode focusNode,
      String hintText) {
    return CustomTextFormField(
        controller: controllerName,
        focusNode: focusNode,
        hintText: hintText,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        obscureText: true,
        contentPadding: EdgeInsets.only(left: 17.h, top: 18.v, bottom: 18.v),
        borderDecoration: TextFormFieldStyleHelper.outlineIndigoTL8,
        fillColor: appTheme.gray10001);
  }

  onTapArrowLeft(BuildContext context) {
    if (EasyLoading.isShow) {
    } else {
      Navigator.pop(context);
    }
  }

  SizedBox commonInputField(TextEditingController controller,
      FocusNode currentNode, FocusNode nextNode) {
    bool focus = false;
    if (currentNode == pin1FocusNode!) {
      focus = true;
    }
    return SizedBox(
      width: (50 / 375.0) * MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: controller,
        focusNode: currentNode,
        autofocus: focus,
        style: const TextStyle(fontSize: 16),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: (5 / 375.0) * MediaQuery.of(context).size.width),
          border: outlineInputBorder(),
          focusedBorder: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
        ),
        onChanged: (value) {
          nextField(value, nextNode);
          if (currentNode == pin6FocusNode!) {
            pin6FocusNode!.unfocus();
          }

          if (controllerField1.text.isNotEmpty &&
              controllerField2.text.isNotEmpty &&
              controllerField3.text.isNotEmpty &&
              controllerField4.text.isNotEmpty &&
              controllerField5.text.isNotEmpty &&
              controllerField6.text.isNotEmpty) {
            otpText = controllerField1.text +
                controllerField2.text +
                controllerField3.text +
                controllerField4.text +
                controllerField5.text +
                controllerField6.text;
          } else {
            otpText = '';
          }
        },
      ),
    );
  }

  Future<void> apiCall() async {
    EasyLoading.show(status: 'loading...', dismissOnTap: false);

    ForgotPassRequest forgotPassRequest =
        ForgotPassRequest(newPassController.text.toString());

    try {
      var response = await dio.post(
        '${RestAPICall.baseURL}${RestAPICall.resetPinLinkEndPoint}/$otpText',
        data: jsonEncode(forgotPassRequest.toJsonToken()),
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
        EasyLoading.showSuccess(responseData['message']!);

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => SignInScreen()),
          (route) => false,
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
}
