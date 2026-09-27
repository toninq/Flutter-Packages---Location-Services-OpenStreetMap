import 'package:location/location.dart';
import '../models/location_result.dart';

class LocationService {
  final Location location = Location();

  Future<LocationResult> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // TODO 1: ตรวจสอบว่า Location Service เปิดอยู่หรือไม่
    // หากปิดอยู่ ให้ขอเปิดด้วย requestService()
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      // หากผู้ใช้ไม่เปิด ให้ throw Exception
      if (!serviceEnabled) {
        throw Exception('กรุณาเปิดบริการ Location (GPS) ในการตั้งค่าของอุปกรณ์ก่อนใช้งาน');
      }
    }

    // TODO 2: ตรวจสอบ Permission ด้วย hasPermission()
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // หากยังไม่ได้รับอนุญาต ให้เรียก requestPermission()
      permissionGranted = await location.requestPermission();
      
      // TODO 3: หาก Permission ถูกปฏิเสธ ให้ throw Exception
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('แอปไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง กรุณากดยอมรับเพื่อใช้งานแผนที่');
      }
    }

    // TODO 4: เรียก getLocation() เพื่ออ่านข้อมูลตำแหน่ง
    final locationData = await location.getLocation();

    // TODO 5: ตรวจสอบ latitude และ longitude ว่าไม่เป็น null
    if (locationData.latitude == null || locationData.longitude == null) {
      throw Exception('ไม่สามารถอ่านข้อมูลพิกัด Latitude และ Longitude ได้');
    }

    // TODO 6: คืนค่า LocationResult
    return LocationResult(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
      updatedAt: DateTime.now(),
    );
  }
}