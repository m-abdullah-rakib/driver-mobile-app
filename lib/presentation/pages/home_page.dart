import 'package:driver_app/data/constants/rest_api_call.dart';
import 'package:driver_app/month_year_picker-0.3.0+1/lib/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../business_logic/cubits/cohort_cubit.dart';
import '../../business_logic/cubits/driver_overview_cubit.dart';
import '../../business_logic/cubits/fab_cubit.dart';
import '../../business_logic/cubits/get_all_cars_cubit.dart';
import '../../business_logic/cubits/get_authenticated_user_cubit.dart';
import '../../business_logic/cubits/get_ledgers_cubit.dart';
import '../../business_logic/cubits/main_screen_view_cubit.dart';
import '../../business_logic/cubits/month_year_cubit.dart';
import '../../data/models/request/change_car_request.dart';
import '../../data/models/response/change_car_response.dart';
import '../../data/models/response/cohort_response.dart';
import '../../data/repositories/change_car_repository.dart';
import '../../theme/styles.dart';
import '../../utilities/custom_design/curve_clipper.dart';
import '../../utilities/storage_data_provider.dart';
import '../widgets/common_list_view.dart';
import 'change_car_page.dart';

class HomePage extends StatefulWidget {
  static const String path = "lib/src/pages/profile/profile8.dart";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentYear = DateTime.now();
  StorageDataProvider storageDataProvider = StorageDataProvider();
  String token = '';
  int month = 0;
  String year = '';
  String cohortYear = '';

  final ChangeCarRepository changeCarRepository = ChangeCarRepository();
  late ChangeCarResponse changeCarResponse;

  @override
  void initState() {
    super.initState();

    year = currentYear.year.toString();
    getToken();
  }

  getToken() async {
    token = await storageDataProvider.retrieveToken();
  }

  @override
  Widget build(BuildContext context) {
    CohortCubit cohortCubit = BlocProvider.of<CohortCubit>(context);
    CohortState cohortState = cohortCubit.state;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    decoration: kCurvedStyle,
                    height: (MediaQuery.of(context).size.height) * 0.40,
                    padding: const EdgeInsets.only(
                      top: 75,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome',
                                      style: kDescriptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 25,
                                      child: BlocBuilder<
                                          GetAuthenticatedUserCubit,
                                          GetAuthenticatedUserState>(
                                        builder: (context, state) {
                                          return state.getAuthenticatedUserResponse !=
                                                  null
                                              ? Text(
                                                  state
                                                      .getAuthenticatedUserResponse!
                                                      .data!
                                                      .name,
                                                  style: kCaptionTextStyle,
                                                )
                                              : const SizedBox(
                                                  height: 20,
                                                  width: 25,
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Card(
                            color: kTeal_50,
                            // elevation: 1.0,
                            // margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: kTeal_200,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: SizedBox(
                              height: 109,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BlocBuilder<GetAuthenticatedUserCubit,
                                    GetAuthenticatedUserState>(
                                  builder: (context, state) {
                                    return state.getAuthenticatedUserResponse
                                                ?.data?.car !=
                                            null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Your Car',
                                                    style: kHeadlineTextStyle,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  MainScreenViewCubit>(
                                                              context)
                                                          .setCurrentPage(
                                                              const ChangeCarPage());
                                                    },
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(50),
                                                      width: 100,
                                                      height: 26,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/arrows-repeat.svg',
                                                            width: 14.0,
                                                            height: 14.0,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                            'Change Car',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: 12.0,
                                                              // height: 21.78,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 53.28,
                                                        width: 83.53,
                                                        child: BlocBuilder<
                                                            GetAuthenticatedUserCubit,
                                                            GetAuthenticatedUserState>(
                                                          builder:
                                                              (context, state) {
                                                            return state
                                                                        .getAuthenticatedUserResponse
                                                                        ?.data
                                                                        ?.car
                                                                        ?.image !=
                                                                    null
                                                                ? Image.network(RestAPICall
                                                                        .getImage +
                                                                    state
                                                                        .getAuthenticatedUserResponse!
                                                                        .data!
                                                                        .car!
                                                                        .image)
                                                                : const SizedBox();
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      BlocBuilder<
                                                          GetAuthenticatedUserCubit,
                                                          GetAuthenticatedUserState>(
                                                        builder:
                                                            (context, state) {
                                                          return state.getAuthenticatedUserResponse !=
                                                                  null
                                                              ? Text(
                                                                  state
                                                                      .getAuthenticatedUserResponse!
                                                                      .data!
                                                                      .car!
                                                                      .model,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0XFF0F172A),
                                                                    fontFamily:
                                                                        'Urbanist',
                                                                    fontSize:
                                                                        18.0,
                                                                    // height: 21.78,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  height: 15,
                                                                  width: 15,
                                                                  child:
                                                                      CircularProgressIndicator());
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showReleaseCarDialog(
                                                          context);
                                                    },
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(50),
                                                      width: 60,
                                                      height: 26,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Release',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: 12.0,
                                                              // height: 21.78,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<
                                                          MainScreenViewCubit>(
                                                      context)
                                                  .setCurrentPage(
                                                      const ChangeCarPage());
                                            },
                                            child: const Center(
                                                child: Text(
                                              'Choose a car',
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontFamily: 'Urbanist',
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )),
                                          );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffFBFBFB),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: kPrimaryColor, // Set your desired border color
                          width: 1.0, // Set the border width
                        ),
                      ),
                      child: BlocBuilder<MonthYearCubit, MonthYearState>(
                        builder: (context, stateMonthYear) {
                          return GestureDetector(
                            onTap: () async {
                              BlocProvider.of<FabCubit>(context).hideFab();
                              cohortYear = stateMonthYear
                                  .cohortCalendarInitialDate.year
                                  .toString();
                              final selected = await showMonthYearPicker(
                                context: context,
                                initialDate:
                                    stateMonthYear.cohortCalendarInitialDate,
                                firstDate: DateTime(2023),
                                lastDate: DateTime(
                                    currentYear.year, currentYear.month),
                              );

                              if (selected != null) {
                                cohortState = cohortCubit.state;
                                updateCohortDate(cohortState.cohortResponse!);
                                DateTime dateTime =
                                    DateTime.parse(selected.toString());

                                BlocProvider.of<MonthYearCubit>(context)
                                    .changeMonthYear(
                                        DateFormat('MMM, yyyy')
                                            .format(selected),
                                        dateTime.month,
                                        selected);

                                month = dateTime.month;
                                year = dateTime.year.toString();
                                print(year);

                                cohortAPICall(year, month - 1);
                              } else {
                                BlocProvider.of<FabCubit>(context).showFab();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/calendar.svg',
                                          width: 23.33,
                                          height: 23.33,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          BlocBuilder<CohortCubit, CohortState>(
                                            builder: (context, state) {
                                              return Text(
                                                stateMonthYear.monthYear,
                                                style: const TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Start date: ',
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              BlocBuilder<CohortCubit,
                                                  CohortState>(
                                                builder: (context, state) {
                                                  return Text(
                                                    state
                                                                .cohortResponse
                                                                ?.data?[stateMonthYear
                                                                        .month -
                                                                    1]
                                                                .start !=
                                                            null
                                                        ? state
                                                            .cohortResponse!
                                                            .data![
                                                    stateMonthYear
                                                                        .month -
                                                                    1]
                                                            .start
                                                        : '',
                                                    style: const TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'End date: ',
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontFamily: 'Urbanist',
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              BlocBuilder<CohortCubit,
                                                  CohortState>(
                                                builder: (context, state) {
                                                  return Text(
                                                    state
                                                                .cohortResponse
                                                                ?.data?[stateMonthYear
                                                                        .month -
                                                                    1]
                                                                .end !=
                                                            null
                                                        ? state
                                                            .cohortResponse!
                                                            .data![
                                                    stateMonthYear
                                                                        .month -
                                                                    1]
                                                            .end
                                                        : '',
                                                    style: const TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontFamily: 'Urbanist',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Card(
                      color: kPrimaryColor,
                      elevation: 3.0,
                      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            top: 20.0,
                            right: 30.0,
                            bottom: 30.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Revenue',
                                    style: TextStyle(
                                      color: kWhiteTextColor,
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  BlocBuilder<DriverOverviewCubit,
                                      DriverOverviewState>(
                                    builder: (context, state) {
                                      return state.driverOverviewResponse?.data
                                                  ?.income?.total !=
                                              null
                                          ? Text(
                                              '\u20AC ${state.driverOverviewResponse?.data?.income?.total}',
                                              style: const TextStyle(
                                                color: kWhiteTextColor,
                                                fontFamily: 'Inter',
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : const Row(
                                              children: [
                                                Text(
                                                  '\u20AC ',
                                                  style: TextStyle(
                                                    color: kWhiteTextColor,
                                                    fontFamily: 'Inter',
                                                    fontSize: 30.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child:
                                                        CircularProgressIndicator()),
                                              ],
                                            );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Income',
                                        style: TextStyle(
                                          color: Color(0xFFD0E5E4),
                                          fontFamily: 'Inter',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      BlocBuilder<DriverOverviewCubit,
                                          DriverOverviewState>(
                                        builder: (context, state) {
                                          return state
                                                      .driverOverviewResponse
                                                      ?.data
                                                      ?.income
                                                      ?.driverIncome !=
                                                  null
                                              ? Text(
                                                  '\u20AC ${state.driverOverviewResponse?.data?.income?.driverIncome}',
                                                  style: const TextStyle(
                                                    color: kWhiteTextColor,
                                                    fontFamily: 'Inter',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : const Row(
                                                  children: [
                                                    Text(
                                                      '\u20AC ',
                                                      style: TextStyle(
                                                        color: kWhiteTextColor,
                                                        fontFamily: 'Inter',
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ],
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Expenses',
                                        style: TextStyle(
                                          color: Color(0xFFD0E5E4),
                                          fontFamily: 'Inter',
                                          fontSize: 16.0,
                                          // height: 21.78,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      BlocBuilder<DriverOverviewCubit,
                                          DriverOverviewState>(
                                        builder: (context, state) {
                                          return state.driverOverviewResponse
                                                      ?.data?.expense?.total !=
                                                  null
                                              ? Text(
                                                  '\u20AC ${state.driverOverviewResponse?.data?.expense?.total}',
                                                  style: const TextStyle(
                                                    color: kWhiteTextColor,
                                                    fontFamily: 'Inter',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : const Row(
                                                  children: [
                                                    Text(
                                                      '\u20AC ',
                                                      style: TextStyle(
                                                        color: kWhiteTextColor,
                                                        fontFamily: 'Inter',
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ],
                                                );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 30.0,
                        right: 20.0,
                      ),
                      child: SizedBox(
                        height: 22,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'History',
                              style: kHeadlineTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        BlocBuilder<GetLedgersCubit, GetLedgersState>(
                          builder: (context, state) {
                            return state.getLedgersResponse != null
                                ? state.getLedgersResponse!.data!.isEmpty
                                    ? const Center(
                                        child: SizedBox(
                                          height: 40,
                                          width: double.infinity,
                                          child: Center(
                                              child: Text('No data to show.')),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(
                                          left: 10.0,
                                          top: 10.0,
                                          right: 10.0,
                                        ),
                                        itemCount: state
                                            .getLedgersResponse?.data?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CommonListView(
                                            context: context,
                                            index: index,
                                            navigationPath:
                                                '/history-details-screen',
                                            amount: state.getLedgersResponse!
                                                .data![index].amount!,
                                            networkImageUrl:
                                                'https://picsum.photos/250?image=9',
                                            category: state.getLedgersResponse!
                                                        .data![index].income !=
                                                    null
                                                ? state.getLedgersResponse!
                                                    .data![index].income!.type!
                                                : state
                                                    .getLedgersResponse!
                                                    .data![index]
                                                    .expense!
                                                    .type!,
                                            type: state.getLedgersResponse!
                                                .data![index].type!,
                                            fromDashboardStatistics: false,
                                          );
                                        },
                                      )
                                // : const Text('No data available!');
                                : const Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              // top: 10,
              // left: 120,
              child: SvgPicture.asset(
                'assets/images/ellipse_7.svg',
                width: 212.0,
                height: 212.0,
              ),
            ),
            Positioned(
              // top: 10,
              left: 140,
              child: SvgPicture.asset(
                'assets/images/ellipse_9.svg',
                width: 85.0,
                height: 85.0,
              ),
            ),
            Positioned(
              // top: 10,
              left: 70,
              child: SvgPicture.asset(
                'assets/images/ellipse_8.svg',
                width: 127.0,
                height: 127.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cohortAPICall(String year, int month) {
    BlocProvider.of<DriverOverviewCubit>(context).emitLoadingState();
    if (cohortYear == year) {
      BlocProvider.of<DriverOverviewCubit>(context)
          .getDriverOverviewData(token, context, month);
      BlocProvider.of<GetLedgersCubit>(context)
          .getLedgers(token, context, month);
    } else {
      cohortYear = year;
      BlocProvider.of<CohortCubit>(context)
          .getCohortData(token, context, year, month);
    }
  }

  void updateCohortDate(CohortResponse cohortResponse) {
    BlocProvider.of<FabCubit>(context).showFab();
    BlocProvider.of<CohortCubit>(context).updateCurrentCohort(cohortResponse);
  }

  void showReleaseCarDialog(BuildContext parentContext) {
    BlocProvider.of<FabCubit>(context).hideFab();

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
                content: const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(child: Text('Are you want to release car?')),
                ),
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
                          Navigator.pop(context, 'Release');
                          BlocProvider.of<FabCubit>(context).showFab();

                          EasyLoading.show(status: 'loading...');
                          ChangeCarRequest changeCarRequest =
                              ChangeCarRequest(null);
                          var changeCarAPIResponse =
                              changeCarRepository.changeCar(changeCarRequest);
                          changeCarAPIResponse.then((value) {
                            changeCarResponse = value;

                            BlocProvider.of<GetAuthenticatedUserCubit>(
                                    parentContext)
                                .getAuthenticatedUser(token, parentContext);
                            BlocProvider.of<GetAllCarsCubit>(parentContext)
                                .getAllCars(token);

                            EasyLoading.dismiss();
                            EasyLoading.showSuccess(changeCarResponse.data!);
                          }, onError: (e) {
                            EasyLoading.dismiss();
                            EasyLoading.showError(
                                'Sorry! Something went wrong.');
                          });
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: kPrimaryColor),
                        child: const Text('Release'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }
}
