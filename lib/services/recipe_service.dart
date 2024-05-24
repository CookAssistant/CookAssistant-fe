import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';

class RecipeService {
  static Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/$recipeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: $decodedResponse');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  static Future<void> likeRecipe(int userId, int recipeId) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/v1/likes/new'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': userId,
        'recipeId': recipeId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to like recipe');
    }
  }

  static Future<void> unlikeRecipe(int userId, int recipeId) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/likes/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': userId,
        'recipeId': recipeId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to unlike recipe');
    }
  }

  static Future<void> deleteRecipe(int recipeId) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/$recipeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete recipe');
    }
  }

  static Future<void> registerRecipe(Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/new'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode(requestData),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: $decodedResponse');

    if (response.statusCode != 201) {
      throw Exception('Failed to register recipe: ${jsonResponse['statusCode']}');
    }
  }
}
