import 'package:bitrate_realm/config/assets_paths.dart';
import 'package:flutter/material.dart';

class SquareImage extends StatelessWidget {
  const SquareImage({
    Key? key,
    required this.photoLink,
    this.placeholderLink,
    this.radius = 5,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String? photoLink, placeholderLink;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: photoLink!=null
              ? Image.network(
            photoLink!,
            fit: BoxFit.cover, // Ensures the image covers the area without exceeding
            loadingBuilder: (context, child, loadingProgress) {
              // Show a loading widget while the image is loading
              if (loadingProgress == null) {
                return child; // Image is fully loaded
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Show an error widget if the image fails to load
              return Image.asset(AssetsPaths.avatarPlaceholder, fit: BoxFit.cover);
            },
          )
              : Image.asset(placeholderLink ?? AssetsPaths.avatarPlaceholder, fit: BoxFit.cover,)
        ),
      ),
    );
  }
}
