import 'package:flutter/material.dart';

class PackageInfoPage extends StatelessWidget {
  const PackageInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ข้อมูล Package พร้อมกำหนด Icon และสีให้ดูสวยงาม
    final List<Map<String, dynamic>> packages = [
      {
        'name': 'location',
        'description': 'อ่านตำแหน่งและขอ Permission',
        'icon': Icons.my_location,
        'color': Colors.blue,
      },
      {
        'name': 'flutter_map',
        'description': 'แสดงแผนที่ด้วยระบบ OpenStreetMap',
        'icon': Icons.map,
        'color': Colors.green,
      },
      {
        'name': 'latlong2',
        'description': 'สร้าง Object ของพิกัด LatLng เพื่อใช้คำนวณ',
        'icon': Icons.pin_drop,
        'color': Colors.red,
      },
      {
        'name': 'intl',
        'description': 'จัดรูปแบบวันและเวลาให้สวยงาม',
        'icon': Icons.access_time,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Information'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100], // เปลี่ยนพื้นหลังให้สว่างเพื่อเน้น Card
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final pkg = packages[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: pkg['color'].withOpacity(0.15),
                child: Icon(pkg['icon'], color: pkg['color']),
              ),
              title: Text(
                pkg['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  pkg['description'],
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}