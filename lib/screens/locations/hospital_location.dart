import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HospitalLocation extends StatelessWidget {
  HospitalLocation({super.key});

  final List<Map<String, dynamic>> diagnosticCenters = [
    {
      'name': 'ABC Diagnostics',
      'phone': '+123 456 7890',
      'website': 'www.abc.com',
      'hours': 'Mon-Sat: 8 AM - 6 PM\nSun: Closed',
      'duration': 'Test Duration: 2 Hours',
      'image': 'images/M.jpeg',
      'isCertified': true,
    },
    {
      'name': 'XYZ Medical Labs',
      'phone': '+987 654 3210',
      'website': 'www.xyzmed.com',
      'hours': 'Mon-Fri: 7 AM - 8 PM\nSat-Sun: 9 AM - 4 PM',
      'duration': 'Test Duration: 1.5 Hours',
      'image': 'images/L.jpeg',
      'isCertified': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Diagnostic Centers',
          style: GoogleFonts.poppins(
            color: const Color(0xFF00796B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diagnosticCenters.length,
        itemBuilder: (context, index) {
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
                  if (diagnosticCenters[index]['isCertified'] == true)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            diagnosticCenters[index]['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  diagnosticCenters[index]['name'],
                                  style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00796B),
                                  ),
                                ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                diagnosticCenters[index]['phone'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                diagnosticCenters[index]['website'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      diagnosticCenters[index]['hours'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      diagnosticCenters[index]['duration'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
