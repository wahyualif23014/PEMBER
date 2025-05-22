import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SearchLocationBar extends StatefulWidget {
  const SearchLocationBar({super.key});

  @override
  State<SearchLocationBar> createState() => _SearchLocationBarState();
}

class _SearchLocationBarState extends State<SearchLocationBar> {
  String location = 'Surabaya'; 

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool shouldOpenSettings = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Aktifkan GPS'),
              content: const Text(
                  'GPS Anda sedang nonaktif. Mohon aktifkan GPS untuk mendapatkan lokasi.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Buka Pengaturan'),
                ),
              ],
            ),
          ) ??
          false;

      if (shouldOpenSettings) {
        await Geolocator.openLocationSettings();
        // Tunggu sejenak lalu cek ulang
        await Future.delayed(const Duration(seconds: 2));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          setState(() {
            location = 'GPS masih nonaktif';
          });
          return;
        }
      } else {
        setState(() {
          location = 'GPS nonaktif';
        });
        return;
      }
    }

    // Cek permission lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = 'Izin lokasi ditolak';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = 'Izin lokasi ditolak permanen';
      });
      return;
    }

    // Ambil posisi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        location = place.locality ?? 'Lokasi tidak diketahui';
      });
    } else {
      setState(() {
        location = 'Lokasi tidak diketahui';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.yellow, size: 16),
        const SizedBox(width: 4),
        Text(
          location,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
