import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/vendors/vendor_catalog.dart';
import '../../domain/entities/vendor_entity.dart';

class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  VendorEntity? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final markers = VendorCatalog.nearby
        .map(
          (vendor) => Marker(
            markerId: MarkerId(vendor.id),
            position: LatLng(vendor.latitude, vendor.longitude),
            infoWindow: InfoWindow(
              title: vendor.name,
              snippet:
                  '${vendor.cuisine} · ${l10n.vendorRating(vendor.rating.toStringAsFixed(1))} · ${vendor.city}',
            ),
            onTap: () => setState(() => selected = vendor),
          ),
        )
        .toSet();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nearbyVendors)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357),
              zoom: 4.2,
            ),
            markers: markers,
            myLocationButtonEnabled: false,
          ),
          if (selected != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Card(
                child: ListTile(
                  title: Text(selected!.name),
                  subtitle: Text(
                    '${selected!.cuisine} · ${selected!.city} · ${selected!.rating}',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
