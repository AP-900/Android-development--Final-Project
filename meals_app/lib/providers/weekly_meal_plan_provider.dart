import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

// Weekly Meal Plan state
class WeeklyMealPlan {
  final Map<String, Meal?> meals;

  WeeklyMealPlan({required this.meals});

  // Add a meal to a specific day
  void addMeal(String day, Meal meal) {
    meals[day] = meal;
  }

  List<String> getWeeklyIngredients() {
    Map<String, double> ingredientMap = {};  // A map to store ingredient names with their total quantities

    meals.forEach((day, meal) {
      if (meal != null) {
        for (var ingredient in meal.ingredients) {
          // Parse the ingredient into its name and quantity (omit units)
          final parsedIngredient = _parseIngredient(ingredient);

          String ingredientName = parsedIngredient['ingredientName']!;
          double quantity = parsedIngredient['quantity']!;

          // Aggregate ingredients based on the name
          if (ingredientMap.containsKey(ingredientName)) {
            ingredientMap[ingredientName] = ingredientMap[ingredientName]! + quantity;
          } else {
            ingredientMap[ingredientName] = quantity;
          }
        }
      }
    });

    // Convert the aggregated ingredient map into a list of strings
    List<String> aggregatedIngredients = [];
    ingredientMap.forEach((ingredient, totalQuantity) {
      int quantityInt = totalQuantity.toInt();
      // Display only the quantity and ingredient name (omit unit)
      aggregatedIngredients.add('$quantityInt $ingredient');
    });

    return aggregatedIngredients;
  }

  // Helper function to parse the ingredient into its name and quantity (omit units)
  Map<String, dynamic> _parseIngredient(String ingredient) {
    final quantityRegex = RegExp(r'(\d+[-]?\d*)'); // Match for quantity (e.g., "1", "250", "1-2")
    final match = quantityRegex.firstMatch(ingredient);

    double quantity = 1.0;  // Default quantity is 1
    String ingredientName = ingredient.trim();  // The ingredient name itself

    if (match != null) {
      String quantityStr = match.group(1)!;  // Extracts quantity (e.g., "250", "1-2")

      // Handle range case like "1-2"
      if (quantityStr.contains('-')) {
        var parts = quantityStr.split('-');
        double startQuantity = double.parse(parts[0]);
        double endQuantity = double.parse(parts[1]);
        quantity = (startQuantity + endQuantity) / 2;  // Take the average of the range
      } else {
        quantity = double.parse(quantityStr); // Convert quantity to double
      }

      // Normalize ingredient name by removing the quantity from the original ingredient string
      ingredientName = ingredient.replaceFirst(quantityStr, '').trim();
    } else {
      // If no match, treat as 1 quantity and use the whole ingredient as the name
      ingredientName = ingredient.trim();
    }

    return {'ingredientName': ingredientName, 'quantity': quantity};  // Return the ingredient name and quantity
  }
}

// Weekly Meal Plan Provider
final weeklyMealPlanProvider =
    StateNotifierProvider<WeeklyMealPlanNotifier, WeeklyMealPlan>((ref) {
  return WeeklyMealPlanNotifier();
});

class WeeklyMealPlanNotifier extends StateNotifier<WeeklyMealPlan> {
  WeeklyMealPlanNotifier() : super(WeeklyMealPlan(meals: {}));

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Add a meal for a specific day
  void addMeal(String day, Meal meal) {
    state.addMeal(day, meal);
    state = WeeklyMealPlan(meals: Map.from(state.meals)); // Trigger state update
  }

  // Get weekly ingredients
  List<String> getWeeklyIngredients() {
    return state.getWeeklyIngredients();
  }
}
