import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalLocation extends StatefulWidget {
  final List<String> testNames;

  const HospitalLocation({
    super.key,
    required this.testNames,
  });

  @override
  _HospitalLocationState createState() => _HospitalLocationState();
}

class _HospitalLocationState extends State<HospitalLocation> {
  bool _showLocationPrompt = false;
  bool _locationPermissionGranted = false;
  final Logger _logger = Logger();
  bool _isLoading = false;
  List<dynamic> hospitals = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchHospitals();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    
    if (status.isDenied) {
      setState(() {
        _showLocationPrompt = true;
        _locationPermissionGranted = false;
      });
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      setState(() {
        _showLocationPrompt = false;
        _locationPermissionGranted = false;
      });
    } else if (status.isGranted) {
      setState(() {
        _showLocationPrompt = false;
        _locationPermissionGranted = true;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _showLocationPrompt = false;
        _locationPermissionGranted = true;
      });
      _fetchHospitals();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Location permission is permanently denied. Please enable it from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchHospitals() async {
    if (!mounted || widget.testNames.isEmpty) return;

    if (!_locationPermissionGranted) {
      await _checkLocationPermission();
      if (!_locationPermissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required to find nearby hospitals')),
          );
        }
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final double userLat = location.latitude;
      final double userLon = location.longitude;
      final testsQuery = widget.testNames.join(',');
      _logger.i('Fetching hospitals with: $testsQuery');

      final url =
          'https://mtl-dez3.onrender.com/api/v1/institution/searchByTest?test=$testsQuery&userLat=$userLat&userLon=$userLon';

      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer <your_token>',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        _logger.i('Response data: $responseData');
        if (responseData is Map<String, dynamic> && responseData.containsKey('institutions')) {
          final institutions = responseData['institutions'];
          if (institutions is List) {
            setState(() {
              hospitals = institutions;
            });
          }
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch hospitals');
      }
    } catch (e) {
      _logger.e('Error fetching hospitals', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching hospitals: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Hospital Locations',
          style: GoogleFonts.poppins(
            color: const Color(0xFF00796B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          if (_showLocationPrompt)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.teal[50],
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enable location to find nearby medical centers',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _requestLocationPermission,
                    child: Text(
                      'Enable',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : hospitals.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: hospitals.length,
                        itemBuilder: (context, index) {
                          final center = hospitals[index];
                          return _DiagnosticCenterCard(
                            center: center,
                            testNames: widget.testNames,
                          );
                        },
                      )
                    : const Center(child: Text("No hospitals found")),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticCenterCard extends StatelessWidget {
  final Map<String, dynamic> center;
  final List<String> testNames;

  const _DiagnosticCenterCard({
    required this.center,
    required this.testNames,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            if (center['isCertified'] == true || center['certified'] == true)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ISO Certified',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: center['image'] != null
                  ? Image.network(
                    center['image'],
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                    )
                  : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.local_hospital, size: 50),
                    ),
                ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center['name'] ?? 'No Name',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00796B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.local_hospital, color: Colors.black87),
                            const SizedBox(width: 4),
                            Text(
                              'Hospital',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                          const Icon(Icons.phone, color: Colors.black87),
                          const SizedBox(width: 4),
                          Text(
                            center['contactInfo'] ?? 'No Phone Provided',
                            style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            ),
                          ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.black87),
                            const SizedBox(width: 4),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final mapLink = center['location'];
                                  if (mapLink != null && mapLink.isNotEmpty) {
                                    if (await canLaunchUrl(Uri.parse(mapLink))) {
                                      await launchUrl(
                                        Uri.parse(mapLink),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Could not open map link')),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Here',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                          final url = center['website'];
                          if (url != null && url.isNotEmpty) {
                            if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                            } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not launch website')),
                            );
                            }
                          }
                          },
                          child: Row(
                          children: [
                            const Icon(Icons.language, color: Colors.black87),
                            const SizedBox(width: 4),
                            Expanded(
                            child: Text(
                              center['website'] ?? 'No Website',
                              style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                              decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            ),
                          ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                            'Duration Time:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            ),
                            const SizedBox(height: 8),
                            ..._buildTestList(context),
                          ],
                          ),
                        ),
                        ],
                      ),
                      ),
                    ],
                    ),
                  ),
                  ],
                ),
                ),
    );
  }

  List<Widget> _buildTestList(BuildContext context) {
    final List<dynamic>? tests = center['tests'] as List<dynamic>?;
    if (tests == null || tests.isEmpty) {
      return [
        const Text(
          'No test information available',
          style: TextStyle(fontSize: 14),
        )
      ];
    }

    // Filter tests to only show those that match our testNames
    final filteredTests = tests.where((test) {
      return testNames.contains(test['name']);
    }).toList();

    if (filteredTests.isEmpty) {
      return [
        const Text(
          'Not Available',
          style: TextStyle(fontSize: 14),
        )
      ];
    }

    return filteredTests.map((test) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                test['name'] ?? 'Unknown Test',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Text(
              test['turnaroundTime']?.toString() ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: test['turnaroundTime'] == null ? Colors.grey : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}