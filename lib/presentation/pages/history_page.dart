import 'package:driver_app/data/repositories/change_car_repository.dart';
import 'package:driver_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../business_logic/cubits/get_ledgers_cubit.dart';
import '../../business_logic/cubits/main_screen_view_cubit.dart';
import '../../data/models/response/change_car_response.dart';
import '../../data/models/response/get_ledgers_response.dart';
import '../widgets/history_list_view.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.fromHomePage,
  });

  final bool fromHomePage;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  final ChangeCarRepository changeCarRepository = ChangeCarRepository();
  late ChangeCarResponse changeCarResponse;

  List<GetLedgersResponseData> incomeList = [];
  List<GetLedgersResponseData> expenseList = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      incomeList = [];
      expenseList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackPressed();
        return false;
      },
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(
          top: 85,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.fromHomePage
                      ? GestureDetector(
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
                        )
                      : const SizedBox(
                          width: 30,
                          height: 30,
                        ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 30.0),
                      child: Center(
                        child: Text(
                          'History',
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
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 15),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'Income',
                        ),
                        Tab(
                          text: 'Expense',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height) * 0.60,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          BlocBuilder<GetLedgersCubit, GetLedgersState>(
                            builder: (context, state) {
                              if (state.getLedgersResponse != null) {
                                for (var data
                                    in state.getLedgersResponse!.data!) {
                                  if (data.income != null) {
                                    incomeList.add(data);
                                  } else {
                                    expenseList.add(data);
                                  }
                                }
                              }

                              return state.getLedgersResponse != null
                                  ? incomeList.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            top: 10.0,
                                            right: 10.0,
                                          ),
                                          itemCount: incomeList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return HistoryListView(
                                              context: context,
                                              index: index,
                                              navigationPath:
                                                  '/history-details-screen',
                                              amount: incomeList[index].amount!,
                                              networkImageUrl:
                                                  'https://picsum.photos/250?image=9',
                                              category: incomeList[index]
                                                  .income!
                                                  .type!,
                                              type: incomeList[index].type!,
                                              fromDashboardStatistics: false,
                                            );
                                          },
                                        )
                                      : const Text('No data available!')
                                  : const Text('No data available!');
                            },
                          ),
                          BlocBuilder<GetLedgersCubit, GetLedgersState>(
                            builder: (context, state) {
                              return state.getLedgersResponse != null
                                  ? expenseList.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            top: 10.0,
                                            right: 10.0,
                                          ),
                                          itemCount: expenseList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return HistoryListView(
                                              context: context,
                                              index: index,
                                              navigationPath:
                                                  '/history-details-screen',
                                              amount:
                                                  expenseList[index].amount!,
                                              networkImageUrl:
                                                  'https://picsum.photos/250?image=9',
                                              category: expenseList[index]
                                                  .income!
                                                  .type!,
                                              type: expenseList[index].type!,
                                              fromDashboardStatistics: false,
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text('No data available!'))
                                  : const Text('No data available!');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void handleBackPressed() {
    BlocProvider.of<MainScreenViewCubit>(context)
        .setCurrentPage(const HomePage());
  }
}
