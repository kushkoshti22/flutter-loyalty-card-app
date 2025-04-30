import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../models/loyalty_card.dart';
import '../providers/loyalty_card_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (barcode != '-1') {
        setState(() {
          _barcodeController.text = barcode;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to scan barcode')));
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final card = LoyaltyCard(
        name: _nameController.text,
        cardNumber: _cardNumberController.text,
        barcode: _barcodeController.text,
        expiryDate: _expiryDate,
        notes: _notesController.text,
        imagePath: _imagePath,
      );

      try {
        await Provider.of<LoyaltyCardProvider>(
          context,
          listen: false,
        ).addCard(card);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to save card')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Loyalty Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Card Name',
                  hintText: 'e.g., Starbucks Rewards',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'e.g., 1234567890',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                        hintText: 'Scan or enter barcode',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter or scan a barcode';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _scanBarcode,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Expiry Date'),
                subtitle: Text(
                  '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add any additional information',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add Card Image'),
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 16),
                Image.asset(_imagePath!, height: 200, fit: BoxFit.cover),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCard,
                child: const Text('Save Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
