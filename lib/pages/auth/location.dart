import 'package:flutter/material.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final List<String> _availableLocations = [
    'Surabaya',
    'Jakarta',
    'Bandung',
    'Yogyakarta',
    'Bali',
    'Medan',
    'Makassar',
  ];

  List<String> _filteredLocations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredLocations = _availableLocations;
  }

  void _filterLocations(String query) {
    setState(() {
      _searchQuery = query;
      _filteredLocations =
          _availableLocations
              .where((loc) => loc.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _selectLocation(String location) {
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterLocations,
              decoration: InputDecoration(
                hintText: 'Cari lokasi...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredLocations[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _selectLocation(_filteredLocations[index]),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A1A),
    );
  }
}
