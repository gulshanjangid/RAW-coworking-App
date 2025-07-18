import 'package:flutter/material.dart';

class OneDayPassesPage extends StatelessWidget {
  const OneDayPassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: const Text('One-Day Passes'),
      ),
      body: const SpaceSelectionScreen(),
    );
  }
}

class SpaceSelectionScreen extends StatefulWidget {
  const SpaceSelectionScreen({super.key});

  @override
  State<SpaceSelectionScreen> createState() => _SpaceSelectionScreenState();
}

class _SpaceSelectionScreenState extends State<SpaceSelectionScreen> {
  String selectedSpace = 'coworking';
  DateTime selectedDate = DateTime.now();
  String selectedTimeSlot = 'Full Day (9am-6pm)';

  final Map<String, Space> spaces = {
    'coworking': Space(
      title: 'Coworking Space',
      price: '₹600',
      availability: '6 spaces available today',
      icon: Icons.work_outline,
      color: Colors.red.shade700,
      amenities: [
        Amenity(name: 'WiFi', icon: Icons.wifi, color: Colors.red.shade700),
        Amenity(name: 'Coffee', icon: Icons.coffee, color: Colors.red.shade700),
        Amenity(name: 'Printer', icon: Icons.print, color: Colors.red.shade700),
        Amenity(name: 'Lockers', icon: Icons.lock, color: Colors.red.shade700),
        Amenity(name: 'Snacks', icon: Icons.cake, color: Colors.red.shade700),
        Amenity(name: '24/7 Access', icon: Icons.access_time, color: Colors.red.shade700),
        Amenity(name: 'Whiteboard', icon: Icons.edit, color: Colors.red.shade700),
        Amenity(name: 'Community Events', icon: Icons.people, color: Colors.red.shade700),
      ],
    ),
    'meeting': Space(
      title: 'Meeting Room',
      price: '₹1800',
      availability: '3 rooms available today',
      icon: Icons.meeting_room,
      color: Colors.red.shade700,
      amenities: [
        Amenity(name: 'TV Screen', icon: Icons.tv, color: Colors.red.shade700),
        Amenity(name: 'Whiteboard', icon: Icons.edit, color: Colors.red.shade700),
        Amenity(name: 'Conference Call', icon: Icons.call, color: Colors.red.shade700),
        Amenity(name: 'Notepads', icon: Icons.note, color: Colors.red.shade700),
        Amenity(name: 'Water Bottles', icon: Icons.water_drop, color: Colors.red.shade700),
        Amenity(name: 'Snacks', icon: Icons.cake, color: Colors.red.shade700),
        Amenity(name: 'WiFi', icon: Icons.wifi, color: Colors.red.shade700),
        Amenity(name: 'Projector', icon: Icons.videocam, color: Colors.red.shade700),
      ],
    ),
    'private': Space(
      title: 'Private Cabin',
      price: '₹1200',
      availability: '2 cabins available today',
      icon: Icons.work,
      color: Colors.red.shade700,
      amenities: [
        Amenity(name: 'Standing Desk', icon: Icons.desk, color: Colors.red.shade700),
        Amenity(name: 'Ergonomic Chair', icon: Icons.chair, color: Colors.red.shade700),
        Amenity(name: 'Noise Cancelling', icon: Icons.hearing, color: Colors.red.shade700),
        Amenity(name: 'Storage', icon: Icons.storage, color: Colors.red.shade700),
        Amenity(name: 'Personalized AC', icon: Icons.ac_unit, color: Colors.red.shade700),
        Amenity(name: 'WiFi', icon: Icons.wifi, color: Colors.red.shade700),
        Amenity(name: 'Coffee', icon: Icons.coffee, color: Colors.red.shade700),
        Amenity(name: 'Dedicated Line', icon: Icons.phone, color: Colors.red.shade700),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentSpace = spaces[selectedSpace]!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'One-Day Passes',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your perfect workspace for the day. All passes include high-speed WiFi, refreshments, and access to our premium facilities.',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SpaceCard(
                    space: spaces['coworking']!,
                    isSelected: selectedSpace == 'coworking',
                    onTap: () => setState(() => selectedSpace = 'coworking'),
                  ),
                  const SizedBox(width: 16),
                  SpaceCard(
                    space: spaces['meeting']!,
                    isSelected: selectedSpace == 'meeting',
                    onTap: () => setState(() => selectedSpace = 'meeting'),
                  ),
                  const SizedBox(width: 16),
                  SpaceCard(
                    space: spaces['private']!,
                    isSelected: selectedSpace == 'private',
                    onTap: () => setState(() => selectedSpace = 'private'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            buildSpaceDetails(currentSpace),
          ],
        ),
      ),
    );
  }

  Widget buildSpaceDetails(Space currentSpace) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentSpace.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Included Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: currentSpace.amenities
                .map((amenity) => AmenityItem(amenity: amenity))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Availability',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currentSpace.availability,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Time Slot',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: selectedTimeSlot,
                  items: const [
                    DropdownMenuItem(
                      value: 'Full Day (9am-6pm)',
                      child: Text('Full Day (9am-6pm)'),
                    ),
                    DropdownMenuItem(
                      value: 'Morning (9am-1pm)',
                      child: Text('Morning (9am-1pm)'),
                    ),
                    DropdownMenuItem(
                      value: 'Afternoon (1pm-6pm)',
                      child: Text('Afternoon (1pm-6pm)'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedTimeSlot = value!);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Booking confirmed for ${currentSpace.title} on ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} (${selectedTimeSlot})',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentSpace.color,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'Book Now - ${currentSpace.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Space {
  final String title;
  final String price;
  final String availability;
  final IconData icon;
  final Color color;
  final List<Amenity> amenities;

  Space({
    required this.title,
    required this.price,
    required this.availability,
    required this.icon,
    required this.color,
    required this.amenities,
  });
}

class Amenity {
  final String name;
  final IconData icon;
  final Color color;

  Amenity({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class SpaceCard extends StatelessWidget {
  final Space space;
  final bool isSelected;
  final VoidCallback onTap;

  const SpaceCard({super.key, required this.space, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: space.color, width: 2) : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: space.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(space.icon, size: 40, color: space.color),
            ),
            const SizedBox(height: 16),
            Text(
              space.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              space.price,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: space.color),
            ),
            const SizedBox(height: 4),
            const Text('/day', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? space.color : Colors.white,
                  foregroundColor: isSelected ? Colors.white : space.color,
                  side: BorderSide(color: space.color),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(isSelected ? 'Selected' : 'Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmenityItem extends StatelessWidget {
  final Amenity amenity;

  const AmenityItem({super.key, required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: amenity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(amenity.icon, size: 20, color: amenity.color),
        ),
        const SizedBox(height: 8),
        Text(amenity.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
