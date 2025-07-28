import 'package:coworking/pages/ComplaintsPage.dart';
import 'package:coworking/pages/EventsPage.dart';
import 'package:coworking/pages/InvoicingPage.dart';
import 'package:coworking/pages/MeetingRoomPage.dart';
import 'package:flutter/material.dart';

// Main Section
class CoworkingSpacesSection extends StatelessWidget {
final String token;
  
const CoworkingSpacesSection({super.key, required this.token});    
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Coworking Spaces In Jaipur we provide',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our RAW spaces are designed for freelancers, entrepreneurs, executive teams, and corporate MSMEs, providing the top coworking space in Jaipur.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Grid Section
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FeatureCard(
                  icon: Icons.meeting_room,
                  title: 'Meeting Rooms',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MeetingRoomPage(token: token)),
                    );
                  },
                ),
                FeatureCard(
                  icon: Icons.event,
                  title: 'Community Events',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventsPage()),
                    );
                  },
                ),
                FeatureCard(
                  icon: Icons.report_problem,
                  title: 'Complaints',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicePage(token: token)),
                    );
                  },
                ),
                FeatureCard(
                  icon: Icons.receipt_long,
                  title: 'Invoicing',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>UserInvoicePage(token: token)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// FeatureCard Widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFC0392B),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
