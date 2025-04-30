# Loyalty Card Storage App

A Flutter-based mobile application that helps users manage their loyalty cards digitally. The app allows users to store, organize, and access their loyalty cards easily, with features like barcode scanning, QR code generation, and offline access.

## Features

- **Digital Card Storage**: Store all your loyalty cards in one place
- **Barcode Scanning**: Quickly add cards by scanning their barcodes
- **QR Code Generation**: Display card barcodes as QR codes for easy scanning at checkout
- **Offline Access**: Access your cards even without an internet connection
- **Cloud Sync**: Automatically syncs cards with cloud storage when online
- **Expiration Notifications**: Get notified when cards are about to expire
- **Reward Alerts**: Receive notifications for new rewards and offers
- **Secure Storage**: Encrypted storage for sensitive card information

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/loyalty-card-app.git
   ```

2. Navigate to the project directory:
   ```bash
   cd loyalty-card-app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # Business logic and services
├── providers/       # State management
├── utils/          # Utility functions
└── widgets/        # Reusable widgets
```

## Dependencies

- `sqflite`: Local database storage
- `provider`: State management
- `flutter_barcode_scanner`: Barcode scanning
- `qr_flutter`: QR code generation
- `flutter_local_notifications`: Local notifications
- `connectivity_plus`: Network connectivity
- `image_picker`: Image selection
- `flutter_secure_storage`: Secure storage
- `http`: API communication
- `timezone`: Timezone handling for notifications

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All the package authors for their contributions
- The open-source community for their support
