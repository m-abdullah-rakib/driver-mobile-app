import '../data_providers/income_api.dart';
import '../models/request/income_request.dart';
import '../models/response/income_response.dart';

class IncomeRepository {
  final IncomeAPI incomeAPI = IncomeAPI();

  Future<IncomeResponse> createIncome(IncomeRequest incomeRequest) async {
    var rawResponse = await incomeAPI.createIncomeAPICall(incomeRequest);
    print(rawResponse.data.toString());
    final IncomeResponse incomeResponse =
        IncomeResponse.fromJson(rawResponse.data);

    return incomeResponse;
  }
}
