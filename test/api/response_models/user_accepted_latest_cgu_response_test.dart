import 'package:client_common/api/response_models/user_accepted_latest_cgu_response.dart';
import 'package:test/test.dart';

void main() {
  test('from json', () {
    Map<String, dynamic> json = {"accepted": true};
    UserAcceptedLatestCguResponse acceptedLatestResponse = UserAcceptedLatestCguResponse.fromJson(json);
    expect(acceptedLatestResponse.accepted, true);
  });
}