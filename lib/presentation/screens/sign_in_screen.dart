import 'package:dio/dio.dart';
import 'package:driver_app/data/models/request/login_request.dart';
import 'package:driver_app/data/repositories/login_repository.dart';
import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/cubits/login_form_validation_cubit.dart';
import '../../business_logic/cubits/obscure_text_cubit.dart';
import '../../data/models/response/login_response.dart';
import '../pages/home_page.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final dio = Dio();

  late SharedPreferences sharedPreferences;
  final LoginRepository loginRepository = LoginRepository();
  late LoginResponse loginResponse;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainScreenViewCubit>(context)
        .setCurrentPage(const HomePage());
    initInstance();
  }

  Future<void> initInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.h, vertical: 12.v),
                      child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                width: 308.h,
                                margin: EdgeInsets.only(right: 18.h),
                                child: Text(
                                    "Welcome back again,\nit's good to see you!",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headlineLarge!
                                        .copyWith(height: 1.25)))),
                        SizedBox(height: 100.v),
                        _buildEmail(context),
                        BlocBuilder<LoginFormValidationCubit,
                            LoginFormValidationState>(
                          builder: (context, state) {
                            return state.hasEmailFieldError
                                ? const SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          ' You need to fill this field.',
                                          // Label text
                                          style: kErrorTextStyle,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ),
                        SizedBox(height: 16.v),
                        _buildPassword(context),
                        BlocBuilder<LoginFormValidationCubit,
                            LoginFormValidationState>(
                          builder: (context, state) {
                            return state.hasPasswordFieldError
                                ? const SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          ' You need to fill this field.',
                                          // Label text
                                          style: kErrorTextStyle,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ),
                        SizedBox(height: 18.v),
                        _buildFrameRow(context),
                        SizedBox(height: 24.v),
                        _buildSignInButton(context),
                        SizedBox(height: 70.v),
                        // _buildFrameRow2(context),
                        // SizedBox(height: 19.v),
                        // _buildFrame(context),
                        // Spacer(),
                        // SizedBox(height: 9.v),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pushNamed(
                        //       context,
                        //       '/sign-up-screen',
                        //     );
                        //   },
                        //   child: RichText(
                        //       text: TextSpan(children: [
                        //         TextSpan(
                        //             text: "Don’t have an account?",
                        //             style: CustomTextStyles.titleMediumOnPrimary_1),
                        //         TextSpan(text: " "),
                        //         TextSpan(
                        //             text: "Sign Up",
                        //             style: CustomTextStyles.titleMediumPrimary)
                        //       ]),
                        //       textAlign: TextAlign.left),
                        // )
                      ]))),
            ],
          )),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const CustomAppBar();
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
        controller: emailController,
        hintText: "Enter your email",
        textInputType: TextInputType.emailAddress,
        contentPadding: EdgeInsets.only(left: 17.h, top: 18.v, bottom: 18.v),
        borderDecoration: TextFormFieldStyleHelper.outlineIndigoTL8,
        fillColor: appTheme.gray10001);
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController,
        hintText: "Enter your password",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        suffix: Container(
            margin: EdgeInsets.fromLTRB(12.h, 17.v, 15.h, 17.v),
            child: BlocBuilder<ObscureTextCubit, ObscureTextState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<ObscureTextCubit>(context)
                        .toggleObscureTextState(!state.toggleState);
                  },
                  child: CustomImageView(
                      imagePath: ImageConstant.imgFluenteye20filled,
                      height: 22.v,
                      width: 21.h),
                );
              },
            )),
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        obscureText: true,
        contentPadding: EdgeInsets.only(left: 17.h, top: 18.v, bottom: 18.v),
        borderDecoration: TextFormFieldStyleHelper.outlineIndigoTL8,
        fillColor: appTheme.gray10001);
  }

  /// Section Widget
  Widget _buildFrameRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
        onTap: () {
          if (EasyLoading.isShow) {
          } else {
            BlocProvider.of<ObscureTextCubit>(context)
                .toggleObscureTextState(true);
            Navigator.pushNamed(
              context,
              '/forgot-password-screen',
            );
          }
        },
        child: Padding(
            padding: EdgeInsets.only(top: 5.v),
            child: Text("Forgot Password?",
                style: CustomTextStyles.titleSmallBluegray500)),
      )
    ]);
  }

  /// Section Widget
  Widget _buildSignInButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Sign In",
      navigationPath: '/main-screen',
      context: context,
      press: () async {
        /// Form field validation start
        if (emailController.text.isEmpty) {
          BlocProvider.of<LoginFormValidationCubit>(context)
              .setEmailFieldErrorStatus(true);
        } else {
          BlocProvider.of<LoginFormValidationCubit>(context)
              .setEmailFieldErrorStatus(false);
        }

        if (passwordController.text.isEmpty) {
          BlocProvider.of<LoginFormValidationCubit>(context)
              .setPasswordFieldErrorStatus(true);
        } else {
          BlocProvider.of<LoginFormValidationCubit>(context)
              .setPasswordFieldErrorStatus(false);
        }

        /// Form field validation end

        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          EasyLoading.show(status: 'loading...');

          LoginRequest loginRequest = LoginRequest(
              emailController.text.toString(),
              passwordController.text.toString());

          var loginAPIResponse = loginRepository.driverLogin(loginRequest);
          loginAPIResponse.then((value) {
            if (value is LoginResponse) {
              loginResponse = value;
              sharedPreferences.setString(
                  'authToken', loginResponse.data!.token);

              sharedPreferences.setString('userLoggedIn', 'USER_LOGGED_IN');

              EasyLoading.dismiss();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main-screen',
                ModalRoute.withName('/'),
              );
            } else if (value.statusCode == 401) {
              EasyLoading.dismiss();
              EasyLoading.showError('Invalid Credentials.');
            } else {
              EasyLoading.dismiss();
              EasyLoading.showError('Sorry! Something went wrong.');
            }
          }, onError: (e) {
            EasyLoading.dismiss();
            EasyLoading.showError('Sorry! Something went wrong.');
          });
        }
      },
    );
  }

  /// Section Widget
  Widget _buildFrameRow2(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 7.v, bottom: 8.v),
              child: SizedBox(width: 148.h, child: Divider())),
          Text("Or", style: CustomTextStyles.titleSmallBluegray200),
          Padding(
              padding: EdgeInsets.only(top: 7.v, bottom: 8.v),
              child: SizedBox(width: 146.h, child: Divider()))
        ]);
  }

  /// Section Widget
  Widget _buildGoogleButton(BuildContext context) {
    return CustomOutlinedButton(
        width: 156.h,
        text: "Google",
        leftIcon: Container(
            margin: EdgeInsets.only(right: 8.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgFlatcoloriconsgoogle,
                height: 16.adaptSize,
                width: 16.adaptSize)));
  }

  /// Section Widget
  Widget _buildAppleButton(BuildContext context) {
    return CustomOutlinedButton(
        width: 155.h,
        text: "Apple",
        leftIcon: Container(
            margin: EdgeInsets.only(right: 17.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgApple, height: 16.v, width: 13.h)));
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildGoogleButton(context), _buildAppleButton(context)]);
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
