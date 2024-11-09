import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController userNameController = TextEditingController();

  TextEditingController enterController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
            key: _formKey,
            child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.v),
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 297.h,
                          margin: EdgeInsets.only(right: 29.h),
                          child: Text("Hello, it's here. Sign up to get going.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineLarge!
                                  .copyWith(height: 1.25)))),
                  SizedBox(height: 29.v),
                  _buildUserName(context),
                  SizedBox(height: 16.v),
                  _buildEnter(context),
                  SizedBox(height: 16.v),
                  _buildPassword(context),
                  SizedBox(height: 16.v),
                  _buildConfirmPassword(context),
                  SizedBox(height: 18.v),
                  _buildFrame(context),
                  SizedBox(height: 24.v),
                  _buildSignIn(context),
                  SizedBox(height: 19.v),
                  _buildFrame1(context),
                  SizedBox(height: 19.v),
                  _buildFrame2(context),
                  SizedBox(height: 23.v),
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
                              text: "Already have an account?",
                              style: CustomTextStyles.titleMediumOnPrimary_1),
                          TextSpan(text: " "),
                          TextSpan(
                              text: "Sign In",
                              style: CustomTextStyles.titleMediumPrimary)
                        ]),
                        textAlign: TextAlign.left),
                  ),
                  // SizedBox(height: 9.v)
                ]))));
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

  /// Section Widget
  Widget _buildUserName(BuildContext context) {
    return CustomTextFormField(
        controller: userNameController,
        hintText: "Username",
        contentPadding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 18.v));
  }

  /// Section Widget
  Widget _buildEnter(BuildContext context) {
    return CustomTextFormField(controller: enterController, hintText: "Enter");
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController,
        hintText: "Password",
        textInputType: TextInputType.visiblePassword,
        obscureText: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 18.v));
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return CustomTextFormField(
        controller: confirmPasswordController,
        hintText: "Confirm password",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        obscureText: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 18.v));
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CustomCheckboxButton(
          text: "Remember me",
          value: rememberMe,
          padding: EdgeInsets.symmetric(vertical: 3.v),
          onChange: (value) {
            rememberMe = value;
          }),
      Padding(
          padding: EdgeInsets.only(top: 5.v),
          child: Text("Forgot Password?",
              style: CustomTextStyles.titleSmallBluegray500))
    ]);
  }

  /// Section Widget
  Widget _buildSignIn(BuildContext context) {
    return CustomElevatedButton(
      text: "Sign In",
      navigationPath: '/sign-in-screen',
      context: context,
      press: () => {
        Navigator.pushNamed(
          context,
          '/main-screen',
        )
      },
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
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
  Widget _buildGoogle(BuildContext context) {
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
  Widget _buildApple(BuildContext context) {
    return CustomOutlinedButton(
        width: 155.h,
        text: "Apple",
        leftIcon: Container(
            margin: EdgeInsets.only(right: 17.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgApple, height: 16.v, width: 13.h)));
  }

  /// Section Widget
  Widget _buildFrame2(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildGoogle(context), _buildApple(context)]);
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
