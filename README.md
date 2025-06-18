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
- 🛍️ **Live Shopping Experience**: Real-time shopping during live streams
- 📱 **Cross-Platform**: Native performance on iOS and Android
- 🏗️ **Scalable Architecture**: Microservices-based backend integration
- 🔒 **Secure**: End-to-end encryption and secure payment processing
- 🎨 **Modern UI/UX**: Intuitive and engaging user interface

---

## ✨ Features

### 🛒 E-commerce Core
- 🏪 Product catalog browsing
- 🛍️ Shopping cart management
- 💳 Secure payment processing
- 📦 Order tracking and history
- ⭐ Product reviews and ratings

### 📺 Live Streaming
- 🎥 Real-time live streaming integration
- 💬 Interactive chat during streams
- 🛒 Live shopping features
- 📊 Real-time analytics

### 👤 User Management
- 🔐 Secure authentication (JWT)
- 👤 User profile management
- 🔔 Push notifications
- 📍 Location-based services

### 💾 Data & Storage
- 🗄️ Local data caching (Hive)
- 🔄 Offline-first architecture
- 🔐 Secure local storage
- ☁️ Cloud synchronization

---

## 🏗️ Architecture

Stream Cart Mobile follows **Clean Architecture** principles with **Domain-Driven Design (DDD)**:

```
lib/
├── 🎯 core/                    # Core utilities and configurations
│   ├── config/                # App configuration and environment
│   ├── constants/             # Global constants
│   ├── di/                    # Dependency injection setup
│   ├── error/                 # Error handling and exceptions
│   ├── network/               # Network layer configuration
│   ├── routing/               # App routing configuration
│   ├── services/              # Core services
│   └── utils/                 # Utility functions
├── 📊 data/                   # Data layer (Clean Architecture)
│   ├── datasources/           # Local and remote data sources
│   ├── models/                # Data models and DTOs
│   └── repositories/          # Repository implementations
├── 🏢 domain/                 # Domain layer (Business Logic)
│   ├── entities/              # Domain entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases
└── 🎨 presentation/           # Presentation layer (UI)
    ├── blocs/                 # BLoC state management
    ├── pages/                 # Screen widgets
    └── widgets/               # Reusable UI components
```

### 📋 Architecture Principles

- **🎯 Separation of Concerns**: Each layer has a specific responsibility
- **🔄 Dependency Inversion**: Dependencies point inward to the domain
- **🧪 Testability**: Easy to unit test business logic
- **🔧 Maintainability**: Clean, organized, and scalable codebase
- **🚀 Performance**: Efficient state management and data flow

---

## 🔧 Tech Stack

### 🎨 Frontend Framework
- **Flutter 3.7.2+** - Cross-platform mobile development
- **Dart 3.7.2+** - Programming language

### 🏛️ State Management
- **flutter_bloc 8.1.3** - Predictable state management
- **equatable 2.0.5** - Value equality for Dart objects

### 🌐 Networking & API
- **dio 5.3.2** - Powerful HTTP client
- **retrofit 4.0.3** - Type-safe HTTP client generator

### 💾 Local Storage
- **hive 2.2.3** - Lightweight and fast NoSQL database
- **flutter_secure_storage 9.2.2** - Secure local storage
- **shared_preferences 2.3.2** - Simple persistent storage

### 🔧 Dependency Injection
- **get_it 7.6.4** - Service locator
- **injectable 2.3.2** - Code generation for DI

### 🛠️ Development Tools
- **build_runner 2.4.12** - Code generation
- **json_serializable 6.8.0** - JSON serialization
- **flutter_launcher_icons 0.13.1** - App icon generation

### 🔒 Security & Utils
- **crypto 3.0.3** - Cryptographic functions
- **flutter_dotenv 5.2.1** - Environment variables
- **dartz 0.10.1** - Functional programming utilities

---

## 📱 Screenshots

<div align="center">
  <img src="docs/screenshots/login.png" alt="Login Screen" width="200">
  <img src="docs/screenshots/home.png" alt="Home Screen" width="200">
  <img src="docs/screenshots/product.png" alt="Product Detail" width="200">
  <img src="docs/screenshots/cart.png" alt="Shopping Cart" width="200">
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
   # Copy the environment template
   cp .env.example .env
   
   # Edit .env with your configuration
   # nano .env
   ```

5. **Generate necessary files**
   ```bash
   # Generate code for models, DI, etc.
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

6. **Generate app icons**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

### ⚙️ Configuration

Create a `.env` file in the root directory with your configuration:

```env
# API Configuration
API_BASE_URL=https://your-api-endpoint.com
API_VERSION=v1
API_TIMEOUT=30000

# Environment
ENVIRONMENT=development

# Features
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

---

## 🔨 Development

### 🏃‍♂️ Running the App

#### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific environment
flutter run --dart-define=ENVIRONMENT=development

# Run with hot reload
flutter run --hot
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

When you modify models or add new dependencies:

```bash
# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# One-time generation
flutter packages pub run build_runner build --delete-conflicting-outputs
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
├── unit/                  # Unit tests
│   ├── domain/           # Domain layer tests
│   ├── data/             # Data layer tests
│   └── presentation/     # Presentation layer tests
├── widget/               # Widget tests
└── integration/          # Integration tests
```

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
- 💬 **Discord**: [Join our community](https://discord.gg/dacoband)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Dacoband/stream-cart-mobile/issues)
- 📖 **Documentation**: [Wiki](https://github.com/Dacoband/stream-cart-mobile/wiki)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  
  **Made with ❤️ using Flutter**
  
  ⭐ Star this repo if you like it!
  
</div>
