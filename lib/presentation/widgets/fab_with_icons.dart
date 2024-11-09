import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FabWithIcons extends StatefulWidget {
  FabWithIcons({
    super.key,
    required this.icons,
  });

  final List<IconData> icons;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FabCubit, FabState>(
      builder: (context, state) {
        return state.showFab
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChild(1),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildFab(),
                  // showFab ? _buildFab() : const SizedBox(),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildChild(int index) {
    return Row(
      children: [
        Container(
          height: 72.0,
          width: 62.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<FabCubit>(context).hideFab();
                _controller.reverse();
                BlocProvider.of<IncomeExpenseCubit>(context).isIncomeSelected();
                BlocProvider.of<IncomeExpenseCategoryCubit>(context)
                    .setIncomeCategory('assets/icons/cash_icon.svg', 'CASH',
                        665.0, 695.0, 410.0, 440.0, false);
                Navigator.pushNamed(
                  context,
                  '/income-expense-screen',
                );
              },
              child: const PromptItem(
                gradient: kGradientPrimary,
                icon: 'assets/images/Vector.svg',
                title: 'Income',
                titleFontSize: 12.0,
                containerHeight: 65,
                containerWeight: 65,
                iconHeight: 18,
                iconWeight: 18,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 72,
          width: 72,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<FabCubit>(context).hideFab();
                _controller.reverse();
                BlocProvider.of<IncomeExpenseCubit>(context)
                    .isExpenseSelected();
                BlocProvider.of<IncomeExpenseCategoryCubit>(context)
                    .setExpenseCategory('assets/icons/maintenance_icon.svg',
                        'MAINTENANCE', 570.0, 600.0, 320.0, 350.0, false);
                Navigator.pushNamed(
                  context,
                  '/income-expense-screen',
                );
              },
              child: const PromptItem(
                gradient: kGradientRed,
                icon: 'assets/images/Vector-2.svg',
                title: 'Expense',
                titleFontSize: 12.0,
                containerHeight: 65,
                containerWeight: 65,
                iconHeight: 20,
                iconWeight: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.transparent,
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
        elevation: 0.0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

}
