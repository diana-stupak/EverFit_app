import 'package:flutter/material.dart';
import 'meals.dart';

class WaterTrackerPage extends StatefulWidget {
  final double weight;

  WaterTrackerPage({required this.weight});

  @override
  _WaterTrackerPageState createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  double _waterIntake = 0.0;
  double _dailyGoal = 0.0;
  DateTime _selectedDate = DateTime.now();
  bool _feedbackVisible = false;

  @override
  void initState() {
    super.initState();
    _dailyGoal = widget.weight * 0.03;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Water Tracker'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDateSelector(),
              SizedBox(height: 100),
              Text(
                "You should drink ${_dailyGoal.toStringAsFixed(1)} liters of water per day!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 20),
              _buildWaterSlider(),
              SizedBox(height: 20),
              _buildActionButtons(),
              if (_feedbackVisible) SizedBox(height: 20),
              if (_feedbackVisible) _buildFeedbackMessage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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
          _buildNavItem(Icons.water_drop, 'Water', context, isSelected: true),
          _buildNavItem(Icons.restaurant_menu, 'Meals', context),
          _buildNavItem(Icons.person, 'Profile', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, BuildContext context, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label != 'Water') {
          if (label == 'Meals') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MealsPage()),
            );
          } else if (label == 'Profile') {
            Navigator.pop(context); 
          } else {
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

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
        bool isSelected = _selectedDate.day == date.day;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  _getWeekdayName(date),
                  style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),
                ),
                Text(
                  '${date.day}',
                  style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _getWeekdayName(DateTime date) {
    List<String> weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'St', 'Su'];
    return weekdays[date.weekday - 1];
  }

  Widget _buildWaterSlider() {
    return Column(
      children: [
        Slider(
          value: _waterIntake,
          min: 0,
          max: _dailyGoal + 1,
          divisions: 20,
          label: "${_waterIntake.toStringAsFixed(1)} L",
          onChanged: (value) {
            setState(() {
              _waterIntake = value;
            });
          },
        ),
        Text("${_waterIntake.toStringAsFixed(1)} L", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _feedbackVisible = true;
            });
          },
          child: Text("Done"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _waterIntake = 0.0;
              _feedbackVisible = false;
            });
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }

  Widget _buildFeedbackMessage() {
    if (_waterIntake >= _dailyGoal) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Great job! 🎉 You reached your daily water intake goal! Keep staying hydrated!",
          style: TextStyle(color: Colors.green, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Looks like you didn't drink enough water today! 💧 Stay hydrated for better energy and recovery!",
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

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
