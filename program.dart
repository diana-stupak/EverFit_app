import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({Key? key}) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  bool _showModal = false;

  
  final List<String> _videoPaths = [
    'assets/videos/sit.mp4', 
    'assets/videos/set.mp4',  
    
  ];

  // Список контролерів відтворення відео
  late List<VideoPlayerController> _videoControllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  @override
  void initState() {
    super.initState();
    _videoControllers = _videoPaths.map((path) => VideoPlayerController.asset(path)).toList();
    _initializeVideoPlayerFutures = _videoControllers.map((controller) => controller.initialize()).toList();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIST OF TRAINERS'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHOOSE!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTrainerCard(
                'Oleh Ostrozkiy',
                'fitness trainer',
                '+380 957 593 374',
                'assets/images/meals/oleh_ostrozkiy.jpg',
              ),
              _buildTrainerCard(
                'Hanna Kapture',
                'personal trainer',
                '+380 957 593 654',
                'assets/images/meals/hanna_kapture.jpg',
              ),
              _buildTrainerCard(
                'Nazar Chaliy',
                'personal trainer',
                '+380 957 313 654',
                'assets/images/meals/nazar_chaliy.jpg',
              ),
             
              _buildTrainerCard(
                'Iryna Darkiv',
                'fitness trainer',
                '+380 978 379 654',
                'assets/images/meals/iryna_darkiv.jpg',
              ),
              const SizedBox(height: 30),
              const Text(
                'POPULAR EXERCISES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildVideoCard(0, 'Присідання'), 
                  _buildVideoCard(1, 'Планка'),
                ],
              ),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildVideoCard(int videoIndex, String title) {
    return FutureBuilder(
      future: _initializeVideoPlayerFutures[videoIndex],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _videoControllers[videoIndex].value.aspectRatio,
                child: VideoPlayer(_videoControllers[videoIndex]),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  _videoControllers[videoIndex].value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    if (_videoControllers[videoIndex].value.isPlaying) {
                      _videoControllers[videoIndex].pause();
                    } else {
                      _videoControllers[videoIndex].play();
                    }
                  });
                },
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTrainerCard(String name, String specialization, String phone, String imagePath) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(specialization),
                  Text(phone),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showModal = true;
                });
                _showTrainingTimeModal(context);
              },
              child: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrainingTimeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please! Enter the time you want to have training.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text('Day'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: const Text('Time'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Training scheduled!')),
                      );
                    },
                    child: const Text('Done'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {});
    }
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
          _buildNavItem(Icons.list, 'Program', context, isSelected: true),
          _buildNavItem(Icons.water_drop, 'Water', context),
          _buildNavItem(Icons.restaurant_menu, 'Meals', context),
          _buildNavItem(Icons.person, 'Profile', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, BuildContext context, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label != 'Program') {
         
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
