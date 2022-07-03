import 'package:budget_tracker/pages/home_page.dart';
import 'package:budget_tracker/pages/profile_page.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:budget_tracker/services/theme_service.dart';
import 'package:budget_tracker/widgets/add_budget_dialog.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
  ];

  List<Widget> pages = const [HomePage(), ProfilePage()];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('budget tracker'),
        leading: IconButton(
          icon: Icon(themeService.darkTheme ? Icons.sunny : Icons.dark_mode),
          onPressed: () {
            themeService.darkTheme = !themeService.darkTheme;
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AddBudgetDialog(
                          budgetToAdd: (budget) {
                            final budgetViewModel =
                                Provider.of<BudgetViewModel>(context,
                                    listen: false);
                            budgetViewModel.budget = budget;
                          },
                        ));
              },
              icon: const Icon(Icons.attach_money))
        ],
      ),
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
