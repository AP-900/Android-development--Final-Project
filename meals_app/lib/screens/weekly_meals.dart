import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/weekly_meal_plan_provider.dart';
import 'package:meals_app/screens/shopping_list.dart';

class WeeklyPlanScreen extends ConsumerWidget {
  const WeeklyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the weekly meal plan provider
    final weeklyMealPlan = ref.watch(weeklyMealPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the shopping list screen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShoppingListScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var day in _weekDays)
            ListTile(
              title: Text(day),
              subtitle: Text(
                weeklyMealPlan.meals[day]?.title ??
                    'No meal planned for this day',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  // Here you can navigate to a screen or open a dialog to select a meal for the day
                  final meal = await _selectMeal(context);
                  if (meal != null) {
                    ref
                        .read(weeklyMealPlanProvider.notifier)
                        .addMeal(day, meal);
                  }
                },
              ),
            ),
       
        ],
      ),
    );
  }

  Future<Meal?> _selectMeal(BuildContext context) async {
    // Simulate meal selection (you could show a dialog or navigate to another screen)
    // For this example, we'll just return a sample meal
    return const Meal(
      id: 'm2',
      categories: [
        'c2',
      ],
      title: 'Toast Hawaii',
      affordability: Affordability.affordable,
      complexity: Complexity.simple,
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      duration: 10,
      ingredients: [
        '1 Slice White Bread',
        '1 Slice Ham',
        '1 Slice Pineapple',
        '1-2 Slices of Cheese',
        'Butter'
      ],
      steps: [
        'Butter one side of the white bread',
        'Layer ham, the pineapple and cheese on the white bread',
        'Bake the toast for round about 10 minutes in the oven at 200°C'
      ],
      isGlutenFree: false,
      isVegan: false,
      isVegetarian: false,
      isLactoseFree: false,
    );
  }

  // List of week days to iterate over
  static const List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
}
