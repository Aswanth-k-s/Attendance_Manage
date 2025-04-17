import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(""),
        elevation: 0,
      ),
      body: Row(
        children: [
          NavigationSidebar(),

          Expanded(
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('Student')
                                .orderBy('Timestamp', descending: true)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error loading data"),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          final totalStudents = docs.length;

                          final newToday =
                              docs.where((doc) {
                                final timestamp = doc['Timestamp'];
                                if (timestamp is Timestamp) {
                                  final docDate = timestamp.toDate();
                                  final today = DateTime.now();
                                  return docDate.year == today.year &&
                                      docDate.month == today.month &&
                                      docDate.day == today.day;
                                }
                                return false;
                              }).length;

                          final newThisWeek =
                              docs.where((doc) {
                                final timestamp = doc['Timestamp'];
                                if (timestamp is Timestamp) {
                                  final docDate = timestamp.toDate();
                                  final today = DateTime.now();
                                  final startOfWeek = today.subtract(
                                    Duration(days: today.weekday - 1),
                                  );
                                  return docDate.isAfter(startOfWeek) &&
                                      docDate.isBefore(
                                        today.add(Duration(days: 1)),
                                      );
                                }
                                return false;
                              }).length;

                          final newThisMonth =
                              docs.where((doc) {
                                final timestamp = doc['Timestamp'];
                                if (timestamp is Timestamp) {
                                  final docDate = timestamp.toDate();
                                  final today = DateTime.now();
                                  return docDate.month == today.month &&
                                      docDate.year == today.year;
                                }
                                return false;
                              }).length;

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _summaryCard(
                                      "Total Students",
                                      totalStudents.toString(),
                                      Icons.people,
                                    ),
                                    SizedBox(width: 20),
                                    _summaryCard(
                                      "New Today",
                                      newToday.toString(),
                                      Icons.fiber_new,
                                    ),
                                    SizedBox(width: 20),
                                    _summaryCard(
                                      "New This Week",
                                      newThisWeek.toString(),
                                      Icons.date_range,
                                    ),
                                    SizedBox(width: 20),
                                    _summaryCard(
                                      "New This Month",
                                      newThisMonth.toString(),
                                      Icons.calendar_today,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                Expanded(
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 30.0,
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              "Photo",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              "Email",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          DataColumn(
                                            label: Text(
                                              "Location",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          DataColumn(
                                            label: Text(
                                              "Time Created",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows:
                                            docs.map((doc) {
                                              final data =
                                                  doc.data()
                                                      as Map<String, dynamic>;
                                              ImageProvider imageProvider;

                                              try {
                                                imageProvider =
                                                    data['SelfieBase64'] != null
                                                        ? MemoryImage(
                                                          base64Decode(
                                                            data['SelfieBase64'],
                                                          ),
                                                        )
                                                        : const AssetImage(
                                                          'assets/user.png',
                                                        );
                                              } catch (_) {
                                                imageProvider =
                                                    const AssetImage(
                                                      'assets/user.png',
                                                    );
                                              }

                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          imageProvider,
                                                      radius: 20,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(data['Name'] ?? ''),
                                                  ),
                                                  DataCell(
                                                    Text(data['Email'] ?? ''),
                                                  ),

                                                  DataCell(
                                                    Text(
                                                      data['Location'] ?? '',
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      (data['Timestamp'] !=
                                                              null)
                                                          ? (data['Timestamp']
                                                                  as Timestamp)
                                                              .toDate()
                                                              .toString()
                                                          : 'N/A',
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.deepPurple,
      child: Column(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text(
              "Dashboard",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.white),
            title: const Text(
              "Students",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
