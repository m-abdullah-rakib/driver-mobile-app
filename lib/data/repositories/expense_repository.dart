import '../data_providers/expense_api.dart';
import '../models/request/expense_request.dart';
import '../models/response/expense_response.dart';

class ExpenseRepository {
  final ExpenseAPI expenseAPI = ExpenseAPI();

  Future<ExpenseResponse> createExpense(ExpenseRequest expenseRequest) async {
    var rawResponse = await expenseAPI.createExpenseAPICall(expenseRequest);
    print(rawResponse.data.toString());
    final ExpenseResponse expenseResponse =
        ExpenseResponse.fromJson(rawResponse.data);

    return expenseResponse;
  }
}
