# Seconds.fi Mobile App

Seconds.fi is a Flutter-based mobile application that provides a user-friendly interface for managing digital assets and interacting with decentralized finance (DeFi) protocols.

## Project Overview

Seconds.fi aims to simplify the DeFi experience for users by offering the following features:

- Google Sign-In authentication
- Wallet management using Okto SDK
- Display of user balances and profits
- Access to various DeFi vaults for investment
- Integration with web-based DeFi protocols
- Lulo protocol integration for advanced DeFi functionalities

## Getting Started

### Prerequisites

- Flutter SDK (version 2.5.0 or later)
- Dart (version 2.14.0 or later)
- Android Studio or VS Code with Flutter extensions
- A Google Cloud Platform project with the Google Sign-In API enabled
- Okto SDK credentials
- Lulo API key

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/your-username/seconds-fi-app.git
   ```

2. Navigate to the project directory:

   ```
   cd seconds-fi-app
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Create a `.env` file in the root directory and add your API keys:

   ```
   OKTO_API_KEY=your_okto_api_key_here
   GOOGLE_CLIENT_ID=your_google_client_id_here
   ```

5. Run the app:
   ```
   flutter run
   ```

## Usage

1. **Authentication**: Users can sign in using their Google account.

2. **Home Screen**: Displays the user's balance, recent profits, and available vaults for investment.

3. **Vault Selection**: Users can select a vault to invest in by tapping on it.

4. **Web Integration**: The app includes a WebView that allows users to interact with web-based DeFi protocols. The user's wallet address is passed to the web interface for seamless integration.

5. **User Details**: Users can view their account details and wallet information.

## Project Structure

- `lib/`
  - `data/`: Data models and state management
  - `providers/`: State management providers
  - `screens/`: UI screens
  - `services/`: External service integrations
  - `theme/`: App theme and styling
  - `utils/`: Utility functions and constants

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- [Okto SDK](https://okto.tech/) for wallet management
- [Google Sign-In](https://developers.google.com/identity/sign-in/android) for authentication
- [Flutter](https://flutter.dev/) framework and community

## Support

For support, please open an issue in the GitHub repository or contact our support team at support@seconds.fi.
