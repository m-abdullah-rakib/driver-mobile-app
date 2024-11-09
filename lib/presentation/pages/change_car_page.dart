import 'package:driver_app/data/repositories/change_car_repository.dart';
import 'package:driver_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';

import '../../business_logic/cubits/fab_cubit.dart';
import '../../business_logic/cubits/get_all_cars_cubit.dart';
import '../../business_logic/cubits/get_authenticated_user_cubit.dart';
import '../../business_logic/cubits/main_screen_view_cubit.dart';
import '../../data/constants/rest_api_call.dart';
import '../../data/models/request/change_car_request.dart';
import '../../data/models/response/change_car_response.dart';
import '../../theme/styles.dart';
import '../../utilities/storage_data_provider.dart';
import '../widgets/change_car_list.dart';

class ChangeCarPage extends StatefulWidget {
  const ChangeCarPage({super.key});

  @override
  State<ChangeCarPage> createState() => _ChangeCarPageState();
}

class _ChangeCarPageState extends State<ChangeCarPage> {
  final ChangeCarRepository changeCarRepository = ChangeCarRepository();
  late ChangeCarResponse changeCarResponse;

  StorageDataProvider tokenProvider = StorageDataProvider();
  String token = '';

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
    return WillPopScope(
      onWillPop: () async {
        handleBackPressed();
        return false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 85,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        handleBackPressed();
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 30,
                        height: 30,
                        child: Align(
                          child: SvgPicture.asset(
                            'assets/icons/back-icon.svg',
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
                            'Change Car',
                            style: TextStyle(
                              color: Colors.black,
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
              BlocBuilder<GetAllCarsCubit, GetAllCarsState>(
                builder: (context, state) {
                  return state.freeCarsResponse != null
                      ? Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.only(top: 10),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.freeCarsResponse?.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChangeCarList(
                                    context: context,
                                    index: index,
                                    id: state
                                        .freeCarsResponse!.data![index].id!,
                                    navigationPath: '/car-details-screen',
                                    networkImageUrl: RestAPICall.getImage +
                                        state.freeCarsResponse!.data![index]
                                            .image!,
                                    model: state
                                        .freeCarsResponse!.data![index].model!,
                                    license: state.freeCarsResponse!
                                        .data![index].license!,
                                    press: () => {
                                      changeCarAPICall(
                                          state.freeCarsResponse!.data![index]
                                              .model!,
                                          state.freeCarsResponse!.data![index]
                                              .id!,
                                          context),
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: (MediaQuery.of(context).size.height) * 0.65,
                          child:
                              const Center(child: Text('No data available!')));
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  void handleBackPressed() {
    BlocProvider.of<MainScreenViewCubit>(context)
        .setCurrentPage(const HomePage());
  }

  void changeCarAPICall(
      String newCarModel, int newCarId, BuildContext parentContext) {
    GetAuthenticatedUserCubit getAuthenticatedUserCubit =
        BlocProvider.of<GetAuthenticatedUserCubit>(context);
    GetAuthenticatedUserState getAuthenticatedUserState =
        getAuthenticatedUserCubit.state;

    BlocProvider.of<FabCubit>(context).hideFab();

    ///Pop-up form for confirmation
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(8.0),
                title: Center(
                  child: Text(
                    'Please Confirm',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
                content: Wrap(children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: getAuthenticatedUserState
                                  .getAuthenticatedUserResponse?.data?.car !=
                              null
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: [
                        getAuthenticatedUserState
                                    .getAuthenticatedUserResponse?.data?.car !=
                                null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Remove',
                                    style: kDialogTitleTextStyle,
                                  ),
                                  Text(
                                    getAuthenticatedUserState
                                        .getAuthenticatedUserResponse!
                                        .data!
                                        .car!
                                        .model,
                                    style: kDialogValueTextStyle,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: getAuthenticatedUserState
                                      .getAuthenticatedUserResponse
                                      ?.data
                                      ?.car !=
                                  null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Get',
                              style: kDialogTitleTextStyle,
                            ),
                            Text(
                              newCarModel,
                              style: kDialogValueTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                          BlocProvider.of<FabCubit>(context).showFab();
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, 'Change');
                          BlocProvider.of<FabCubit>(context).showFab();

                          /// API call will start now
                          EasyLoading.show(status: 'loading...');
                          ChangeCarRequest changeCarRequest;

                          changeCarRequest = ChangeCarRequest(newCarId);

                          var changeCarAPIResponse =
                              changeCarRepository.changeCar(changeCarRequest);
                          changeCarAPIResponse.then((value) {
                            changeCarResponse = value;

                            BlocProvider.of<GetAllCarsCubit>(parentContext)
                                .getAllCars(token);
                            BlocProvider.of<GetAuthenticatedUserCubit>(
                                    parentContext)
                                .getAuthenticatedUser(token, parentContext);
                            EasyLoading.dismiss();
                            EasyLoading.showSuccess(changeCarResponse.data!);
                          }, onError: (e) {
                            EasyLoading.dismiss();
                            EasyLoading.showError(
                                'Sorry! Something went wrong.');
                          });

                          /// API call will end
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: kPrimaryColor),
                        child: const Text('Change'),
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
}
