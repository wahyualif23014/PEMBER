import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  String selectedCategory = 'Film';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> openMapSearch(String query) async {
    // Cari lokasi dengan kata kunci "bioskop" ditambah query
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('bioskop $query')}'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onSearch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    if (selectedCategory == 'Film') {
      // Sementara hanya print keyword film
      print('Mencari film dengan keyword: $query');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pencarian film untuk: $query (belum diimplementasi)')),
      );
    } else if (selectedCategory == 'Lokasi') {
      print('Mencari bioskop di lokasi: $query');
      try {
        await openMapSearch(query);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa membuka Maps: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(24),
          ),
          // child: DropdownButton<String>(
          //   dropdownColor: Colors.grey[900],
          //   value: selectedCategory,
          //   underline: Container(),
          //   iconEnabledColor: Colors.yellow,
          //   style: const TextStyle(color: Colors.white),
          //   items: const [
          //     DropdownMenuItem(value: 'Film', child: Text('Film')),
          //     DropdownMenuItem(value: 'Lokasi', child: Text('Lokasi')),
          //   ],
          //   onChanged: (value) {
          //     if (value != null) {
          //       setState(() {
          //         selectedCategory = value;
          //         _controller.clear();
          //       });
          //     }
          //   },
          // ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[900],
              hintText: selectedCategory == 'Film'
                  ? 'Search movie...'
                  : 'Search location.',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.yellow),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.yellow),
                onPressed: _onSearch,
              ),
            ),
            onSubmitted: (_) => _onSearch(),
          ),
        ),
      ],
    );
  }
}
