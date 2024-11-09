import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driver_app/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';

import '../../business_logic/cubits/fab_cubit.dart';
import '../../data/constants/rest_api_call.dart';
import '../../data/models/request/login_and_security_request.dart';
import '../../utilities/storage_data_provider.dart';
import '../widgets/elevated_button_primary.dart';

class LoginAndSecurityScreen extends StatefulWidget {
  const LoginAndSecurityScreen({super.key});

  @override
  State<LoginAndSecurityScreen> createState() => _LoginAndSecurityScreenState();
}

class _LoginAndSecurityScreenState extends State<LoginAndSecurityScreen> {
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmNewPassController = TextEditingController();
  bool hasCurrentPassFieldError = false;
  bool hasNewPassFieldError = false;
  bool hasConfirmNewPassFieldError = false;

  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        BlocProvider.of<FabCubit>(context).showFab();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 85,
                  bottom: 20,
                ),
                color: kPrimaryColor,
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<FabCubit>(context).showFab();
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: 30,
                          height: 30,
                          child: Align(
                            child: SvgPicture.asset(
                              'assets/images/back-icon.svg',
                              width: 8.4,
                              height: 14.0,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 30.0),
                          child: Center(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                surfaceTintColor: kWhiteTextColor,
                elevation: 5.0,
                margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 30.0,
                    right: 20.0,
                    bottom: 50.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'CURRENT PASSWORD', // Label text
                            style: kFormFieldTextStyle,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: currentPassController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kFormFieldBorder),
                              ),
                              labelText: '',
                              hintText: '',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                            ),
                            onChanged: (value) {
                              // Add any logic for text changes here
                            },
                            obscureText: true,
                          ),
                        ],
                      ),
                      hasCurrentPassFieldError
                          ? const Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'You need to fill this field first',
                                  // Label text
                                  style: kErrorTextStyle,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'NEW PASSWORD', // Label text
                            style: kFormFieldTextStyle,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: newPassController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kFormFieldBorder),
                              ),
                              labelText: '',
                              hintText: '',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                            ),
                            onChanged: (value) {
                              // Add any logic for text changes here
                            },
                            obscureText: true,
                          ),
                        ],
                      ),
                      hasNewPassFieldError
                          ? const Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'You need to fill this field first',
                                  // Label text
                                  style: kErrorTextStyle,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'CONFIRM NEW PASSWORD', // Label text
                            style: kFormFieldTextStyle,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmNewPassController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kFormFieldBorder),
                              ),
                              labelText: '',
                              hintText: '',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                            ),
                            onChanged: (value) {
                              // Add any logic for text changes here
                            },
                            obscureText: true,
                          ),
                        ],
                      ),
                      hasConfirmNewPassFieldError
                          ? const Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'New password and confirm new password didn\'t match',
                                  // Label text
                                  style: kErrorTextStyle,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButtonPrimary(
                width: double.infinity,
                onPressed: () async {
                  if (currentPassController.text.isEmpty) {
                    setState(() {
                      hasCurrentPassFieldError = true;
                      hasNewPassFieldError = false;
                      hasConfirmNewPassFieldError = false;
                    });
                  } else if (newPassController.text.isEmpty) {
                    setState(() {
                      hasCurrentPassFieldError = false;
                      hasNewPassFieldError = true;
                      hasConfirmNewPassFieldError = false;
                    });
                  } else if (confirmNewPassController.text.isEmpty ||
                      newPassController.text != confirmNewPassController.text) {
                    setState(() {
                      hasCurrentPassFieldError = false;
                      hasNewPassFieldError = false;
                      hasConfirmNewPassFieldError = true;
                    });
                  } else {
                    setState(() {
                      hasCurrentPassFieldError = false;
                      hasNewPassFieldError = false;
                      hasConfirmNewPassFieldError = false;
                    });

                    EasyLoading.show(status: 'loading...');

                    LoginAndSecurityRequest loginAndSecurityRequest =
                        LoginAndSecurityRequest(
                            currentPassController.text, newPassController.text);
                    try {
                      var response = await dio.patch(
                        RestAPICall.baseURL + RestAPICall.changePassEndPoint,
                        data: jsonEncode(loginAndSecurityRequest.toJson()),
                        options: Options(
                          headers: await tokenProvider.retrieveHeader(),
                          validateStatus: (status) {
                            return status == null ||
                                (status >= 200 && status < 300) ||
                                status == 400;
                          },
                        ),
                      );

                      if (response.statusCode == 200) {
                        Map<String, dynamic> responseData =
                            json.decode(response.toString());
                        currentPassController.text = '';
                        newPassController.text = '';
                        confirmNewPassController.text = '';
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess(responseData['message']!);
                      } else if ((response.statusCode == 400)) {
                        Map<String, dynamic> responseData =
                            json.decode(response.toString());
                        EasyLoading.dismiss();
                        EasyLoading.showError(
                            responseData['errors']![0]['msg']);
                      }
                    } catch (e) {
                      EasyLoading.dismiss();
                      EasyLoading.showError('Sorry! Something went wrong.');
                    }
                  }
                },
                borderRadius: BorderRadius.circular(40),
                gradient: kGradientPrimary,
                isExpense: false,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: kWhiteTextColor,
                    fontFamily: 'Inter',
                    fontSize: 18.0,
                    // height: 21.78,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
