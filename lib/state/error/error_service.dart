import 'package:crust/services/toaster.dart';

class ErrorService {
  const ErrorService();

  Future<bool> addSystemError(String type, String description) async {
    String query = """
      query {
        addSystemError(errorType: $type, description: $description) {
          error_type,
          description,
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addSystemError'];
    return json['error_type'] == type && json['description'] == description;
  }
}
