import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/fab_cubit.dart';
import '../../theme/styles.dart';

class ChangeCarList extends StatelessWidget {
  const ChangeCarList({
    Key? key,
    required this.context,
    required this.index,
    required this.id,
    required this.navigationPath,
    required this.networkImageUrl,
    required this.model,
    required this.license,
    this.press,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final int id;
  final String navigationPath;
  final String networkImageUrl;
  final String model;
  final String license;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          navigationPath,
          arguments: [networkImageUrl, id.toString(), model, license],
        );
        BlocProvider.of<FabCubit>(context).hideFab();
      },
      child: Card(
        color: kChangeCarListBackground,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: SizedBox(
            width: double.infinity,
            height: 146.03,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 71.52,
                      width: 112.13,
                      child: Image.network(networkImageUrl),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 71.52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            license,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color(0xFFEEF2F6),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: 'Urbanist',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: press,
                        child: SizedBox(
                          width: 58,
                          height: 22,
                          child: Card(
                            color: kPrimaryColor,
                            elevation: 1,
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: const Center(
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
