import 'package:meals_app/models/meal.dart';

class WeeklyMealPlan {
  final Map<String, Meal> meals;

  WeeklyMealPlan({required this.meals});

  // Add a meal to a specific day
  void addMeal(String day, Meal meal) {
    meals[day] = meal;
  }

  // Remove a meal for a specific day
  void removeMeal(String day) {
    meals.remove(day);
  }

  // Get all ingredients for the weekly meal plan
  List<String> getWeeklyIngredients() {
    Set<String> allIngredients = {};

    meals.forEach((day, meal) {
      allIngredients.addAll(meal.ingredients);
          
    });

    return allIngredients.toList();
  }

 
}
