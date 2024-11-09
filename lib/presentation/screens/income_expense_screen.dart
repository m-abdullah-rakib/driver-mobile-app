import 'dart:io';

import 'package:dio/dio.dart';
import 'package:driver_app/data/models/request/expense_request.dart';
import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../business_logic/cubits/date_time_cubit.dart';
import '../../business_logic/cubits/invoice_cubit.dart';
import '../../data/models/request/income_request.dart';
import '../../data/models/response/expense_response.dart';
import '../../data/models/response/income_response.dart';
import '../../data/models/response/upload_image_response.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/income_repository.dart';
import '../../data/repositories/upload_image_repository.dart';

class IncomeExpenseScreen extends StatefulWidget {
  const IncomeExpenseScreen({super.key});

  @override
  State<IncomeExpenseScreen> createState() => _IncomeExpenseScreenState();
}

class _IncomeExpenseScreenState extends State<IncomeExpenseScreen> {
  final _amountController = TextEditingController();
  final _tipsController = TextEditingController();
  final _remarkController = TextEditingController();
  final _volumeController = TextEditingController();
  final _reasonController = TextEditingController();
  final _fuelDetailsController = TextEditingController();

  final UploadImageRepository uploadImageRepository = UploadImageRepository();

  // late String imagePath;
  late UploadImageResponse uploadImageResponse;
  final IncomeRepository incomeRepository = IncomeRepository();
  final ExpenseRepository expenseRepository = ExpenseRepository();
  late IncomeResponse incomeResponse;
  late ExpenseResponse expenseResponse;
  late Position _currentPosition;
  num? latitude;
  num? longitude;
  int? _parkingDurationMin = 0;

  // int? _fuelVolume = 0;
  String? _fuelVendor = 'OWNED_FUEL_STATION_1';
  DateTime dateTime = DateTime.now();
  String formattedDateTime = '';
  String formattedDateTimeIsoString = '';

  @override
  void initState() {
    super.initState();
    getLocationPermission();

    formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    DateTime utcDateTime = dateTime.toUtc();
    formattedDateTimeIsoString = utcDateTime.toIso8601String();
    ImageConstant.invoiceImagePath = '';
  }

  Future<void> getLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      getCurrentLocation();
    } else {
      EasyLoading.showError('Permission is required!');
      getLocationPermission();
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;
      latitude = _currentPosition.latitude;
      longitude = _currentPosition.longitude;
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  ClipPath(
                    clipper: CurveClipper(),
                    child: BlocBuilder<IncomeExpenseCubit, IncomeExpenseState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: state.isExpense
                                ? kGradientRed
                                : kGradientPrimary,
                          ),
                          height: (MediaQuery.of(context).size.height) * 0.40,
                          padding: const EdgeInsets.only(
                            top: 85,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                    height: 30,
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Text(
                                    state.isExpense
                                        ? 'Add Expense'
                                        : 'Add Income',
                                    style: const TextStyle(
                                      color: kWhiteTextColor,
                                      fontFamily: 'Inter',
                                      fontSize: 18.0,
                                      // height: 21.78,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  // Align(
                                  //   child: SvgPicture.asset(
                                  //     'assets/images/group-19.svg',
                                  //     width: 26.00,
                                  //     height: 6.00,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    width: 26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      BlocBuilder<IncomeExpenseCategoryCubit,
                          IncomeExpenseCategoryState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: state.hasError
                                ? (MediaQuery.of(context).size.height) * 0.22 +
                                    state.fixErrorButtonPosition
                                : (MediaQuery.of(context).size.height) * 0.22 +
                                    state.fixButtonPosition,
                          );
                        },
                      ),
                      BlocBuilder<IncomeExpenseCubit, IncomeExpenseState>(
                        builder: (context, state) {
                          return BlocBuilder<IncomeExpenseCategoryCubit,
                              IncomeExpenseCategoryState>(
                            builder: (context, incomeExpenseCategoryState) {
                              return ElevatedButtonPrimary(
                                width: double.infinity,
                                onPressed: () {
                                  if (_amountController.text.isEmpty) {
                                    IncomeExpenseFormValidation.fieldValidation(
                                        state,
                                        incomeExpenseCategoryState,
                                        context,
                                        true);
                                    BlocProvider.of<FormFieldValidationCubit>(
                                            context)
                                        .setAmountFieldErrorStatus(true);
                                  } else if (state.isExpense &&
                                      incomeExpenseCategoryState.title ==
                                          'FUEL' &&
                                      _volumeController.text.isEmpty) {
                                    IncomeExpenseFormValidation.fieldValidation(
                                        state,
                                        incomeExpenseCategoryState,
                                        context,
                                        true);
                                    BlocProvider.of<FormFieldValidationCubit>(
                                            context)
                                        .setTipsFieldErrorStatus(true);
                                  } else {
                                    ///Pop-up form for confirmation
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                insetPadding:
                                                    const EdgeInsets.all(8.0),
                                                title: Center(
                                                  child: Text(
                                                    'Please Confirm',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                  ),
                                                ),
                                                content: Wrap(children: [
                                                  SizedBox(
                                                    height: 210,
                                                    width: double.infinity,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Car Model',
                                                              style:
                                                                  kDialogTitleTextStyle,
                                                            ),
                                                            Text(
                                                              'Tesla Model X',
                                                              style:
                                                                  kDialogValueTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Category',
                                                              style:
                                                                  kDialogTitleTextStyle,
                                                            ),
                                                            Text(
                                                              incomeExpenseCategoryState
                                                                  .title,
                                                              style:
                                                                  kDialogValueTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Amount',
                                                              style:
                                                                  kDialogTitleTextStyle,
                                                            ),
                                                            Text(
                                                              _amountController
                                                                  .text
                                                                  .toString(),
                                                              style:
                                                                  kDialogValueTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Time',
                                                              style:
                                                                  kDialogTitleTextStyle,
                                                            ),
                                                            Text(
                                                              formattedDateTime,
                                                              style:
                                                                  kDialogValueTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Cancel');
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          primary: Colors.black,
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Confirm');

                                                          /// API call will start now
                                                          EasyLoading.show(
                                                              status:
                                                                  'loading...');

                                                          if (state.isExpense) {
                                                            ExpenseRequest
                                                                expenseRequest =
                                                                ExpenseRequest(
                                                              incomeExpenseCategoryState
                                                                  .title,
                                                              formattedDateTimeIsoString,
                                                              num.parse(
                                                                  _amountController
                                                                      .text
                                                                      .toString()),
                                                              _reasonController
                                                                  .text
                                                                  .toString(),
                                                              _parkingDurationMin,
                                                              _fuelVendor,
                                                              0,
                                                              _fuelDetailsController
                                                                  .text
                                                                  .toString(),
                                                              null,
                                                              1,
                                                              latitude,
                                                              longitude,
                                                            );
                                                            createExpense(
                                                                expenseRequest);
                                                          } else {
                                                            IncomeRequest
                                                                incomeRequest =
                                                                IncomeRequest(
                                                              incomeExpenseCategoryState
                                                                  .title,
                                                              formattedDateTimeIsoString,
                                                              num.parse(
                                                                  _amountController
                                                                      .text
                                                                      .toString()),
                                                              _tipsController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? num.parse(
                                                                      _tipsController
                                                                          .text
                                                                          .toString())
                                                                  : 0,
                                                              _remarkController
                                                                  .text
                                                                  .toString(),
                                                              null,
                                                              null,
                                                              latitude,
                                                              longitude,
                                                            );
                                                            createIncome(
                                                                incomeRequest);
                                                          }

                                                          /// API call will end
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .white,
                                                                backgroundColor:
                                                                    kPrimaryColor),
                                                        child: const Text(
                                                            'Confirm'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });

                                    ///Pop-up form for confirmation end
                                  }
                                },
                                borderRadius: BorderRadius.circular(40),
                                gradient: state.isExpense
                                    ? kGradientRed
                                    : kGradientPrimary,
                                isExpense: state.isExpense,
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
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                child: SvgPicture.asset(
                  'assets/images/ellipse_7.svg',
                  width: 212.0,
                  height: 212.0,
                ),
              ),
              Positioned(
                left: 140,
                child: SvgPicture.asset(
                  'assets/images/ellipse_9.svg',
                  width: 85.0,
                  height: 85.0,
                ),
              ),
              Positioned(
                left: 70,
                child: SvgPicture.asset(
                  'assets/images/ellipse_8.svg',
                  width: 127.0,
                  height: 127.0,
                ),
              ),
              Positioned(
                left: 20,
                top: 95,
                child: GestureDetector(
                  onTap: () {
                    handleBackPressed();
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
              ),
              Positioned(
                top: (MediaQuery.of(context).size.height) * 0.22,
                child: BlocBuilder<IncomeExpenseCategoryCubit,
                    IncomeExpenseCategoryState>(
                  builder: (context, state) {
                    return Card(
                      surfaceTintColor: kWhiteTextColor,
                      elevation: 10.0,
                      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SizedBox(
                        height: state.hasError
                            ? state.setErrorCardSize
                            : state.setCardSize,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 30.0,
                            right: 20.0,
                            bottom: 30.0,
                          ),
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /// CATEGORY
                              const Text(
                                'CATEGORY', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    useSafeArea: true,
                                    // backgroundColor: kGradientPrimary,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BlocBuilder<IncomeExpenseCubit,
                                          IncomeExpenseState>(
                                        builder: (context, state) {
                                          return SizedBox(
                                            // height: state.isExpense ? 380 : 250,
                                            height: 380,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    'All Services',
                                                    style:
                                                        kFormFieldInputTextStyle,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 320,
                                                  // height: state.isExpense
                                                  //     ? 320
                                                  //     : 200,
                                                  child: BlocBuilder<
                                                      IncomeExpenseCubit,
                                                      IncomeExpenseState>(
                                                    builder: (context, state) {
                                                      return ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        itemCount: state
                                                                .isExpense
                                                            ? expenseCategoryList
                                                                .length
                                                            : incomeCategoryList
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return MenuItem(
                                                            text: state
                                                                    .isExpense
                                                                ? expenseCategoryList[
                                                                        index]
                                                                    ['text']
                                                                : incomeCategoryList[
                                                                        index]
                                                                    ['text'],
                                                            icon: state
                                                                    .isExpense
                                                                ? expenseCategoryList[
                                                                        index]
                                                                    ['icon']
                                                                : incomeCategoryList[
                                                                        index]
                                                                    ['icon'],
                                                            press: () => {
                                                              Navigator.pop(
                                                                  context),
                                                              _amountController
                                                                  .text = '',
                                                              removeImageInvoice(),
                                                              if (state
                                                                  .isExpense)
                                                                {
                                                                  BlocProvider.of<IncomeExpenseCategoryCubit>(context).setExpenseCategory(
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'icon'],
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'],
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'setCardSize'],
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'setErrorCardSize'],
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'fixButtonPosition'],
                                                                      expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'fixErrorButtonPosition'],
                                                                      false),
                                                                  if (expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'] ==
                                                                      'PENALTY')
                                                                    {
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setFirstDropdownTitle(
                                                                              'Over Speed 1'),
                                                                    }
                                                                  else if (expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'] ==
                                                                      'PARKING')
                                                                    {
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setFirstDropdownTitle(
                                                                              '1 hr'),
                                                                    }
                                                                  else if (expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'] ==
                                                                      'FUEL')
                                                                      {
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setFirstDropdownTitle(
                                                                              'Roma Carburante SRLS'),
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setSecondDropdownTitle(
                                                                              '1 Ltr'),
                                                                    }
                                                                  else if (expenseCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'] ==
                                                                      'OTHERS')
                                                                        {
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setFirstDropdownTitle(
                                                                              'Roma Carburante SRLS'),
                                                                      BlocProvider.of<FormDropdownCubit>(
                                                                              context)
                                                                          .setSecondDropdownTitle(
                                                                              '1 Ltr'),
                                                                    },
                                                                  removeErrorText(),
                                                                }
                                                              else
                                                                {
                                                                  BlocProvider.of<IncomeExpenseCategoryCubit>(context).setIncomeCategory(
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'icon'],
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'text'],
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'setCardSize'],
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'setErrorCardSize'],
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'fixButtonPosition'],
                                                                      incomeCategoryList[
                                                                              index]
                                                                          [
                                                                          'fixErrorButtonPosition'],
                                                                      false),
                                                                  removeErrorText(),
                                                                }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: kFormFieldBorder, // Border color
                                      width: 1, // Border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            RoundedIconPlaceholder(
                                                icon: state.icon),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              state.title,
                                              style: kFormFieldInputTextStyle,
                                            ),
                                          ],
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/icon_category_dd.svg',
                                          // width: 85.0,
                                          // height: 85.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// Vendor
                              state.title == 'FUEL'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Vendor', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              useSafeArea: true,
                                              // backgroundColor: kGradientPrimary,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: 240,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Text(
                                                          'All Services',
                                                          style:
                                                              kFormFieldInputTextStyle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 200,
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          itemCount:
                                                              vendorList.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return MenuItemForm(
                                                              text: vendorList[
                                                                      index]
                                                                  ['text'],
                                                              press: () => {
                                                                _fuelVendor =
                                                                    vendorListAPIData[
                                                                            index]
                                                                        [
                                                                        'text'],
                                                                Navigator.pop(
                                                                    context),
                                                                BlocProvider.of<
                                                                            FormDropdownCubit>(
                                                                        context)
                                                                    .setFirstDropdownTitle(
                                                                        vendorList[index]
                                                                            [
                                                                            'text']),
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color:
                                                    kFormFieldBorder, // Border color
                                                width: 1, // Border width
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BlocBuilder<FormDropdownCubit,
                                                      FormDropdownState>(
                                                    builder: (context, state) {
                                                      return Text(
                                                        state
                                                            .firstDropdownTitle,
                                                        style:
                                                            kFormFieldInputTextStyle,
                                                      );
                                                    },
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/icon_category_dd.svg',
                                                    // width: 85.0,
                                                    // height: 85.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// AMOUNT
                              const SizedBox(height: 20),
                              const Text(
                                'AMOUNT', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: BlocBuilder<FormFieldValidationCubit,
                                    FormFieldValidationState>(
                                  builder: (context, formFieldValidationState) {
                                    return BlocBuilder<IncomeExpenseCubit,
                                        IncomeExpenseState>(
                                      builder: (context, incomeExpenseState) {
                                        return Container(
                                          width: double.infinity,
                                          height: 93.79,
                                          padding: const EdgeInsets.only(
                                              left: 29, right: 15),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: incomeExpenseState
                                                        .isExpense
                                                    ? kGradientFour
                                                    : formFieldValidationState
                                                            .hasAmountFieldError
                                                        ? kGradientFour
                                                        : kPrimaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: formFieldValidationState
                                                    .hasAmountFieldError
                                                ? kAmountErrorBackground
                                                : Colors.transparent,
                                          ),
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .35,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15.0),
                                                      child: TextField(
                                                        controller:
                                                            _amountController,
                                                        textAlign:
                                                            TextAlign.center,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              width: formFieldValidationState
                                                                      .hasAmountFieldError
                                                                  ? 1
                                                                  : 2,
                                                              color: formFieldValidationState
                                                                      .hasAmountFieldError
                                                                  ? kGradientFour
                                                                  : kSecondaryTextColor,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 2,
                                                                color:
                                                                    kSecondaryTextColor),
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                          color:
                                                              kSecondaryTextColor,
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        onChanged: (input) {
                                                          if (input
                                                              .isNotEmpty) {
                                                            IncomeExpenseFormValidation
                                                                .fieldValidation(
                                                                    incomeExpenseState,
                                                                    state,
                                                                    context,
                                                                    false);
                                                            BlocProvider.of<
                                                                        FormFieldValidationCubit>(
                                                                    context)
                                                                .setAmountFieldErrorStatus(
                                                                    false);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _amountController.text = '';
                                                },
                                                child: SvgPicture.asset(
                                                  formFieldValidationState
                                                          .hasAmountFieldError
                                                      ? 'assets/icons/amount_error_icon.svg'
                                                      : 'assets/icons/clear_icon.svg',
                                                  // width: 85.0,
                                                  // height: 85.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              BlocBuilder<FormFieldValidationCubit,
                                  FormFieldValidationState>(
                                builder: (context, state) {
                                  return state.hasAmountFieldError
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
                                      : const SizedBox();
                                },
                              ),

                              /// REASON
                              (state.title == 'PENALTY' ||
                                      state.title == 'MAINTENANCE' ||
                                      state.title == 'OTHERS')
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(
                                          state.title == 'PENALTY'
                                              ? 'REASON'
                                              : 'REMARKS', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _reasonController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kFormFieldBorder),
                                            ),
                                            labelText: '',
                                            hintText: '',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                          ),
                                          onChanged: (value) {
                                            // Add any logic for text changes here
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// PARKING DURATION
                              state.title == 'PARKING'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20),
                                        const Text(
                                          'PARKING DURATION', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet<void>(
                                              useSafeArea: true,
                                              // backgroundColor: kGradientPrimary,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                  height: 350,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Text(
                                                          'All Services',
                                                          style:
                                                              kFormFieldInputTextStyle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 310,
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          itemCount:
                                                              penaltyReasonList
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return MenuItemForm(
                                                              text:
                                                                  parkingDurationList[
                                                                          index]
                                                                      ['text'],
                                                              press: () => {
                                                                Navigator.pop(
                                                                    context),
                                                                BlocProvider.of<
                                                                            FormDropdownCubit>(
                                                                        context)
                                                                    .setFirstDropdownTitle(
                                                                        parkingDurationList[index]
                                                                            [
                                                                            'text']),
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color:
                                                    kFormFieldBorder, // Border color
                                                width: 1, // Border width
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BlocBuilder<FormDropdownCubit,
                                                      FormDropdownState>(
                                                    builder: (context, state) {
                                                      _parkingDurationMin =
                                                          int.parse(state
                                                              .firstDropdownTitle
                                                              .substring(0, 1));

                                                      return Text(
                                                        state
                                                            .firstDropdownTitle,
                                                        style:
                                                            kFormFieldInputTextStyle,
                                                      );
                                                    },
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/icon_category_dd.svg',
                                                    // width: 85.0,
                                                    // height: 85.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// Volume
                              (state.title == 'FUEL')
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Volume (L)', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        BlocBuilder<IncomeExpenseCubit,
                                            IncomeExpenseState>(
                                          builder:
                                              (context, incomeExpenseState) {
                                            return TextFormField(
                                              controller: _volumeController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kFormFieldBorder),
                                                ),
                                                labelText: '',
                                                hintText: '',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                              ),
                                              onChanged: (input) {
                                                if (input.isNotEmpty) {
                                                  BlocProvider.of<
                                                              FormFieldValidationCubit>(
                                                          context)
                                                      .setTipsFieldErrorStatus(
                                                          false);
                                                  IncomeExpenseFormValidation
                                                      .fieldValidation(
                                                          incomeExpenseState,
                                                          state,
                                                          context,
                                                          false);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        BlocBuilder<FormFieldValidationCubit,
                                            FormFieldValidationState>(
                                          builder: (context, state) {
                                            return state.hasTipsFieldError
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
                                                : const SizedBox();
                                          },
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     showModalBottomSheet<void>(
                                        //       useSafeArea: true,
                                        //       // backgroundColor: kGradientPrimary,
                                        //       context: context,
                                        //       builder: (BuildContext context) {
                                        //         return SizedBox(
                                        //           height: 350,
                                        //           child: Column(
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .center,
                                        //             children: [
                                        //               const Padding(
                                        //                 padding: EdgeInsets.all(
                                        //                     10.0),
                                        //                 child: Text(
                                        //                   'All Services',
                                        //                   style:
                                        //                       kFormFieldInputTextStyle,
                                        //                 ),
                                        //               ),
                                        //               SizedBox(
                                        //                 height: 310,
                                        //                 child: ListView.builder(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                           .all(8),
                                        //                   itemCount:
                                        //                       volumeList.length,
                                        //                   itemBuilder:
                                        //                       (BuildContext
                                        //                               context,
                                        //                           int index) {
                                        //                     return MenuItemForm(
                                        //                       text: volumeList[
                                        //                               index]
                                        //                           ['text'],
                                        //                       press: () => {
                                        //                         Navigator.pop(
                                        //                             context),
                                        //                         BlocProvider.of<
                                        //                                     FormDropdownCubit>(
                                        //                                 context)
                                        //                             .setSecondDropdownTitle(
                                        //                                 volumeList[index]
                                        //                                     [
                                        //                                     'text']),
                                        //                       },
                                        //                     );
                                        //                   },
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         );
                                        //       },
                                        //     );
                                        //   },
                                        //   child: Container(
                                        //     width: MediaQuery.of(context)
                                        //             .size
                                        //             .width -
                                        //         60,
                                        //     height: 50,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //       border: Border.all(
                                        //         color:
                                        //             kFormFieldBorder, // Border color
                                        //         width: 1, // Border width
                                        //       ),
                                        //     ),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.only(
                                        //         left: 15,
                                        //         right: 15,
                                        //       ),
                                        //       child: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           BlocBuilder<FormDropdownCubit,
                                        //               FormDropdownState>(
                                        //             builder: (context, state) {
                                        //               _fuelVolume = int.parse(
                                        //                   state
                                        //                       .secondDropdownTitle
                                        //                       .substring(0, 1));
                                        //               return Text(
                                        //                 state
                                        //                     .secondDropdownTitle,
                                        //                 style:
                                        //                     kFormFieldInputTextStyle,
                                        //               );
                                        //             },
                                        //           ),
                                        //           SvgPicture.asset(
                                        //             'assets/icons/icon_category_dd.svg',
                                        //             // width: 85.0,
                                        //             // height: 85.0,
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// TIPS
                              (state.title == 'CASH' ||
                                      state.title == 'POS' ||
                                      state.title == 'UBER')
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text(
                                          'TIPS', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        BlocBuilder<IncomeExpenseCubit,
                                            IncomeExpenseState>(
                                          builder:
                                              (context, incomeExpenseState) {
                                            return TextFormField(
                                              controller: _tipsController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kFormFieldBorder),
                                                ),
                                                // Remove label text inside the input field
                                                labelText: '',
                                                // Add padding to input field
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                              ),
                                              onChanged: (input) {
                                                // if (input.isNotEmpty) {
                                                //   BlocProvider.of<
                                                //               FormFieldValidationCubit>(
                                                //           context)
                                                //       .setTipsFieldErrorStatus(
                                                //           false);
                                                //   IncomeExpenseFormValidation
                                                //       .fieldValidation(
                                                //           incomeExpenseState,
                                                //           state,
                                                //           context,
                                                //           false);
                                                // }
                                              },
                                            );
                                          },
                                        ),
                                        // BlocBuilder<FormFieldValidationCubit,
                                        //     FormFieldValidationState>(
                                        //   builder: (context, state) {
                                        //     return state.hasTipsFieldError
                                        //         ? const Column(
                                        //             children: [
                                        //               SizedBox(height: 10),
                                        //               Text(
                                        //                 'You need to fill this field first',
                                        //                 // Label text
                                        //                 style: kErrorTextStyle,
                                        //               ),
                                        //             ],
                                        //           )
                                        //         : const SizedBox();
                                        //   },
                                        // ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// Offer
                              // state.title == 'Uber'
                              //     ? Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           SizedBox(height: 20),
                              //           Text(
                              //             'Offer', // Label text
                              //             style: kFormFieldTextStyle,
                              //           ),
                              //           SizedBox(height: 10),
                              //           TextFormField(
                              //             // controller: _textEditingController,
                              //             decoration: InputDecoration(
                              //               border: OutlineInputBorder(),
                              //               focusedBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: kPrimaryColor),
                              //               ),
                              //               enabledBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: kFormFieldBorder),
                              //               ),
                              //               // Remove label text inside the input field
                              //               labelText: '',
                              //               // Add padding to input field
                              //               contentPadding:
                              //                   EdgeInsets.symmetric(
                              //                       vertical: 0,
                              //                       horizontal: 10),
                              //             ),
                              //             onChanged: (value) {
                              //               // Add any logic for text changes here
                              //             },
                              //             onTap: () {
                              //               // setState(() {
                              //               //   _isFocused = true;
                              //               // });
                              //             },
                              //             onEditingComplete: () {
                              //               // setState(() {
                              //               //   _isFocused = false;
                              //               // });
                              //             },
                              //             onFieldSubmitted: (value) {
                              //               // setState(() {
                              //               //   _isFocused = false;
                              //               // });
                              //             },
                              //           ),
                              //         ],
                              //       )
                              //     : const SizedBox(),

                              /// DATE & TIME
                              const SizedBox(height: 20),
                              const Text(
                                'DATE & TIME', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2018, 3, 5),
                                      maxTime: DateTime(2025, 6, 7),
                                      onChanged: (date) {
                                        formattedDateTime = date.toString();
                                    DateTime utcDateTime = date.toUtc();
                                    formattedDateTimeIsoString =
                                        utcDateTime.toIso8601String();
                                    BlocProvider.of<DateTimeCubit>(context)
                                        .changeDateState();
                                  }, onConfirm: (date) {
                                        formattedDateTime = date.toString();
                                    DateTime utcDateTime = date.toUtc();
                                    formattedDateTimeIsoString =
                                        utcDateTime.toIso8601String();
                                    BlocProvider.of<DateTimeCubit>(context)
                                        .changeDateState();
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: kFormFieldBorder, // Border color
                                      width: 1, // Border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BlocBuilder<DateTimeCubit,
                                            DateTimeState>(
                                          builder: (context, state) {
                                            return Text(formattedDateTime);
                                          },
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/icon_date.svg',
                                          // width: 85.0,
                                          // height: 85.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// LOCATION
                              // (state.title == 'Cash' ||
                              //         state.title == 'POS' ||
                              //         state.title == 'Uber')
                              //     ? Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           SizedBox(height: 20),
                              //           Text(
                              //             'LOCATION', // Label text
                              //             style: kFormFieldTextStyle,
                              //           ),
                              //           SizedBox(height: 10),
                              //           TextFormField(
                              //             // controller: _textEditingController,
                              //             decoration: InputDecoration(
                              //               border: OutlineInputBorder(),
                              //               focusedBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: kPrimaryColor),
                              //               ),
                              //               enabledBorder: OutlineInputBorder(
                              //                 borderSide: BorderSide(
                              //                     color: kFormFieldBorder),
                              //               ),
                              //               // Remove label text inside the input field
                              //               labelText: '',
                              //               // Add padding to input field
                              //               contentPadding:
                              //                   EdgeInsets.symmetric(
                              //                       vertical: 0,
                              //                       horizontal: 10),
                              //             ),
                              //             onChanged: (value) {
                              //               // Add any logic for text changes here
                              //             },
                              //             onTap: () {
                              //               // setState(() {
                              //               //   _isFocused = true;
                              //               // });
                              //             },
                              //             onEditingComplete: () {
                              //               // setState(() {
                              //               //   _isFocused = false;
                              //               // });
                              //             },
                              //             onFieldSubmitted: (value) {
                              //               // setState(() {
                              //               //   _isFocused = false;
                              //               // });
                              //             },
                              //           ),
                              //         ],
                              //       )
                              //     : const SizedBox(),

                              /// Remarks
                              (state.title == 'CASH' ||
                                      state.title == 'POS' ||
                                      state.title == 'UBER' ||
                                      state.title == 'PROMOTION' ||
                                      state.title == 'BUONO')
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text(
                                          (state.title == 'PROMOTION' ||
                                                  state.title == 'BUONO')
                                              ? 'Note'
                                              : 'Remarks', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _remarkController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kFormFieldBorder),
                                            ),
                                            labelText: '',
                                            hintText: '',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                          ),
                                          onChanged: (value) {
                                            // Add any logic for text changes here
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// Details
                              state.title == 'FUEL'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Details', // Label text
                                          style: kFormFieldTextStyle,
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: _fuelDetailsController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kFormFieldBorder),
                                            ),
                                            labelText: '',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                          ),
                                          onChanged: (value) {},
                                          onTap: () {},
                                          onEditingComplete: () {},
                                          onFieldSubmitted: (value) {},
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),

                              /// INVOICE
                              const SizedBox(height: 20),
                              const Text(
                                'INVOICE', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                height: 50,
                                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                                  builder: (context, state) {
                                    return CustomPaint(
                                      painter: DottedBorderPainter(),
                                      child: state.setImage
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return AlertDialog(
                                                                  insetPadding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  title: Center(
                                                                    child: Text(
                                                                      'Invoice',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey[800]),
                                                                    ),
                                                                  ),
                                                                  content: Image
                                                                      .file(
                                                                    File(ImageConstant
                                                                        .invoiceImagePath),
                                                                  ),
                                                                  actions: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        OutlinedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context,
                                                                                'Change');
                                                                            imagePickerOption();
                                                                          },
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            primary:
                                                                                Colors.black,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                          ),
                                                                          child:
                                                                              const Text('Change'),
                                                                        ),
                                                                        OutlinedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context,
                                                                                'Confirm');
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              primary: Colors.white,
                                                                              backgroundColor: kPrimaryColor),
                                                                          child:
                                                                              const Text('Confirm'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          });
                                                    },
                                                    child: Image.file(File(
                                                        ImageConstant
                                                            .invoiceImagePath)),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      imagePickerOption();
                                                    },
                                                    child: const Text(
                                                      'Change Now!',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontFamily: 'Inter',
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                getCameraPermission();
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/plus-circle.svg',
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      'Add Invoice',
                                                      style:
                                                          kFormFieldInputTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createIncome(IncomeRequest incomeRequest) async {
    if (ImageConstant.invoiceImagePath != '') {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(ImageConstant.invoiceImagePath,
            filename: 'image.jpg'),
      });
      uploadImageResponse = await uploadImageRepository.uploadImage(formData);
      ImageConstant.invoiceImagePath = '';
      incomeRequest.invoiceFilePath = uploadImageResponse.data;
    }

    var incomeAPIResponse = incomeRepository.createIncome(incomeRequest);
    incomeAPIResponse.then((value) async {
      incomeResponse = value;
      _amountController.text = '';
      _tipsController.text = '';
      _remarkController.text = '';
      removeImageInvoice();

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Congratulations! Successfully created.');
    }, onError: (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Sorry! Something went wrong.');
    });
  }

  void createExpense(ExpenseRequest expenseRequest) async {
    if (ImageConstant.invoiceImagePath != '') {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(ImageConstant.invoiceImagePath,
            filename: 'image.jpg'),
      });
      uploadImageResponse = await uploadImageRepository.uploadImage(formData);
      ImageConstant.invoiceImagePath = '';
      expenseRequest.invoiceFilePath = uploadImageResponse.data;
    }

    if (expenseRequest.type != 'FUEL') {
      expenseRequest.fuelVendor = null;
      expenseRequest.fuelVolume = 0;
    } else {
      expenseRequest.fuelVolume = int.parse(_volumeController.text);
    }

    var expenseAPIResponse = expenseRepository.createExpense(expenseRequest);
    expenseAPIResponse.then((value) async {
      expenseResponse = value;
      _amountController.text = '';
      _volumeController.text = '';
      _tipsController.text = '';
      _remarkController.text = '';
      _fuelDetailsController.text = '';
      removeImageInvoice();

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Congratulations! Successfully created.');
    }, onError: (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError('Sorry! Something went wrong.');
    });
  }

  void imagePickerOption() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Select an option',
                  style: kFormFieldInputTextStyle,
                ),
              ),
              SizedBox(
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/take-picture-screen',
                        );
                      },
                      child: const PromptItem(
                        gradient: kGradientInvoicePrompt,
                        icon: 'assets/icons/camera_icon.svg',
                        title: 'Camera',
                        titleFontSize: 16.0,
                        containerHeight: 100,
                        containerWeight: 120,
                        iconHeight: 40,
                        iconWeight: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);

                        ImagePicker picker = ImagePicker();
                        WidgetsFlutterBinding.ensureInitialized();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          ImageConstant.invoiceImagePath = pickedFile!.path;
                          setImageInvoice();
                        }
                      },
                      child: const PromptItem(
                        gradient: kGradientInvoicePrompt,
                        icon: 'assets/icons/gallery_icon.svg',
                        title: 'Gallery',
                        titleFontSize: 16.0,
                        containerHeight: 100,
                        containerWeight: 120,
                        iconHeight: 40,
                        iconWeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void setImageInvoice() {
    BlocProvider.of<InvoiceCubit>(context).setImage();
  }

  void removeErrorText() {
    BlocProvider.of<FormFieldValidationCubit>(context)
        .setAmountFieldErrorStatus(false);
    // BlocProvider.of<FormFieldValidationCubit>(context)
    //     .setTipsFieldErrorStatus(false);
  }

  void removeImageInvoice() {
    ImageConstant.invoiceImagePath = '';
    BlocProvider.of<InvoiceCubit>(context).removeImage();
  }

  void handleBackPressed() {
    BlocProvider.of<FabCubit>(context).showFab();
    removeImageInvoice();
    removeErrorText();
    Navigator.of(context).pop();
  }

  Future<void> getCameraPermission() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
      imagePickerOption();
    } else {
      EasyLoading.showError('Permission is required!');
    }
  }
}
