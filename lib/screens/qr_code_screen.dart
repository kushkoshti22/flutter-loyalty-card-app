import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/loyalty_card.dart';

class QRCodeScreen extends StatelessWidget {
  final LoyaltyCard card;

  const QRCodeScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${card.name} QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: card.barcode,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      card.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Card Number: ${card.cardNumber}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (card.expiryDate != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Expires: ${card.expiryDate.day}/${card.expiryDate.month}/${card.expiryDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement share functionality
              },
              icon: const Icon(Icons.share),
              label: const Text('Share QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
