import 'package:flutter/material.dart';
import 'water.dart';
import 'program.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({Key? key}) : super(key: key);

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<String> _mealTypes = ['breakfasts', 'dinners', 'suppers'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildMealPage('breakfasts', breakfastItems),
                  _buildMealPage('dinners', dinnerItems),
                  _buildMealPage('suppers', supperItems),
                ],
              ),
            ),
            _buildPageIndicator(),
            _buildBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPage(String mealType, List<MealItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildHeader(mealType),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildMealItemCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String mealType) {
    return Column(
      children: [
        Text(
          'Offered healthy',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          mealType,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cursive',
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMealItemCard(MealItem item) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.lightBlue.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  item.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _mealTypes.length,
              (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.list, 'Program', context),
          _buildNavItem(Icons.water_drop, 'Water', context),
          _buildNavItem(Icons.restaurant_menu, 'Meals', context, isSelected: true),
          _buildNavItem(Icons.person, 'Profile', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, BuildContext context, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label != 'Meals') {
          if (label == 'Water') {
            // Navigate to WaterTrackerPage when Water icon is clicked
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WaterTrackerPage(weight: 1)),
            );
          } else if (label == 'Profile') {
            Navigator.pop(context);
          }
          else if (label == 'Program'){ // Додаємо обробку для Program
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProgramPage()),
            );}
          else {
            // Navigate to other pages
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Placeholder()),
            );
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: isSelected ? Colors.blue : Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for unavailable pages
class Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Placeholder Page"),
      ),
    );
  }
}

// Data Models
class MealItem {
  final String name;
  final String imageAsset;

  MealItem({
    required this.name,
    required this.imageAsset,
  });
}

// Sample data
final List<MealItem> breakfastItems = [
  MealItem(name: 'Oatmeal', imageAsset: 'assets/images/meals/oatmeal.jpg'),
  MealItem(name: 'Eggs', imageAsset: 'assets/images/meals/eggs.jpg'),
  MealItem(name: 'Berries', imageAsset: 'assets/images/meals/berries.jpg'),
  MealItem(name: 'Yogurt', imageAsset: 'assets/images/meals/yogurt.jpg'),
  MealItem(name: 'Cheesecakes', imageAsset: 'assets/images/meals/cheesecakes.jpg'),
  MealItem(name: 'Cheese', imageAsset: 'assets/images/meals/cheese.jpg'),
];

final List<MealItem> dinnerItems = [
  MealItem(name: 'Greek salad', imageAsset: 'assets/images/meals/greek_salad.jpg'),
  MealItem(name: 'Vegetables', imageAsset: 'assets/images/meals/vegetables.jpg'),
  MealItem(name: 'Fried fish', imageAsset: 'assets/images/meals/fried_fish.jpg'),
  MealItem(name: 'Meat', imageAsset: 'assets/images/meals/meat.jpg'),
  MealItem(name: 'Bouillon', imageAsset: 'assets/images/meals/bouillon.jpg'),
  MealItem(name: 'Pita', imageAsset: 'assets/images/meals/pita.jpg'),
];

final List<MealItem> supperItems = [
  MealItem(name: 'Rice', imageAsset: 'assets/images/meals/rice.jpg'),
  MealItem(name: 'Buckwheat', imageAsset: 'assets/images/meals/buckwheat.jpg'),
  MealItem(name: 'Potato', imageAsset: 'assets/images/meals/potato.jpg'),
  MealItem(name: 'Fruits', imageAsset: 'assets/images/meals/fruits.jpg'),
  MealItem(name: 'Fried fish', imageAsset: 'assets/images/meals/fried_fish.jpg'),
  MealItem(name: 'Meat', imageAsset: 'assets/images/meals/meat.jpg'),
];