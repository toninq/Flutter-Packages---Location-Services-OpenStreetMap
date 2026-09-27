import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'map_page.dart';
import 'package_info_page.dart';
import '../models/location_result.dart';
import '../services/location_service.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();

  LocationResult? _locationResult;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _loadLocation() async {
    // 1. setState ให้ _isLoading = true และล้าง _errorMessage
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 2. เรียก await _locationService.getCurrentLocation()
      final result = await _locationService.getCurrentLocation();
      
      // 3. ตรวจสอบ mounted ก่อน setState
      if (!mounted) return;

      // 4. เก็บผลลัพธ์ใน _locationResult
      setState(() {
        _locationResult = result;
      });
    } catch (e) {
      // 5. จัดการ Error ด้วย try-catch
      if (!mounted) return;
      setState(() {
        // ใช้ .toString() เพื่อดึงข้อความ Exception ออกมาแสดงผล
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      // 6. ใน finally ให้กำหนด _isLoading = false
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location Explorer'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadLocation,
            icon: const Icon(Icons.refresh),
          ),
          // --- ปุ่ม Information ---
          IconButton(
            tooltip: 'ข้อมูล Package', // แสดงข้อความเมื่อเอาเมาส์ชี้หรือกดค้าง
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PackageInfoPage(),
                ),
              );
            },
          ),
          // -------------------------------
        ],
      ),
      body: Center(
        child: buildContent(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _loadLocation,
        icon: const Icon(Icons.my_location),
        label: const Text('อ่านตำแหน่ง'),
      ),
    );
  }

  Widget buildContent() {
    // สถานะ Loading
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('กำลังอ่านตำแหน่ง...'),
        ],
      );
    }

    // สถานะ Error
    if (_errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadLocation,
            child: const Text('ลองใหม่'),
          ),
        ],
      );
    }

    // สถานะ Success
    // สถานะ Success
    if (_locationResult != null) {
      final formattedTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(_locationResult!.updatedAt);
      
      // 1. สร้าง Object พิกัดปัจจุบัน
      final currentPosition = LatLng(_locationResult!.latitude, _locationResult!.longitude);
      
      // 2. กำหนดพิกัดมหาวิทยาลัยเกษตรศาสตร์ วิทยาเขตศรีราชา
      final universityPosition = const LatLng(13.1180, 100.9242); 
      
      // 3. คำนวณระยะห่างด้วย Distance()
      final distanceInMeters = const Distance().as(
        LengthUnit.Meter,
        currentPosition,
        universityPosition,
      );

      // แปลงหน่วย
      String distanceText = distanceInMeters > 1000 
          ? '${(distanceInMeters / 1000).toStringAsFixed(2)} กม.' 
          : '$distanceInMeters เมตร';

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ส่วนที่ 1: การ์ดแสดงข้อมูลพิกัดและเวลา
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                      title: const Text('พิกัดปัจจุบัน', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        '${_locationResult!.latitude.toStringAsFixed(6)}, ${_locationResult!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade50,
                        child: const Icon(Icons.access_time, color: Colors.orange),
                      ),
                      title: const Text('อัปเดตล่าสุด', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      subtitle: Text(
                        formattedTime,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // ส่วนที่ 2: กล่องไฮไลต์แสดงระยะห่าง (Bonus C) แบบ Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.route, color: Colors.white, size: 36),
                  const SizedBox(height: 8),
                  const Text(
                    'ระยะห่างจาก ม.เกษตรฯ ศรีราชา',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    distanceText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // ส่วนที่ 3: ปุ่มเปิดแผนที่ขยายเต็มความกว้าง
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        locationResult: _locationResult!,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text('ดูบนแผนที่', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      );
    }

    // สถานะ Initial (ยังไม่มีการกดปุ่ม)
    return const Text('กดปุ่มเพื่ออ่านตำแหน่งปัจจุบัน');
  }
}