import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iseey/GlobalFiles/AppColors.dart';
import 'package:iseey/Services/assets_constant.dart';

class fileImagePicker extends StatelessWidget {
  final String fileImage;
  final File? selectedImage;
  final Function() onTap;
  final String defaultImageUrl = 'https://example.com/default-image.jpg'; // Replace with your default image URL

  const fileImagePicker({
    super.key,
    required this.fileImage,
    required this.selectedImage,
    required this.onTap,
  });

  bool get isValidUrl {
    if (fileImage.isEmpty) return false;
    try {
      Uri.parse(fileImage);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 71.0,
              backgroundColor: AppColors.mainBackgroundColorOrange,
              child: _buildfileImage(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              AssetsConstant.editProfileImgIcon,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildfileImage() {
    // Priority 1: Selected image from device
    if (selectedImage != null) {
      return CircleAvatar(
        radius: 70.0,
        backgroundImage: FileImage(selectedImage!),
        backgroundColor: AppColors.mainBackgroundColorOrange,
      );
    }

    // Priority 2: Valid network image
    if (isValidUrl) {
      return CircleAvatar(
        radius: 70,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: fileImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => _buildDefaultAvatar(),
          ),
        ),
      );
    }

    // Priority 3: Default placeholder
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 70.0,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.asset(
          "assets/man-placeholder.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
