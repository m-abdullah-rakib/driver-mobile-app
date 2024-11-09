import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final String icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: BlocBuilder<IncomeExpenseCubit, IncomeExpenseState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: state.isExpense ? kGradientRed : kGradientPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kWhiteTextColor,
                padding: const EdgeInsets.all(10),
              ),
              onPressed: press,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  RoundedIconPlaceholder(icon: icon),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: kWhiteTextColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
