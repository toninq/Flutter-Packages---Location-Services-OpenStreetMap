import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/location_result.dart';

class MapPage extends StatelessWidget {
  final LocationResult locationResult;

  const MapPage({
    super.key,
    required this.locationResult,
  });

  @override
  Widget build(BuildContext context) {
    // กำหนดค่าพิกัดปัจจุบันจาก locationResult
    final currentPosition = LatLng(
      locationResult.latitude,
      locationResult.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('แผนที่ตำแหน่งปัจจุบัน'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: currentPosition, // กำหนดจุดศูนย์กลางแผนที่
          initialZoom: 16.0,              // กำหนดระดับการซูม
        ),
        children: [
          // ชั้นแสดงผลแผนที่จาก OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.my_location_explorer',
          ),
          // ชั้นสำหรับปักหมุด Marker
          MarkerLayer(
            markers: [
              Marker(
                point: currentPosition,
                width: 40.0,
                height: 40.0,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}