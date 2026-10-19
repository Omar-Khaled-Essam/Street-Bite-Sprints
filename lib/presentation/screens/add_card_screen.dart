import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final number = TextEditingController();
  final name = TextEditingController();
  final exp = TextEditingController();
  final cvv = TextEditingController();
  final zip = TextEditingController();
  bool defaultMethod = false;

  @override
  void dispose() {
    number.dispose();
    name.dispose();
    exp.dispose();
    cvv.dispose();
    zip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              l10n.addCard,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            AppTextField(controller: number, hint: l10n.cardNumber, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            AppTextField(controller: name, hint: l10n.nameOnCard),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppTextField(controller: exp, hint: l10n.exp)),
                const SizedBox(width: 8),
                Expanded(child: AppTextField(controller: cvv, hint: l10n.cvv)),
                const SizedBox(width: 8),
                Expanded(child: AppTextField(controller: zip, hint: l10n.zip)),
              ],
            ),
            CheckboxListTile(
              value: defaultMethod,
              onChanged: (v) => setState(() => defaultMethod = v ?? false),
              title: Text(l10n.defaultPayment),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            PrimaryButton(
              label: l10n.continueLabel,
              onPressed: () => Navigator.pop(context, number.text),
            ),
          ],
        ),
      ),
    );
  }
}
