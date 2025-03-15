import 'package:flutter/material.dart';

// Dummy data for search
List<String> testCenters = [
  "Test Center 1 - MRI",
  "Test Center 2 - X-Ray",
  "Test Center 3 - Blood Test",
  "Test Center 4 - Ultrasound",
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Test Locator',
      theme: ThemeData(
        primaryColor: Colors.blue, // Blue color for theme
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green), // Green color for theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = testCenters; // Initially show all centers
  }

  // Search functionality
  void _search() {
    setState(() {
      _filteredData = testCenters
          .where((center) =>
              center.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Medical Test Locator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Logo and search bar section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _search(),
                        decoration: const InputDecoration(
                          hintText: 'Search here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_upload),
                      onPressed: () {
                        // Placeholder for OCR scanning
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Search results list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(_filteredData[index]),
                      onTap: () {
                        // Navigate to details page or show more information
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Placeholder for "PLACE ADD HERE" button
              ElevatedButton(
                onPressed: () {},
                child: const Text('PLACE ADD HERE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
