import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchLocationBar extends StatefulWidget {
  const SearchLocationBar({super.key});

  @override
  State<SearchLocationBar> createState() => _SearchLocationBarState();
}

class _SearchLocationBarState extends State<SearchLocationBar> {
  String location = 'Searching...';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      if (!serviceEnabled) {
        setState(() => location = 'GPS nonaktif');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
        if (permission == LocationPermission.denied) {
          setState(() => location = 'Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() => location = 'Izin lokasi ditolak permanen');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));
      if (!mounted) return;

      print("📍 Posisi: ${position.latitude}, ${position.longitude}");
      await _getAddressFromGoogleMaps(position.latitude, position.longitude);
    } catch (e) {
      print("❌ Error posisi: $e");
      if (!mounted) return;
      setState(() => location = 'Tidak bisa ambil posisi');
    }
  }

  Future<void> _getAddressFromGoogleMaps(double lat, double lng) async {
    const apiKey = 'AIzaSyBSnFXoupP46NbZ4FzIh5xFR1Z_4hvZDxo';
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'] as List;

          String? city;
          String? province;

          for (final c in components) {
            final types = List<String>.from(c['types']);
            if (types.contains('administrative_area_level_2')) {
              city = c['long_name'];
            }
            if (types.contains('administrative_area_level_1')) {
              province = c['long_name'];
            }
          }

          if (!mounted) return;
          if (city != null || province != null) {
            setState(
              () =>
                  location =
                      '${city ?? ''}${city != null && province != null ? ', ' : ''}${province ?? ''}',
            );
          } else {
            setState(() => location = 'Lokasi tidak ditemukan');
          }
        } else {
          setState(() => location = 'Lokasi tidak ditemukan');
        }
      } else {
        if (!mounted) return;
        print("❌ Error HTTP ${response.statusCode}");
        setState(() => location = 'Gagal ambil lokasi');
      }
    } catch (e) {
      print("❌ Error fetch alamat: $e");
      if (!mounted) return;
      setState(() => location = 'Gagal deteksi lokasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.yellow, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
