import 'dart:convert';
import 'package:http/http.dart' as http;

class MealService {
  final String _apiKey = 'c0c21435a08048218194ee41b27e2f8a';  // Replace with your API key
  final String _baseUrl = 'https://api.spoonacular.com/recipes';

  // Fetch meals based on search query
  Future<List<dynamic>> searchMeals(String query) async {
    final url = Uri.parse('$_baseUrl/complexSearch?query=$query&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // Returns the list of meal objects
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Fetch detailed information about a specific meal
  Future<Map<String, dynamic>> getMealDetails(int mealId) async {
    final url = Uri.parse('$_baseUrl/$mealId/information?apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body); // Returns detailed information of the meal
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
