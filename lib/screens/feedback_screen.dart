import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:geocoding/geocoding.dart';
import '../widgets/feedback_form.dart';
import '../themes/colors.dart';
import '../services/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<Map<String, dynamic>> _imagesWithLocation = [];
  String _currentLocation = "Lokasi tidak tersedia";
  bool _isLocationEnabled = false;
  bool _isLoadingLocation = false;

  // Controllers for form data
  final GlobalKey<FeedbackFormState> _feedbackFormKey =
      GlobalKey<FeedbackFormState>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkAllPermissions();
    await _checkLocationStatus();
  }

  Future<void> _checkAllPermissions() async {
    try {
      // Cek permission kamera
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }

      var storageStatus = await Permission.storage.status;
      var photosStatus = await Permission.photos.status;

      if (!storageStatus.isGranted && !photosStatus.isGranted) {
        if (Platform.isAndroid) {
          await Permission.storage.request();
        } else {
          await Permission.photos.request();
        }
      }

      bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        await Gal.requestAccess(toAlbum: true);
      }
    } catch (e) {
      print('Error checking permissions: $e');
      _showErrorSnackBar('Error mengecek izin: $e');
    }
  }

  Future<void> _checkLocationStatus() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      setState(() {
        _isLocationEnabled =
            serviceEnabled &&
            (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse);
        _isLoadingLocation = false;
      });

      if (_isLocationEnabled) {
        _getCurrentLocation();
      }
    } catch (e) {
      print('Error checking location status: $e');
      setState(() {
        _isLoadingLocation = false;
        _isLocationEnabled = false;
      });
    }
  }

  // Meminta izin lokasi
  Future<bool> _requestLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationDialog(
          'Location Services Are Off',
          'Please enable GPS/Location in your device settings to continue.',
          () => Geolocator.openLocationSettings(),
        );
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationDialog(
            'Location Permission Denied',
            'The app needs location access to tag photos with GPS coordinates.',
            null,
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationDialog(
          'Location Permission Denied Forever',
          'Please enable location permission in the app settings to continue.',
          () => openAppSettings(),
        );
        return false;
      }

      return true;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  void _showLocationDialog(
    String title,
    String message,
    VoidCallback? onAction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardColor,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later', style: TextStyle(color: Colors.grey)),
            ),
            if (onAction != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAction();
                },
                child: Text(
                  'Open settings',
                  style: TextStyle(color: AppColors.accentColor),
                ),
              ),
          ],
        );
      },
    );
  }

  // Mendapatkan lokasi saat ini
  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocation =
              "${place.subLocality ?? ''} ${place.locality ?? ''}, ${place.administrativeArea ?? ''}"
                  .trim();
          if (_currentLocation.isEmpty) {
            _currentLocation =
                "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
          }
          _isLocationEnabled = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentLocation = "Location not available";
          _isLocationEnabled = false;
        });
      }
      print('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      // Cek permission kamera
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          _showErrorSnackBar('Camera permission is required to take photos');
          return;
        }
      }

      bool hasLocationPermission = await _requestLocationPermission();

      final ImagePicker picker = ImagePicker();

      try {
        final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          preferredCameraDevice: CameraDevice.rear,
        );

        if (photo != null) {
          await _showSaveToGalleryConfirmation(
            File(photo.path),
            isFromCamera: true,
          );
        }
      } catch (e) {
        print('Error taking photo: $e');
        _showErrorSnackBar('Gagal mengambil foto: ${e.toString()}');
      }
    } catch (e) {
      print('Error in _takePhoto: $e');
      _showErrorSnackBar('Error mengakses kamera: ${e.toString()}');
    }
  }

  // Memilih foto dari galeri
  Future<void> _pickImages() async {
    try {
      Map<Permission, PermissionStatus> statuses;

      if (Platform.isAndroid) {
        statuses =
            await [
              Permission.storage,
              Permission.photos,
              Permission.photosAddOnly,
              Permission.mediaLibrary,
              Permission.videos,
              Permission.audio,
              Permission.accessMediaLocation,
            ].request();
      } else {
        statuses = await [Permission.photos].request();
      }

      bool isGranted = statuses.entries.any((entry) => entry.value.isGranted);

      if (!isGranted) {
        _showErrorSnackBar('Izin diperlukan untuk memilih foto');
        return;
      }

      final ImagePicker picker = ImagePicker();
      final List<XFile>? pickedFiles = await picker.pickMultiImage(
        imageQuality: 85,
        limit: 10,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (XFile file in pickedFiles) {
          await _showSaveToGalleryConfirmation(
            File(file.path),
            isFromCamera: false,
          );
        }
      }
    } catch (e) {
      print('Error in _pickImages: $e');
      _showErrorSnackBar('Error mengakses galeri: ${e.toString()}');
    }
  }

  // pemlilihan iya atau tidak
  Future<void> _showSaveToGalleryConfirmation(
    File imageFile, {
    required bool isFromCamera,
  }) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardColor,
            title: const Text(
              'Simpan ke Galeri?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Do you want to save this image to gallery?\nIf not, the image will only be displayed in the app.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processImage(
                    imageFile,
                    isFromCamera: isFromCamera,
                    saveToGallery: false,
                  );
                },
                child: const Text('No', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processImage(
                    imageFile,
                    isFromCamera: isFromCamera,
                    saveToGallery: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                ),
                child: const Text(
                  'Yes, Save',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  // simpan di galeri atau tidak
  Future<void> _processImage(
    File imageFile, {
    required bool isFromCamera,
    required bool saveToGallery,
  }) async {
    try {
      if (!await imageFile.exists()) {
        _showErrorSnackBar('Image file not found');
        return;
      }

      Position? position;
      String locationText =
          isFromCamera ? "📍 Lokasi tidak tersedia" : "no location";

      if (isFromCamera && _isLocationEnabled) {
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5),
          );

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            locationText =
                "${place.subLocality ?? ''} ${place.locality ?? ''}, ${place.administrativeArea ?? ''}"
                    .trim();

            if (locationText.isEmpty) {
              locationText =
                  "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
            }

            locationText = "$locationText";
          }
        } catch (e) {
          print('Error getting photo location: $e');
          locationText = "Failed to get location";
        }
      }

      bool savedToGallery = false;
      String saveMessage = '';

      if (saveToGallery) {
        try {
          await Gal.putImage(imageFile.path, album: 'Feedback Photos');
          savedToGallery = true;
          saveMessage =
              isFromCamera
                  ? '📸 Image saved to album "Feedback Photos"\n$locationText'
                  : '✅ Image successfully added to album "Feedback Photos"';
          print('Successfully saved to custom album');
        } catch (customAlbumError) {
          print('Error saving to custom album: $customAlbumError');
          try {
            await Gal.putImage(imageFile.path);
            savedToGallery = true;
            saveMessage =
                isFromCamera
                    ? '📸 Image saved to default gallery\n$locationText'
                    : '✅ Image successfully added to gallery';
            print('Successfully saved to default gallery');
          } catch (defaultGalleryError) {
            print('Error saving to default gallery: $defaultGalleryError');
            savedToGallery = false;
            saveMessage =
                '⚠️ Failed to save to gallery, only displayed in app\n$locationText';
          }
        }
      } else {
        savedToGallery = false;
        saveMessage =
            '📁 Image only added to app (not saved to gallery)\n$locationText';
      }

      if (mounted) {
        setState(() {
          _imagesWithLocation.add({
            'file': imageFile,
            'location': locationText,
            'position': position,
            'timestamp': DateTime.now(),
            'savedToGallery': savedToGallery,
          });
        });

        Color snackBarColor =
            savedToGallery ? AppColors.accentColor : Colors.orange;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saveMessage),
            backgroundColor: snackBarColor,
            duration: const Duration(seconds: 4),
            action:
                !savedToGallery
                    ? SnackBarAction(
                      label: 'Retry',
                      textColor: Colors.white,
                      onPressed: () => _retryGallerySave(imageFile),
                    )
                    : null,
          ),
        );
      }
    } catch (mainError) {
      print('Critical error in _processImage: $mainError');
      try {
        if (mounted) {
          setState(() {
            _imagesWithLocation.add({
              'file': imageFile,
              'location': "Error: Failed to process",
              'position': null,
              'timestamp': DateTime.now(),
              'savedToGallery': false,
              'hasError': true,
            });
          });
        }
      } catch (stateError) {
        print('Error even adding to state: $stateError');
      }

      _showErrorSnackBar('Failed to process photo: ${mainError.toString()}');
    }
  }

  // Method helper untuk retry save ke galeri
  Future<void> _retryGallerySave(File imageFile) async {
    try {
      await Gal.putImage(imageFile.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully saved photo to gallery'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Still failed to save to gallery: ${e.toString()}');
    }
  }

  // Show eror
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $message'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // Method untuk menghapus foto dari daftar
  void _removeImage(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardColor,
            title: const Text(
              'Delete Photo',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Photo will be removed from feedback list (not removed from gallery)',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _imagesWithLocation.removeAt(index);
                  });
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  // send confirmation info with API integration
  void _showSendConfirmation() {
    // Get form data from the form widget
    final formData = _feedbackFormKey.currentState?.getFormData();

    if (formData == null) {
      _showErrorSnackBar('Please fill in the form data');
      return;
    }

    if (formData['title'].isEmpty || formData['description'].isEmpty) {
      _showErrorSnackBar('Please fill in title and description');
      return;
    }

    if (_imagesWithLocation.isEmpty) {
      _showErrorSnackBar('Please add at least one image');
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardColor,
            title: const Text(
              'Send Feedback',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${formData['title']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rating: ${formData['rating']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'number of images: ${_imagesWithLocation.length}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: $_currentLocation',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to send feedback to server',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _uploadFeedback(formData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  // Upload feedback using the service
  Future<void> _uploadFeedback(Map<String, dynamic> formData) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text(
                  'Uploading feedback...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
    );

    try {
      // Get the first image (you can modify this to handle multiple images)
      final firstImage = _imagesWithLocation.first;
      final imageFile = firstImage['file'] as File;
      final imageLocation = firstImage['location'] as String;

      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid;

      if (userId == null) {
        Navigator.pop(context);
        _showErrorSnackBar('User not logged in');
        return;
      }

      final success = await FeedbackService.uploadFeedback(
        userId: userId,
        title: formData['title'],
        desctiption: formData['description'],
        location: imageLocation,
        rating: formData['rating'].toString(),
        image: imageFile,
      );

      // Close loading dialog
      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Feedback sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);

        // Clear form and images after successful upload
        setState(() {
          _imagesWithLocation.clear();
        });
        _feedbackFormKey.currentState?.clearForm();
      } else {
        _showErrorSnackBar('Failed to upload feedback. Please try again.');
      }
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      _showErrorSnackBar('Error uploading feedback: ${e.toString()}');
    }
  }

  Widget _buildImageLocationInfo(Map<String, dynamic> imageData) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              imageData['location'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // desain
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: AppColors.cardColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Indikator status lokasi
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child:
                _isLoadingLocation
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : IconButton(
                      icon: Icon(
                        _isLocationEnabled
                            ? Icons.location_on
                            : Icons.location_off,
                        color: _isLocationEnabled ? Colors.green : Colors.red,
                      ),
                      onPressed: () async {
                        if (!_isLocationEnabled) {
                          await _requestLocationPermission();
                          _checkLocationStatus();
                        }
                      },
                      tooltip:
                          _isLocationEnabled
                              ? 'active location'
                              : 'activate location',
                    ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          if (_imagesWithLocation.isNotEmpty)
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 240,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.85,
                    autoPlay: false,
                  ),
                  items:
                      _imagesWithLocation.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> imageData = entry.value;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                imageData['file'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 240,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            // Info lokasi dan timestamp
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  _buildImageLocationInfo(imageData),
                                  if (imageData['timestamp'] != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '🕐 ${_formatDateTime(imageData['timestamp'])}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          const SizedBox(height: 24),
          // Judul
          const Text(
            "give your feedback",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FeedbackForm(key: _feedbackFormKey),
          ),
          const SizedBox(height: 160),
        ],
      ),

      // Floating Action Buttons
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Tombol Ambil Foto
                FloatingActionButton.extended(
                  heroTag: 'cameraBtn',
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Foto"),
                  backgroundColor: AppColors.cardColor,
                  foregroundColor: AppColors.accentColor,
                ),
                const SizedBox(height: 12),
                // Tombol Upload dari Galeri
                FloatingActionButton.extended(
                  heroTag: 'uploadBtn',
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Upload"),
                  backgroundColor: AppColors.cardColor,
                  foregroundColor: AppColors.accentColor,
                ),
                const SizedBox(height: 12),
                // Tombol Send
                FloatingActionButton.extended(
                  heroTag: 'sendBtn',
                  onPressed: () {
                    if (_imagesWithLocation.isNotEmpty) {
                      _showSendConfirmation();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please add at least one image first!"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                  backgroundColor: AppColors.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // format datetime
  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
