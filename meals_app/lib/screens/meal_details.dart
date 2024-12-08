import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/weekly_meal_plan_provider.dart';  

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          // Favorite button
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteMealsProvider.notifier)
                  .toggleMealFavoriteStatus(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    wasAdded ? 'Meal added as a favorite' : 'Meal removed.'),
              ));
            },
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            for (final ingredient in meal.ingredients)
              Text(
                
                ingredient,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                    
              ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                     '\u2022  $step',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Add to Weekly Plan Button
            ElevatedButton(
              onPressed: () => _showDaySelectionDialog(context, ref),
              child: const Text('Add to Weekly Plan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDaySelectionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Day',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),),
          content: SingleChildScrollView(
            child: Column(
              children: WeeklyMealPlanNotifier.weekDays
                  .map((day) => ListTile(
                        title: Text(day),
                        onTap: () {
                          _addMealToWeeklyPlan(day, ref);
                          Navigator.pop(context);  // Close the dialog
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _addMealToWeeklyPlan(String day, WidgetRef ref) {
    // Add the selected meal to the weekly plan
    final weeklyMealPlan = ref.read(weeklyMealPlanProvider.notifier);
    weeklyMealPlan.addMeal(day, meal);

    // Show a snack bar confirming the meal has been added
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text('Added ${meal.title} to $day')),
    );
  }
}
