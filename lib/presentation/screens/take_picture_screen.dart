import 'dart:async';

import 'package:camera/camera.dart';
import 'package:driver_app/business_logic/cubits/income_expense_cubit.dart';
import 'package:driver_app/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/invoice_cubit.dart';
import '../../utilities/image_constant.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late final CameraDescription camera;
  late CameraController _controller;
  Future<void> _initializeControllerFuture = Future.value();

  // Future<void>? _initializeControllerFuture = CameraController(
  //   const CameraDescription(
  //     name: '',
  //     lensDirection: CameraLensDirection.back,
  //     sensorOrientation: 1,
  //   ),
  //   ResolutionPreset.high,
  // ).initialize();
  String imagePath = '';
  String path = '';

  @override
  void initState() {
    super.initState();

    initializeCameraSettings();
  }

  initializeCameraSettings() async {
    // WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      path = ModalRoute.of(context)!.settings.arguments.toString();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Take a picture',
          style: TextStyle(
            color: kWhiteTextColor,
            fontFamily: 'Inter',
            fontSize: 18.0,
            // height: 21.78,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        flexibleSpace: BlocBuilder<IncomeExpenseCubit, IncomeExpenseState>(
          builder: (context, state) {
            return Container(
                decoration: BoxDecoration(
              gradient: path != ''
                  ? kGradientPrimary
                  : state.isExpense
                      ? kGradientRed
                      : kGradientPrimary,
            ));
          },
        ),
      ),
      // body: _initializeControllerFuture != null
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            imagePath = image.path;

            if (path == '') {
              ImageConstant.invoiceImagePath = imagePath;
              setImage();
            } else if (path == 'professionalDriverLicenceImagePath') {
              ImageConstant.professionalDriverLicenceImagePath = imagePath;
              ImageConstant.professionalDriverLicenceImagePathSet = true;
              setImage();
            } else if (path == 'rouloFileImagePath') {
              ImageConstant.rouloFileImagePath = imagePath;
              ImageConstant.rouloFileImagePathSet = true;
              setImage();
            } else if (path == 'driverLicenceImagePath') {
              ImageConstant.driverLicenceImagePath = imagePath;
              ImageConstant.driverLicenceImagePathSet = true;
              setImage();
            } else if (path == 'profilePicImagePath') {
              ImageConstant.profilePicImagePath = imagePath;
              ImageConstant.profilePicImagePathSet = true;
              setImage();
            }

            if (!mounted) return;

            Navigator.of(context).pop();
          } catch (e) {
            // Handle exception
          }
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void setImage() {
    BlocProvider.of<InvoiceCubit>(context).setImage();
  }
}
