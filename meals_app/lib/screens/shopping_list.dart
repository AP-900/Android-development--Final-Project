import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/weekly_meal_plan_provider.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the weekly meal plan provider to get the ingredients for the entire week
    final weeklyMealPlan = ref.watch(weeklyMealPlanProvider);

    // Get the aggregated ingredients for the entire week
    final ingredients = weeklyMealPlan.getWeeklyIngredients();

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Shopping List')),
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ingredients[index]),
          );
        },
      ),
    );
  }
}
