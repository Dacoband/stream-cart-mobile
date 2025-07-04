# 🛒 Stream Cart Mobile

<div align="center">
  <img src="stream_cart_mobile/assets/icons/app_icon.png" alt="Stream Cart Logo" width="128" height="128">
  
  **A comprehensive microservices-based e-commerce platform designed for live streaming Stream Cart commerce**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.7.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
  
</div>

---

## 📖 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🔧 Tech Stack](#-tech-stack)
- [📱 Screenshots](#-screenshots)
- [🚀 Getting Started](#-getting-started)
- [🔨 Development](#-development)
- [🧪 Testing](#-testing)
- [📦 Build & Deploy](#-build--deploy)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🎯 Overview

**Stream Cart Mobile** is a cutting-edge e-commerce mobile application built with Flutter, designed specifically for live streaming commerce. The application follows **Domain-Driven Design (DDD)** principles with **Clean Architecture** patterns, ensuring scalability, maintainability, and testability.

### 🎯 Key Objectives
- 🛍️ **Live Shopping Experience**: Real-time shopping during live streams (Coming Soon)
- 📱 **Cross-Platform**: Native performance on iOS, Android, and Web
- 🏗️ **Scalable Architecture**: Microservices-based backend integration
- 🔒 **Secure**: JWT authentication and secure API communication
- 🎨 **Modern UI/UX**: Intuitive and engaging user interface

### ✅ **Current Status (July 2025)**
- ✅ **HomePage**: Complete with real API integration (Categories & Products)
- ✅ **ProfilePage**: User authentication and profile display
- ✅ **API Integration**: Connected to production backend APIs
- ✅ **State Management**: BLoC pattern implementation
- 🚧 **LiveStream**: UI ready, backend integration pending
- 🚧 **Shopping Cart**: UI components ready for backend integration

---

## ✨ Features

### 🛒 E-commerce Core (Implemented)
- ✅ **Product Catalog**: Browse products with real API data from `/api/products`
- ✅ **Category Navigation**: Dynamic categories from `/api/categorys`
- ✅ **Search Functionality**: Real-time product search
- ✅ **Product Display**: Name, price, stock quantity, and images
- � **Shopping Cart**: UI ready for backend integration
- 🚧 **Order Management**: Planned for next phase

### 📺 Live Streaming (UI Ready)
- 🚧 **Live Stream Interface**: UI components implemented
- 🚧 **Real-time Integration**: Backend APIs pending
- � **Interactive Features**: Chat and live shopping prepared
- � **Stream Analytics**: Framework ready for implementation

### 👤 User Management (Fully Implemented)
- ✅ **JWT Authentication**: Secure login/logout with token management
- ✅ **User Profile**: Real user data from `/api/auth/me`
- ✅ **Profile Display**: FullName, Email, Avatar, Verification status
- ✅ **Token Management**: Automatic token storage and retrieval
- ✅ **Session Handling**: Proper authentication flow

### 💾 Data & Storage (Implemented)
- ✅ **API Integration**: RESTful API calls with Dio
- ✅ **Local Storage**: Secure token storage with flutter_secure_storage
- ✅ **State Management**: BLoC pattern for predictable state
- ✅ **Error Handling**: Comprehensive error states and retry logic
- ✅ **Loading States**: Professional loading indicators

---

## 🚀 **Current Development Status (July 2025)**

### ✅ **Completed Features**
- **✅ HomePage**: Complete product catalog with real API integration
  - Dynamic categories from `/api/categorys`
  - Product grid from `/api/products` 
  - Search functionality with real-time API calls
  - Professional UI with loading states and error handling

- **✅ ProfilePage**: Full user authentication system
  - JWT token management with secure storage
  - Real user data from `/api/auth/me`
  - Login/logout flow with proper state management
  - Display: FullName, Email, Avatar, Verification status

- **✅ Core Architecture**: Clean Architecture implementation
  - BLoC state management for predictable UI states
  - Repository pattern with proper abstraction
  - Dependency injection with GetIt
  - Network layer with authentication interceptors

### 🚧 **In Progress**
- **LiveStream Interface**: UI components ready, backend integration pending
- **Shopping Cart**: Frontend structure prepared for API integration
- **Order Management**: Architecture planned, implementation upcoming

### 📋 **Next Development Phase**
1. Complete LiveStream real-time functionality
2. Shopping cart backend integration
3. Order management system
4. Payment gateway integration
5. Push notifications system

---

## 🛠️ **Recent Updates (July 5, 2025)**

### 🔧 **Critical Bug Fixes**
- **Token Management**: Fixed authentication token storage key mismatch
- **API Response Parsing**: Corrected category API response structure handling
- **UI Overflow**: Resolved category section layout issues on mobile devices

### 🆕 **New Features Added**
- **Real API Integration**: Connected to production backend at `https://brightpa.me`
- **Debug Logging**: Comprehensive logging system for API calls and state changes
- **Error Handling**: Professional error states with retry functionality
- **Loading States**: Smooth loading indicators across all screens

### 🎨 **UI/UX Improvements**
- **Responsive Design**: Optimized for mobile, tablet, and web platforms
- **Material Design 3**: Modern UI components with consistent theming
- **Professional Layout**: Production-ready interface design

---

## 🏗️ Architecture

Stream Cart Mobile follows **Clean Architecture** principles with **Domain-Driven Design (DDD)**:

```
lib/
├── 🎯 core/                    # Core utilities and configurations
│   ├── config/                # App configuration and environment
│   ├── constants/             # Global constants and API endpoints
│   ├── di/                    # Dependency injection setup (GetIt)
│   ├── error/                 # Error handling and failures
│   ├── network/               # Network layer with Auth interceptor
│   ├── routing/               # App routing with go_router
│   ├── services/              # Storage and HTTP services
│   └── utils/                 # Utility functions
├── 📊 data/                   # Data layer (Clean Architecture)
│   ├── datasources/           # API calls (Home, Profile, Auth)
│   ├── models/                # JSON models (Product, Category, User)
│   └── repositories/          # Repository implementations
├── 🏢 domain/                 # Domain layer (Business Logic)
│   ├── entities/              # Core entities (Product, Category, User)
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases (Get Products, etc.)
└── 🎨 presentation/           # Presentation layer (UI)
    ├── blocs/                 # BLoC state management (Home, Profile, Auth)
    ├── pages/                 # Screen widgets (Home, Profile, Login)
    └── widgets/               # Reusable UI components (SearchBar, ProductGrid)
```

### 📋 Architecture Principles

- **🎯 Separation of Concerns**: Each layer has a specific responsibility
- **🔄 Dependency Inversion**: Dependencies point inward to the domain
- **🧪 Testability**: Easy to unit test business logic
- **🔧 Maintainability**: Clean, organized, and scalable codebase
- **🚀 Performance**: Efficient state management and data flow

### 🔗 **API Integration Status**
- ✅ **Authentication**: `/api/auth/login`, `/api/auth/me`
- ✅ **Categories**: `/api/categorys` 
- ✅ **Products**: `/api/products`, `/api/products/search`
- 🚧 **Cart**: `/api/cart` (API ready, integration pending)
- 🚧 **Orders**: `/api/orders` (planned)
- 🚧 **LiveStream**: Backend APIs in development

---

## 🔧 Tech Stack

### 🎨 Frontend Framework
- **Flutter 3.7.2+** - Cross-platform mobile development
- **Dart 3.7.2+** - Programming language

### 🏛️ State Management
- **flutter_bloc 8.1.3** - Predictable state management
- **equatable 2.0.5** - Value equality for Dart objects

### 🌐 Networking & API
- **dio 5.3.2** - Powerful HTTP client with interceptors
- **retrofit 4.0.3** - Type-safe HTTP client generator
- **json_annotation 4.8.1** - JSON serialization annotations

### 💾 Local Storage
- **flutter_secure_storage 9.2.2** - Secure token storage
- **shared_preferences 2.3.2** - Simple persistent storage
- **hive 2.2.3** - Lightweight NoSQL database (future use)

### 🔧 Dependency Injection
- **get_it 7.6.4** - Service locator for dependency management
- **injectable 2.3.2** - Code generation for DI (planned)

### 🛠️ Development Tools
- **build_runner 2.4.12** - Code generation
- **json_serializable 6.8.0** - JSON serialization
- **flutter_launcher_icons 0.13.1** - App icon generation

### 🔒 Security & Utils
- **crypto 3.0.3** - Cryptographic functions
- **flutter_dotenv 5.2.1** - Environment variables
- **dartz 0.10.1** - Functional programming (Either, Option)
- **equatable 2.0.5** - Value equality for Dart objects

### 🎨 UI & Navigation  
- **go_router 12.1.3** - Declarative navigation
- **cached_network_image 3.3.0** - Image caching
- **flutter_svg 2.0.9** - SVG image support

---

## 📱 Screenshots

<div align="center">
  <p><em>Screenshots will be available soon. The app currently features:</em></p>
  
  **🏠 HomePage** - Product catalog with categories and search<br>
  **👤 ProfilePage** - User authentication and profile management<br>
  **🔐 LoginPage** - JWT authentication with secure token storage<br>
  **🎥 LivePage** - Live streaming interface (UI ready)<br>
  
  <p><em>Web version available at: <code>flutter run -d web</code></em></p>
</div>

---

## 🚀 Getting Started

### 📋 Prerequisites

Before you begin, ensure you have the following installed:

- ✅ **Flutter SDK 3.7.2+** - [Install Flutter](https://docs.flutter.dev/get-started/install)
- ✅ **Dart SDK 3.7.2+** - (Included with Flutter)
- ✅ **Android Studio** or **VS Code** with Flutter extensions
- ✅ **Git** - Version control

### 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/stream-cart-mobile.git
   cd stream-cart-mobile
   ```

2. **Navigate to the Flutter project directory**
   ```bash
   cd stream_cart_mobile
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Set up environment variables**
   ```bash
   # Create .env file with your API configuration
   # The app uses: https://brightpa.me as default API base URL
   echo "API_BASE_URL=https://brightpa.me" > .env
   echo "ENVIRONMENT=development" >> .env
   ```

5. **Run the application**
   ```bash
   # Run on web (recommended for development)
   flutter run -d web
   
   # Or run on mobile device/emulator
   flutter run
   ```

> **Note**: The app is currently configured to work with the production API at `https://brightpa.me`. No additional backend setup is required for testing the current features.

### ⚙️ Configuration

The app is pre-configured to work with the production API. If you need to customize:

**API Configuration** (Optional):
```env
# Create .env file in project root
API_BASE_URL=https://brightpa.me
API_VERSION=v1
API_TIMEOUT=30000
ENVIRONMENT=development

# Features
ENABLE_DEBUG_LOGGING=true
```

**Current API Endpoints**:
- **Authentication**: `POST /api/auth/login`, `GET /api/auth/me`
- **Categories**: `GET /api/categorys`
- **Products**: `GET /api/products`, `GET /api/products/search`

**Test Credentials** (for demo):
- The app includes a working authentication flow
- Real user data is displayed in ProfilePage after login

---

## 🔨 Development

### 🏃‍♂️ Running the App

#### Development Mode
```bash
# Run on web (best for development)
flutter run -d web

# Run on connected device/emulator  
flutter run

# Run with debug logging
flutter run --dart-define=ENVIRONMENT=development

# Hot reload (automatic with flutter run)
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
```

#### Platform-specific Commands
```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d web

# Desktop (Windows)
flutter run -d windows
```

### 🛠️ Code Generation

**Currently Not Required** - The app works without code generation. For future development:

```bash
# If you add new JSON models or dependency injection
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes (for active development)
flutter packages pub run build_runner watch
```

### 📏 Code Quality

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Fix analysis issues
dart fix --apply
```

---

## 🧪 Testing

### 🔬 Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### 📊 Test Structure

```
test/
├── unit/                  # Unit tests (planned)
│   ├── domain/           # Domain layer tests
│   ├── data/             # Data layer tests  
│   └── presentation/     # Presentation layer tests
├── widget/               # Widget tests (planned)
└── integration/          # Integration tests (planned)
```

**Current Status**: Basic app functionality tested manually. Comprehensive test suite planned for next development phase.

---

## 📦 Build & Deploy

### 🏗️ Building for Production

#### Android
```bash
# Build APK
flutter build apk --release

# Build AAB (recommended for Play Store)
flutter build appbundle --release

# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/
```

#### iOS
```bash
# Build for iOS (macOS only)
flutter build ios --release

# Build IPA
flutter build ipa --release
```

#### Web
```bash
# Build for web
flutter build web --release
```

### 🚀 Deployment

#### Android - Google Play Store
1. Generate signing key
2. Configure `android/app/build.gradle`
3. Upload to Google Play Console

#### iOS - App Store
1. Configure signing in Xcode
2. Archive and upload via Xcode or Transporter

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Run tests and ensure code quality**
   ```bash
   flutter test
   flutter analyze
   flutter format .
   ```
5. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### 📝 Coding Standards

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Write comprehensive tests for new features
- Document public APIs
- Use meaningful commit messages

---

## 📞 Support & Contact

- 📧 **Email**: bolicious123@gmail.com
- 💬 **Issues**: [GitHub Issues](https://github.com/Dacoband/stream-cart-mobile/issues)
- 📖 **Documentation**: [Project Wiki](https://github.com/Dacoband/stream-cart-mobile/wiki)
- 🌐 **Live Demo**: Run `flutter run -d web` to see the current implementation

### 🎯 **Project Status**
- **Development Stage**: Active Development
- **API Integration**: Production APIs connected
- **Platform Support**: ✅ Web, ✅ Android, ✅ iOS
- **Last Updated**: July 5, 2025

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  
  **Made with ❤️ using Flutter**
  
  **🔥 Ready for Production Testing**
  
  ⭐ Star this repo if you like it!
  
  ---
  
  **Quick Start**: `git clone` → `cd stream_cart_mobile` → `flutter run -d web`
  
</div>
