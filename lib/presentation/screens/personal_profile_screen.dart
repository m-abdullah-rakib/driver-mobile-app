import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:driver_app/data/constants/rest_api_call.dart';
import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../business_logic/cubits/date_time_cubit.dart';
import '../../business_logic/cubits/invoice_cubit.dart';
import '../../data/models/request/profile_update_request.dart';
import '../../data/models/response/upload_image_response.dart';
import '../../data/repositories/upload_image_repository.dart';
import '../../utilities/storage_data_provider.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final drivingLicenceNumberController = TextEditingController();
  final kbNumberController = TextEditingController();
  String dateOfBirth = '';
  String dateOfBirthIsoString = '';
  String kbExpiryDate = '';
  String kbExpiryDateIsoString = '';
  String profileImage = '';
  String driverLicenceImage = '';
  String rouloImage = '';
  String professionalDriverLicenceImage = '';
  bool hasEmailFieldError = false;
  bool hasPassFieldError = false;
  bool hasNameFieldError = false;
  bool hasPhoneFieldError = false;
  bool hasRevenuePercentageFieldError = false;
  bool hasDrivingLicenceNumberFieldError = false;
  bool hasKbNumberFieldError = false;
  String profilePicImagePath = '';
  String driverLicenceImagePath = '';
  String rouloFileImagePath = '';
  String professionalDriverLicenceImagePath = '';

  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  final UploadImageRepository uploadImageRepository = UploadImageRepository();
  late UploadImageResponse uploadImageResponse;

  String token = '';
  int i = 0;

  @override
  void initState() {
    super.initState();

    getToken();
  }

  getToken() async {
    token = await tokenProvider.retrieveToken();
  }

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      GetAuthenticatedUserCubit getAuthenticatedUserCubit =
          BlocProvider.of<GetAuthenticatedUserCubit>(context);
      GetAuthenticatedUserState getAuthenticatedUserState =
          getAuthenticatedUserCubit.state;

      if (getAuthenticatedUserState.getAuthenticatedUserResponse?.data!.email !=
          null) {
        emailController.text = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.email!;
      }
      if (getAuthenticatedUserState.getAuthenticatedUserResponse?.data!.name !=
          null) {
        nameController.text =
            getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.name!;
      }
      if (getAuthenticatedUserState.getAuthenticatedUserResponse?.data!.phone !=
          null) {
        phoneController.text = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.phone!;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.dateOfBirth !=
          null) {
        dateOfBirthIsoString = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.dateOfBirth;
        DateTime iosDate = DateTime.parse(getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.dateOfBirth);
        dateOfBirth = DateFormat('yyyy-MM-dd HH:mm:ss').format(iosDate);
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.kbNumber !=
          null) {
        kbNumberController.text = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.kbNumber!;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.drivingLicenceNumber !=
          null) {
        drivingLicenceNumberController.text = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.drivingLicenceNumber!;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.kbExpiryDate !=
          null) {
        kbExpiryDateIsoString = getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.kbExpiryDate!;
        DateTime iosDate = DateTime.parse(getAuthenticatedUserState
            .getAuthenticatedUserResponse!.data!.kbExpiryDate!);
        kbExpiryDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(iosDate);
      }
      if (getAuthenticatedUserState.getAuthenticatedUserResponse?.data!.image !=
          null) {
        profileImage =
            '${RestAPICall.getImage}${getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.image}';
        // profilePicImagePath = getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.image;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.driverLicense !=
          null) {
        driverLicenceImage =
            '${RestAPICall.getImage}${getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.driverLicense}';
        // driverLicenceImagePath = getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.driverLicense;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.rouloFilePath !=
          null) {
        rouloImage =
            '${RestAPICall.getImage}${getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.rouloFilePath}';
        // rouloFileImagePath = getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.rouloFilePath!;
      }
      if (getAuthenticatedUserState
              .getAuthenticatedUserResponse?.data!.professionalDriverLicense !=
          null) {
        professionalDriverLicenceImage =
            '${RestAPICall.getImage}${getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.professionalDriverLicense}';
        // professionalDriverLicenceImagePath = getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.professionalDriverLicense!;
      }

      i++;
    }

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
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: kGradientPrimary,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 40,
                                height: 40,
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              const Text(
                                'Profile',
                                style: TextStyle(
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
                              Container(
                                decoration: kRectangularCurvedStyle,
                                height: 40,
                                width: 40,
                                child: Align(
                                  child: SvgPicture.asset(
                                    'assets/images/bell_1.svg',
                                    width: 23.33,
                                    height: 23.33,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Card(
                        surfaceTintColor: kWhiteTextColor,
                        elevation: 5.0,
                        margin:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 10.0,
                            right: 20.0,
                            bottom: 30.0,
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
                                    'Email', // Label text
                                    style: kFormFieldTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kFormFieldBorder),
                                      ),
                                      labelText: '',
                                      hintText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      // Add any logic for text changes here
                                    },
                                  ),
                                ],
                              ),
                              hasEmailFieldError
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
                                    'NAME', // Label text
                                    style: kFormFieldTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kFormFieldBorder),
                                      ),
                                      labelText: '',
                                      hintText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      // Add any logic for text changes here
                                    },
                                  ),
                                ],
                              ),
                              hasNameFieldError
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
                                    'PHONE', // Label text
                                    style: kFormFieldTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kFormFieldBorder),
                                      ),
                                      labelText: '',
                                      hintText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      // Add any logic for text changes here
                                    },
                                  ),
                                ],
                              ),
                              hasPhoneFieldError
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

                              /// Date
                              const SizedBox(height: 20),
                              const Text(
                                'DATE OF BIRTH', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    dateOfBirth = picked.toString();
                                    DateTime utcDateTime = picked.toUtc();
                                    dateOfBirthIsoString =
                                        utcDateTime.toIso8601String();
                                    BlocProvider.of<DateTimeCubit>(context)
                                        .changeDateState();
                                  }
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
                                            return Text(dateOfBirth);
                                          },
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/icon_date.svg',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'DRIVER LICENCE', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  if (await Permission.camera
                                          .request()
                                          .isGranted &&
                                      await Permission.storage
                                          .request()
                                          .isGranted) {
                                    imagePickerOption('driverLicenceImagePath');
                                  } else {
                                    EasyLoading.showError(
                                        'Permission is required!');
                                  }
                                },
                                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                                  builder: (context, state) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: kFormFieldBorder,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      height: 183,
                                      width: double.infinity,
                                      child: state.setImage &&
                                              ImageConstant
                                                      .driverLicenceImagePathSet ==
                                                  true
                                          ? Image.file(File(ImageConstant
                                              .driverLicenceImagePath))
                                          : Image.network(
                                              driverLicenceImage,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                      'Error loading image'),
                                                ); // Display an error message if the image fails to load
                                              },
                                            ),
                                    );
                                  },
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'DRIVER LICENCE NUMBER', // Label text
                                    style: kFormFieldTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: drivingLicenceNumberController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kFormFieldBorder),
                                      ),
                                      labelText: '',
                                      hintText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      // Add any logic for text changes here
                                    },
                                  ),
                                ],
                              ),
                              hasDrivingLicenceNumberFieldError
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
                              const SizedBox(height: 20),
                              const Text(
                                'ROULO FILE PATH', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  if (await Permission.camera
                                          .request()
                                          .isGranted &&
                                      await Permission.storage
                                          .request()
                                          .isGranted) {
                                    imagePickerOption('rouloFileImagePath');
                                  } else {
                                    EasyLoading.showError(
                                        'Permission is required!');
                                  }
                                },
                                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                                  builder: (context, state) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: kFormFieldBorder,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      height: 183,
                                      width: double.infinity,
                                      child: state.setImage &&
                                              ImageConstant
                                                      .rouloFileImagePathSet ==
                                                  true
                                          ? Image.file(File(
                                              ImageConstant.rouloFileImagePath))
                                          : rouloImage != ''
                                              ? Image.network(
                                                  rouloImage,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return const Center(
                                                      child: Text(
                                                          'Error loading image'),
                                                    ); // Display an error message if the image fails to load
                                                  },
                                                )
                                              : const SizedBox(
                                                  child: Center(
                                                    child: Text(
                                                        'No image to show.'),
                                                  ),
                                                ),
                                    );
                                  },
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'KB NUMBER', // Label text
                                    style: kFormFieldTextStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: kbNumberController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kFormFieldBorder),
                                      ),
                                      labelText: '',
                                      hintText: '',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      // Add any logic for text changes here
                                    },
                                  ),
                                ],
                              ),
                              hasKbNumberFieldError
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

                              /// Date KB
                              const SizedBox(height: 20),
                              const Text(
                                'KB EXPIRY DATE', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null) {
                                    kbExpiryDate = picked.toString();
                                    DateTime utcDateTime = picked.toUtc();
                                    kbExpiryDateIsoString =
                                        utcDateTime.toIso8601String();
                                    BlocProvider.of<DateTimeCubit>(context)
                                        .changeDateState();
                                  }
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
                                            return Text(kbExpiryDate);
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
                              const SizedBox(height: 20),
                              const Text(
                                'PROFESSIONAL DRIVER LICENCE', // Label text
                                style: kFormFieldTextStyle,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  if (await Permission.camera
                                          .request()
                                          .isGranted &&
                                      await Permission.storage
                                          .request()
                                          .isGranted) {
                                    imagePickerOption(
                                        'professionalDriverLicenceImagePath');
                                  } else {
                                    EasyLoading.showError(
                                        'Permission is required!');
                                  }
                                },
                                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                                  builder: (context, state) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: kFormFieldBorder,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      height: 183,
                                      width: double.infinity,
                                      child: state.setImage &&
                                              ImageConstant
                                                      .professionalDriverLicenceImagePathSet ==
                                                  true
                                          ? Image.file(File(ImageConstant
                                              .professionalDriverLicenceImagePath))
                                          : professionalDriverLicenceImage != ''
                                              ? Image.network(
                                                  professionalDriverLicenceImage,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return const Center(
                                                      child: Text(
                                                          'Error loading image'),
                                                    ); // Display an error message if the image fails to load
                                                  },
                                                )
                                              : const SizedBox(
                                                  child: Center(
                                                    child: Text(
                                                        'No image to show.'),
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
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButtonPrimary(
                        width: double.infinity,
                        onPressed: () async {
                          EasyLoading.show(status: 'loading...');

                          /// Image Upload
                          FormData formData;
                          if (ImageConstant.profilePicImagePath != '') {
                            formData = FormData.fromMap({
                              'image': await MultipartFile.fromFile(
                                  ImageConstant.profilePicImagePath,
                                  filename: 'image.jpg'),
                            });
                            uploadImageResponse = await uploadImageRepository
                                .uploadImage(formData);
                            profilePicImagePath = uploadImageResponse.data;
                          }

                          if (ImageConstant
                                  .professionalDriverLicenceImagePath !=
                              '') {
                            formData = FormData.fromMap({
                              'image': await MultipartFile.fromFile(
                                  ImageConstant
                                      .professionalDriverLicenceImagePath,
                                  filename: 'image1.jpg'),
                            });
                            uploadImageResponse = await uploadImageRepository
                                .uploadImage(formData);
                            professionalDriverLicenceImagePath =
                                uploadImageResponse.data;
                          }

                          if (ImageConstant.rouloFileImagePath != '') {
                            formData = FormData.fromMap({
                              'image': await MultipartFile.fromFile(
                                  ImageConstant.rouloFileImagePath,
                                  filename: 'image2.jpg'),
                            });
                            uploadImageResponse = await uploadImageRepository
                                .uploadImage(formData);
                            rouloFileImagePath = uploadImageResponse.data;
                          }

                          if (ImageConstant.driverLicenceImagePath != '') {
                            formData = FormData.fromMap({
                              'image': await MultipartFile.fromFile(
                                  ImageConstant.driverLicenceImagePath,
                                  filename: 'image3.jpg'),
                            });
                            uploadImageResponse = await uploadImageRepository
                                .uploadImage(formData);
                            driverLicenceImagePath = uploadImageResponse.data;
                          }

                          ProfileUpdateRequest profileUpdateRequest =
                              ProfileUpdateRequest(
                            emailController.text,
                            nameController.text,
                            phoneController.text,
                            dateOfBirthIsoString,
                            profilePicImagePath,
                            driverLicenceImagePath,
                            drivingLicenceNumberController.text,
                            rouloFileImagePath,
                            kbNumberController.text,
                            kbExpiryDateIsoString,
                            professionalDriverLicenceImagePath,
                          );

                          try {
                            print(jsonEncode(profileUpdateRequest.toJson()));
                            var response = await dio.patch(
                              RestAPICall.baseURL +
                                  RestAPICall.updateProfileEndPoint,
                              data: jsonEncode(profileUpdateRequest.toJson()),
                              options: Options(
                                headers: await tokenProvider.retrieveHeader(),
                                validateStatus: (status) {
                                  return status == null ||
                                      (status >= 200 && status < 300) ||
                                      status == 400 ||
                                      status == 500;
                                },
                              ),
                            );

                            if (response.statusCode == 200) {
                              print(response.toString());
                              Map<String, dynamic> responseData =
                                  json.decode(response.toString());

                              updateAuthUser();

                              EasyLoading.dismiss();
                              ImageConstant.profilePicImagePath = '';
                              ImageConstant.professionalDriverLicenceImagePath =
                                  '';
                              ImageConstant.rouloFileImagePath = '';
                              ImageConstant.driverLicenceImagePath = '';
                              EasyLoading.showSuccess(responseData['message']!);
                            } else if ((response.statusCode == 400)) {
                              print(response.toString());
                              Map<String, dynamic> responseData =
                                  json.decode(response.toString());
                              EasyLoading.dismiss();
                              // EasyLoading.showError(
                              //     responseData['errors']![0]['msg']);
                            } else if ((response.statusCode == 500)) {
                              print(response.toString());
                              // Map<String, dynamic> responseData =
                              // json.decode(response.toString());
                              EasyLoading.dismiss();
                              EasyLoading.showError(
                                  'Sorry! Something went wrong.');
                              // EasyLoading.showError(
                              //     responseData['errors']![0]['msg']);
                            }
                          } catch (e) {
                            print(e);
                            EasyLoading.dismiss();
                            EasyLoading.showError(
                                'Sorry! Something went wrong.');
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
                      ),
                      const SizedBox(
                        height: 20,
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
                top: (MediaQuery.of(context).size.height) * 0.24,
                left: (MediaQuery.of(context).size.width) * 0.27,
                child: BlocBuilder<InvoiceCubit, InvoiceState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 167,
                      width: 167,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: state.setImage &&
                                ImageConstant.profilePicImagePathSet == true
                            ? ClipOval(
                          child: Image.file(
                                    File(ImageConstant.profilePicImagePath),
                                    fit: BoxFit.cover),
                              )
                            : CircleAvatar(
                          backgroundImage: NetworkImage(profileImage),
                                backgroundColor: kPrimaryColor,
                              ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.height) * 0.40,
                left: (MediaQuery.of(context).size.width) * 0.65,
                child: GestureDetector(
                  onTap: () async {
                    if (await Permission.camera.request().isGranted &&
                        await Permission.storage.request().isGranted) {
                      imagePickerOption('profilePicImagePath');
                    } else {
                      EasyLoading.showError('Permission is required!');
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons/edit_profile_photo.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleBackPressed() {
    Navigator.of(context).pop();
    BlocProvider.of<FabCubit>(context).showFab();
    BlocProvider.of<InvoiceCubit>(context).removeImage();
  }

  void imagePickerOption(String path) {
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
                        if (!path.contains('profilePicImagePath')) {
                          Navigator.pushNamed(
                            context,
                            '/take-picture-screen',
                            arguments: path,
                          );
                        } else {
                          Navigator.pushNamed(
                              context, '/take-profile-picture-screen');
                        }
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
                          if (path
                              .contains('professionalDriverLicenceImagePath')) {
                            ImageConstant.professionalDriverLicenceImagePath =
                                pickedFile!.path;
                            ImageConstant
                                .professionalDriverLicenceImagePathSet = true;
                            setImage();
                          } else if (path.contains('rouloFileImagePath')) {
                            ImageConstant.rouloFileImagePath = pickedFile!.path;
                            ImageConstant.rouloFileImagePathSet = true;
                            setImage();
                          } else if (path.contains('profilePicImagePath')) {
                            ImageConstant.profilePicImagePath =
                                pickedFile!.path;
                            ImageConstant.profilePicImagePathSet = true;
                            setImage();
                          } else if (path.contains('driverLicenceImagePath')) {
                            ImageConstant.driverLicenceImagePath =
                                pickedFile!.path;
                            ImageConstant.driverLicenceImagePathSet = true;
                            setImage();
                          }
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

  void setImage() {
    BlocProvider.of<InvoiceCubit>(context).setImage();
  }

  void updateAuthUser() {
    BlocProvider.of<GetAuthenticatedUserCubit>(context)
        .getAuthenticatedUser(token, context);
  }
}
