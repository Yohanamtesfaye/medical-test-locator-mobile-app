import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_test_locator/sample/dummy.dart';
import 'package:medical_test_locator/screens/locations/hospital_location.dart';
import 'package:medical_test_locator/uplaod/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  XFile? imagePicked;
  bool _isLoading = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _sendImageToApi(File file) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFFF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Medical Test Locator',
          style: TextStyle(
            color: Color(0xFF000000),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'images/L.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Content Overlay
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      'Find Nearby Medical Test Centers Easily',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00796B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Search for medical tests or scan your request paper',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          hintText: "Search here",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Upload and Scan Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(Icons.file_upload, "Upload Image", () async {
                          final picked = await MyImagePicker().pickFromGallery();
                          if (picked != null) {
                            setState(() => imagePicked = picked);
                            await _sendImageToApi(File(picked.path));
                          }
                        }),
                        const SizedBox(width: 15),
                        _buildActionButton(Icons.camera_alt, "Scan Image", () async {
                          final picked = await MyImagePicker().pickFromCamera();
                          if (picked != null) {
                            setState(() => imagePicked = picked);
                            await _sendImageToApi(File(picked.path));
                          }
                        }),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ],
            ),
            // Auto-sliding Image Carousel
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                itemCount: 2,
                itemBuilder: (context, index) {
                  List<String> images = ['images/L.jpeg', 'images/M.jpeg'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        images[index],
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index 
                        ? const Color(0xFF00796B) 
                        : Colors.grey.withOpacity(0.4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),
            // Most Searched Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
              "Most Searched",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00796B),
              ),
              ),
            ),
            const SizedBox(height: 15),
            // Test Categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
              List<Map<String, dynamic>> tests = [
                {"title": "X-Ray", "icon": Icons.medical_services},
                {"title": "CT-Scan", "icon": Icons.scanner},
                {"title": "MRI", "icon": Icons.medical_services},
                {"title": "Blood Test", "icon": Icons.bloodtype},
              ];
              return GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HospitalLocation()),
                );
                },
                child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(
                    tests[index]["icon"],
                    color: Color(0xFF00796B),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    tests[index]["title"],
                    style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    ),
                  ),
                  ],
                ),
                ),
              );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      onPressed: onTap,
    );
  }

  Widget _buildTestCard(String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HospitalLocation()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}