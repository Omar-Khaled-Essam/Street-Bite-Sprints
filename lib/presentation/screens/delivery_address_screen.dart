import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  static const _initialLocation = LatLng(30.0444, 31.2357);

  late final TextEditingController address;
  late final TextEditingController apt;
  late final TextEditingController comment;
  LatLng _selectedLocation = _initialLocation;

  @override
  void initState() {
    super.initState();
    address = TextEditingController();
    apt = TextEditingController(text: '14');
    comment = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    if (address.text.isEmpty) {
      address.text = l10n.defaultAddressLabel;
    }
    if (comment.text.isEmpty) {
      comment.text = l10n.addMoreDetails;
    }
  }

  @override
  void dispose() {
    address.dispose();
    apt.dispose();
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.deliveryAddress,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 240,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _initialLocation,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('delivery-location'),
                        position: _selectedLocation,
                        draggable: true,
                        onDragEnd: _selectLocation,
                      ),
                    },
                    onTap: _selectLocation,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: IgnorePointer(
                        child: Chip(
                          label: Text(l10n.adjustPin),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.address),
          const SizedBox(height: 6),
          AppTextField(controller: address, hint: l10n.address),
          const SizedBox(height: 12),
          Text(l10n.apartment),
          const SizedBox(height: 6),
          AppTextField(controller: apt, hint: l10n.apartment),
          const SizedBox(height: 12),
          Text(l10n.comment),
          const SizedBox(height: 6),
          AppTextField(controller: comment, hint: l10n.addMoreDetails),
          const SizedBox(height: 20),
          PrimaryButton(
            label: l10n.save,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _selectLocation(LatLng location) {
    setState(() => _selectedLocation = location);
  }
}
