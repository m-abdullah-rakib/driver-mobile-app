import '../data_providers/cohort_api.dart';
import '../models/response/cohort_response.dart';

class CohortRepository {
  final CohortAPI cohortAPI = CohortAPI();

  Future getCohortData(String token, String year) async {
    var rawResponse = await cohortAPI.cohortAPICall(token, year);
    final CohortResponse cohortResponse =
        CohortResponse.fromJson(rawResponse.data);

    return cohortResponse;
  }
}
