import 'package:coworking/pages/coworking_spaces_section.dart';
import 'package:coworking/pages/profile_section.dart';
import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
  // Retrieve passed user data
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String userName = args['userName'] ?? 'Unknown User';
    final String userEmail = args['userEmail'] ?? 'Unknown Email';
    final String cabinNumber = args['cabinNumber'] ?? 'Unknown Cabin';
   final String token = args['token']; 
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F6),

      body: SafeArea(
        child:Column(
        children: [
           // Header
          UserProfileHeader(
            userName: userName,
            userEmail: userEmail,
            cabinNumber: cabinNumber,
          ),


            //  // Menu icon
            //     IconButton(
            //       icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
            //       onPressed: () {
            //         // You can open a Drawer or show a menu here
            //         showModalBottomSheet(
            //           context: context,
            //           isScrollControlled: true,
            //           backgroundColor: Colors.black,
            //           builder: (context) {
            //             return const MenuDrawer();
            //           },
            //         );
            //       },
            //     ),
            // Coworking Spaces Section
            CoworkingSpacesSection(token: token),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               

                
              ],
            ),
            
          ),
           // Space
        ],

      ),
      )
      
    );
  }
  
}
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.black,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          _buildMenuItem(context, 'Home'),
          ExpansionTile(
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            title: const Text('Coworking Space', style: TextStyle(color: Colors.white)),
            children: [
              _subMenuItem(context, 'Coworking Space in Malviya Nagar'),
              _subMenuItem(context, 'Coworking Space in Vaishali Nagar'),
              _subMenuItem(context, 'Coworking Space in Mansarovar'),
            ],
          ),
          ExpansionTile(
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            title: const Text('Our Services', style: TextStyle(color: Colors.white)),
            children: [
              _subMenuItem(context, 'Private Cabins'),
              _subMenuItem(context, 'Meeting Rooms'),
              _subMenuItem(context, 'Virtual Offices'),
              _subMenuItem(context, 'RAW Day Pass'),
            ],
          ),
          _buildMenuItem(context, 'About Us'),
          _buildMenuItem(context, 'Contact Us'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Close the modal
        // Navigate or trigger action
      },
    );
  }

  Widget _subMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Navigator.pop(context);
        // Navigate to that subpage
      },
    );
  }
}