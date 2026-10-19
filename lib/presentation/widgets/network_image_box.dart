import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.radius = 16,
  });

  final String url;
  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
        ),
        errorWidget: (_, _, _) => Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
          child: const Icon(Icons.restaurant),
        ),
      ),
    );
  }
}
