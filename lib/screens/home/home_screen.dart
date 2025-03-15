import 'package:flutter/material.dart';

// Dummy data 
IconData _getIcon(String iconName) {
  switch (iconName) {
    case "scanner":
      return Icons.scanner;
    case "broken_image":
      return Icons.broken_image;
    case "bloodtype":
      return Icons.bloodtype;
    case "monitor_heart":
      return Icons.monitor_heart;
    default:
      return Icons.medical_services;
  }
}

List<Map<String, dynamic>> testCenters = [
  {"name": "MRI", "icon": _getIcon("scanner"), "color": Colors.blue},
  {"name": "X-Ray", "icon": _getIcon("broken_image"), "color": Colors.green},
  {"name": "Blood Test", "icon": _getIcon("bloodtype"), "color": Colors.red},
  {"name": "Ultrasound", "icon": _getIcon("monitor_heart"), "color": Colors.purple},
];


// Dummy data for most visited hospitals
List<Map<String, dynamic>> mostVisitedHospitals = [
  {
    'name': 'Pawlos Hospital',
    'address': '123 Main St',
    'phone': '123-456-7890',
    'website': 'www.pawlos.com',
    'description': 'A leading hospital in the city.',
    'rating': 4.5,
  },
  {
    'name': 'Tikur Anbesa Hospital',
    'address': '456 Elm St',
    'phone': '987-654-3210',
    'website': 'www.tikuranbesa.com',
    'description': 'Providing quality healthcare for over 50 years.',
    'rating': 4.0,
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTestCenters = testCenters;
 List<Map<String, dynamic>> _filteredHospitals = mostVisitedHospitals;
 List<Map<String, dynamic>> _filteredData = testCenters;


  @override
  void initState() {
    super.initState();
    _filteredData = testCenters;
  }
void _search() {
  setState(() {
    _filteredTestCenters = testCenters
        .where((center) =>
            center["name"].toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    _filteredHospitals = mostVisitedHospitals
        .where((hospital) =>
            hospital["name"].toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    // Update _filteredData based on search results
    _filteredData = _filteredTestCenters;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text('Medical Test Locator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title
              const Text(
                'Find Nearby Medical Test Centers Easily',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _search(),
                        decoration: const InputDecoration(
                          hintText: 'Search test centers...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_upload, color: Colors.grey),
                      onPressed: () {
                        // Placeholder for OCR scanning
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: () {
                        // Placeholder for camera functionality
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Test Centers Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to details page or show more information
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      shadowColor: _filteredData[index]['color'].withOpacity(0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _filteredData[index]['icon'],
                            size: 50,
                            color: _filteredData[index]['color'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _filteredData[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Most Visited Hospitals Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Most Visited Hospitals',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mostVisitedHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = mostVisitedHospitals[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle hospital click
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hospital['name'] ?? 'Unknown Hospital',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  hospital['address'] ?? 'No address available',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Phone: ${hospital['phone']}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Website: ${hospital['website']}',
                                  style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  hospital['description'] ?? 'No description available',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < hospital['rating']
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.yellow[700],
                                      size: 20,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
