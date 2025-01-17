import '../models/example_model.dart';
import '../../core/services/api_service.dart';

class ExampleRepository {
  final ApiService apiService;

  ExampleRepository(this.apiService);

  Future<ExampleModel> fetchExampleData() async {
    final data = await apiService.fetchData('https://example.com/data');
    return ExampleModel.fromJson(data);
  }
}