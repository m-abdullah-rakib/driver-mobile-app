import 'package:driver_app/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../business_logic/cubits/fab_cubit.dart';
import '../widgets/feature_details_list.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List propertyList = ModalRoute.of(context)!.settings.arguments as List;

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
                            'Vehicle Details',
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
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: SizedBox(
                height: propertyList[0].toString() == 'Car image not available'
                    ? 100
                    : 200,
                width: double.infinity,
                child: Image.network(
                  propertyList[0].toString(),
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Text(propertyList[0].toString()),
                    ); // Display an error message if the image fails to load
                  },
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                FeatureDetailsList(
                  context: context,
                  svgAssetPath: 'assets/icons/car_model_icon.svg',
                  title: 'Car ID',
                  property: propertyList[1],
                ),
                FeatureDetailsList(
                  context: context,
                  svgAssetPath: 'assets/icons/car_model_icon.svg',
                  title: 'Model No',
                  property: propertyList[2],
                ),
                FeatureDetailsList(
                  context: context,
                  svgAssetPath: 'assets/icons/license_icon.svg',
                  title: 'License No',
                  property: propertyList[3],
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
