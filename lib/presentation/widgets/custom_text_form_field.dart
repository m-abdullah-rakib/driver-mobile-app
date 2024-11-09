import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/obscure_text_cubit.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
        width: widget.width ?? double.maxFinite,
        child: BlocBuilder<ObscureTextCubit, ObscureTextState>(
          builder: (context, state) {
            return TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode ?? FocusNode(),
              autofocus: widget.autofocus!,
              style: widget.textStyle ?? theme.textTheme.titleMedium,
              obscureText:
                  widget.obscureText! == true ? state.toggleState : false,
              textInputAction: widget.textInputAction,
              keyboardType: widget.textInputType,
              maxLines: widget.maxLines ?? 1,
              decoration: decoration,
              validator: widget.validator,
            );
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: widget.hintText ?? "",
        hintStyle: widget.hintStyle ?? theme.textTheme.titleMedium,
        prefixIcon: widget.prefix,
        prefixIconConstraints: widget.prefixConstraints,
        suffixIcon: widget.suffix,
        suffixIconConstraints: widget.suffixConstraints,
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 18.v,
            ),
        fillColor: widget.fillColor ?? appTheme.gray50,
        filled: widget.filled,
        border: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.indigo50,
                width: 1,
              ),
            ),
        enabledBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.indigo50,
                width: 1,
              ),
            ),
        focusedBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: appTheme.indigo50,
                width: 1,
              ),
            ),
      );
}

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outlineIndigoTL8 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.h),
        borderSide: BorderSide(
          color: appTheme.indigo50,
          width: 1,
        ),
      );
}
