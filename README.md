# 🛒 Stream Cart Mobile

<div align="center">
  <img src="stream_cart_mobile/assets/icons/app_icon.png" alt="Stream Cart Logo" width="128" height="128">
  
  **A production‑ready microservices-based live commerce & e‑commerce Flutter application**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.7.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
  
</div>

---

## 📖 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Feature Matrix](#-feature-matrix)
- [🚀 Current Development Status](#-current-development-status-august-2025)
- [🛠️ Recent Updates](#-recent-updates-aug-2025)
- [🏗️ Architecture](#-architecture)
- [🔧 Tech Stack](#-tech-stack)
- [📱 Screenshots](#-screenshots)
- [🚀 Getting Started](#-getting-started)
- [🔨 Development](#-development)
- [🧪 Testing](#-testing)
- [📦 Build & Deploy](#-build--deploy)
- [🤝 Contributing](#-contributing)
- [📞 Support & Contact](#-support--contact)
- [📄 License](#-license)

---

## 🎯 Overview

**Stream Cart Mobile** is a production‑oriented live commerce + e‑commerce super‑app built with Flutter and powered by a microservices backend. It implements **Domain-Driven Design (DDD)** + **Clean Architecture**, enabling clear separation of concerns, scalability, testability, and rapid feature evolution.

> 🇻🇳 Tóm tắt: Ứng dụng thương mại điện tử & livestream với kiến trúc sạch (DDD, Clean Architecture) hỗ trợ giỏ hàng, đơn hàng, voucher, chat realtime, thông báo đẩy, livestream (LiveKit), SignalR, tìm kiếm, quản lý địa chỉ, biến thể sản phẩm, cửa hàng.

### 🎯 Core Value
- 🛒 **Unified Commerce**: Catalog, variants, vouchers, cart, checkout, orders
- 🎥 **Interactive Live Streaming**: LiveKit + realtime chat + pinned products
- 💬 **Real-time Chat & Notifications**: SignalR + Firebase Cloud Messaging
- ⚡ **Reactive UX**: BLoC state management & granular loading states
- 🔐 **Secure**: JWT auth, secure token storage, guarded APIs
- 🧩 **Extensible Domain Model**: Modular feature packages & use cases

### ✅ Current Status (Aug 2025)
- ✅ Home / Explore (products, categories, shops, banners)
- ✅ Authentication & Profile (JWT, secure storage)
- ✅ Product Variants, Cheapest Variant Resolution
- ✅ Cart (add / update / bulk select / preview / clear)
- ✅ Checkout Preview & Order Creation Flow (price breakdown)
- ✅ Order Management (status tabs, detail, timeline, reviews scaffold)
- ✅ Live Streaming (join, active streams, products, pinned items, messages)
- ✅ Real-time Chat (rooms, unread count, typing indicators)
- ✅ Notifications (list, mark read, unread counter, SignalR + FCM + local)
- ✅ Address Book (CRUD, default selection)
- ✅ Vouchers (shop vouchers apply / list)
- ✅ Search (products + search history service)
- ✅ Theming & Responsive Layout (Material 3 + Google Fonts)
- ✅ Push Notifications (foreground / background handlers)
- ✅ Dependency Injection (GetIt) & modular use cases
- 🚧 Payment Gateway Integration (stubbed payment method selection)
- 🚧 Stream Analytics / Insights
- 🚧 Advanced Recommendation Engine

---

## ✨ Feature Matrix

### 🛍️ Commerce Core
- Products & Categories (filter, search, variants, cheapest variant resolver)
- Shops (listing, product count per shop)
- Vouchers (list + apply at checkout preview)
- Cart (add/update/remove, multi‑select, preview order, bulk deletion)
- Checkout Preview (price breakdown, shipping, voucher, payment method select)
- Orders (tabbed status lists, detail, status timeline, price breakdown, review scaffold)
- Addresses (CRUD + default selection)

### 🎥 Live Streaming & Engagement
- Join active live streams (LiveKit join token connect)
- Products & pinned products per stream (debounced reload)
- Live stream chat (separate from standard chat domain)
- Viewer stats & real-time events pipeline

### 💬 Real-time Communication
- SignalR abstraction (chat + notifications + typing indicators)
- Chat Rooms (user/shop, load messages, search, unread counts)
- Typing indicators, join/leave events, reconnection strategy

### 🔔 Notifications
- FCM + local notifications (foreground / background / terminated)
- SignalR real-time push (new + updated notification merging)
- Pagination & filtering (type, read state), unread counter

### 👤 User & Auth
- JWT Login / Me endpoint, secure storage, automatic token hydration
- Role awareness (user / shop contexts prepared)
- Profile display & avatar

### 🧱 Architecture & Quality
- DDD Layers (Entities, Repositories, UseCases)
- Clean separation (data / domain / presentation)
- GetIt DI (ready for Injectable codegen)
- Consistent error & loading state modeling
- Modular BLoC per feature (auth, cart, chat, order items, notification, livestream, address, voucher, variants, etc.)

### 🔐 Security & Reliability
- Secure token storage (flutter_secure_storage)
- Graceful reconnection routines (SignalR, LiveKit probes)
- Defensive parsing & failure surfaces (Either / Failures)

### 🛠 Developer Experience
- Build runner ready (retrofit, json_serializable, hive, injectable)
- Search history service persisted locally
- Clear feature folder conventions

### 🚀 Backlog / Planned
- Payment gateway integration (online methods)
- Advanced analytics (viewer retention, conversion funnels)
- Recommendation / personalization engine
- In‑stream purchase overlay & scheduled pinning
- Moderation tools & reporting flows
- Multi-language i18n expansion

---

## 🚀 Current Development Status (August 2025)

### ✅ Recently Completed (Highlights)
1. Full cart lifecycle (bulk selection + preview + voucher application)
2. Order listing, detail, status timeline & price breakdown
3. Live streaming join/connect flow (LiveKit + join token handshake)
4. Real-time chat (typing, unread counts, reconnection, search)
5. Unified notifications (SignalR + FCM + local)
6. Product variants + cheapest variant / availability use cases
7. Shop vouchers & shop listing components
8. Address management & checkout integration

### 🔄 Active Work
- Payment gateway integration layer
- Stream analytics & engagement metrics

### 📋 Next (Planned)
1. Recommendation & personalization services
2. Advanced moderation & reporting in streams
3. Multi-language i18n expansion
4. Full test coverage ramp-up (unit + widget + integration)

---

## 🛠️ Recent Updates (Aug 2025)

### 🔧 Fixes
- Reconnection improvements (SignalR & LiveKit lifecycle aware)
- Debounced product reload in live streams (API efficiency)
- Notification pagination + unread counter sync issues resolved
- Variant price resolution & null safety hardening

### 🆕 Additions
- Order domain (detail, status timeline, review scaffold)
- Live stream chat + pinned products + viewer stats events
- Vouchers (list + apply) & address integration in checkout preview
- Bulk cart operations & selected items preview order path
- Search history persistence service
- Local + push notification orchestration service

### 🎨 UX Enhancements
- Consistent skeleton shimmer loading states
- Payment + status badge components
- Improved empty / error / retry states across lists
- Unified typography (Be Vietnam Pro via Google Fonts)

---

## 🏗️ Architecture

Stream Cart Mobile follows **Clean Architecture** + **DDD** with feature‑oriented modularity:

```
lib/
├── 🎯 core/                    # Config, constants, env, DI, routing, network, services
├── 📊 data/                    # Datasources (remote/local), models, repos impl
├── 🏢 domain/                  # Entities, repositories (contracts), use cases
└── 🎨 presentation/            # BLoCs, pages, widgets, themes
```

Additional Feature Domains Present:
- cart/, order_item/, notification/, chat/, livestream/, address/, voucher/, product_variants/, shop/, search/

### 🧩 Key Services
- `SignalRService` – unified hub connection & callbacks (chat, notifications)
- `LiveKitService` – media session, room events, probing & metrics
- `FirebaseNotificationService` – FCM + local notification orchestration
- `SearchHistoryService` – persistent recent searches

### 🔄 Real-time Flow
SignalR events → Bloc events → UI state updates (chat, notifications, typing, viewer stats)
LiveKit room events → LiveStreamBloc (participants, probing, pinned products sync)

### 🔗 API Integration Status (Live)
- ✅ Auth: `/api/auth/login`, `/api/auth/me`
- ✅ Categories: `/api/categorys`
- ✅ Products: `/api/products`, `/api/products/search`
- ✅ Product Variants: `/api/product-variants/*`
- ✅ Cart: `/api/cart/*`
- ✅ Orders: `/api/orders/*`
- ✅ Vouchers: `/api/vouchers/*`, `/api/shop-vouchers/*`
- ✅ Live Streams: `/api/livestreams/*` + LiveKit signaling
- ✅ Notifications: `/api/notifications/*` + SignalR hub
- ✅ Chat: `/api/chat/*` + SignalR hub
- ✅ Addresses: `/api/addresses/*`
- 🚧 Payments: (gateway integration pending)

---

## 🔧 Tech Stack

### 🎨 Framework
- **Flutter 3.7.2+**, **Dart 3.7.2+**

### 🏛️ State Management
- **flutter_bloc** (feature BLoCs) + **equatable**

### 🌐 Networking & Realtime
- **dio**, **retrofit**, **json_serializable**, **signalr_core**, **livekit_client**

### 💾 Storage
- **flutter_secure_storage**, **shared_preferences**, **hive / hive_flutter**

### 🔧 Dependency Injection
- **get_it** (ready for **injectable** code generation)

### 🛠 Codegen & Dev
- **build_runner**, **retrofit_generator**, **json_serializable**, **hive_generator**, **injectable_generator**

### 🔒 Security & Utils
- **crypto**, **flutter_dotenv**, **dartz**, **intl**

### 🎨 UI & Navigation
- Material 3, **Google Fonts (Be Vietnam Pro)**, **cached_network_image**, **shimmer**, **flutter_svg**, **flutter_slidable**
- Custom routing (`AppRouter` + observer)

### 🔔 Notifications & Messaging
- **firebase_core**, **firebase_messaging**, **flutter_local_notifications**

---

## 📱 Screenshots

<div align="center">
  <p><em>Screenshots (updated set incoming). The app currently features:</em></p>
  
  **🏠 Home** - Catalog + categories + banners + search<br>
  **👤 Profile** - Authenticated user info<br>
  **🛒 Cart & Checkout Preview** - Voucher + price breakdown<br>
  **📦 Orders** - Status tabs & detail timeline<br>
  **🎥 Live Stream** - Realtime video + chat + pinned products<br>
  **💬 Chat** - Realtime rooms & typing indicators<br>
  **🔔 Notifications** - Realtime + push hybrid<br>
  
  <p><em>Run on Web: <code>flutter run -d web</code></em></p>
</div>

---

## 🚀 Getting Started

### 📋 Prerequisites

Ensure you have:

- ✅ Flutter SDK 3.7.2+ (includes Dart)
- ✅ Android Studio or VS Code with Flutter extension
- ✅ Git
- ✅ Firebase project (for push notifications) – optional for core features

### 🔧 Installation

1. Clone repository
   ```bash
   git clone https://github.com/yourusername/stream-cart-mobile.git
   cd stream-cart-mobile/stream_cart_mobile
   ```
2. Install dependencies
   ```bash
   flutter pub get
   ```
3. (Optional) Create `.env`
   ```bash
   echo "API_BASE_URL=https://brightpa.me" > .env
   echo "ENVIRONMENT=development" >> .env
   ```
4. Run the app
   ```bash
   flutter run -d web
   # or
   flutter run
   ```

> Default API base points to production: `https://brightpa.me`.

### ⚙️ Environment (Optional)
```env
API_BASE_URL=https://brightpa.me
API_TIMEOUT=30000
ENVIRONMENT=development
ENABLE_DEBUG_LOGGING=true
```

**Core API (subset)**:
- Auth: `/api/auth/login`, `/api/auth/me`
- Catalog: `/api/products`, `/api/products/search`, `/api/categorys`
- Cart: `/api/cart/*` | Orders: `/api/orders/*` | Vouchers: `/api/vouchers/*`
- Live Streams, Chat & Notifications: REST + SignalR hubs + LiveKit server

**Auth Flow**: Provide valid backend credentials (no demo account bundled).

---

## 🔨 Development

### Run
```bash
flutter run -d web
flutter run            # auto device detection
flutter run -d android # specify platform
```

### Debug Options
```bash
flutter run --dart-define=ENVIRONMENT=development
```

### Code Generation
Run when adding retrofit APIs / json models / hive adapters / injectable config:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch
```

### Code Quality
```bash
flutter format .
flutter analyze
dart fix --apply
```

---

## 🧪 Testing

### Run Tests
```bash
flutter test
flutter test --coverage
```

### Structure (Planned Expansion)
```
test/
├── unit/          # Domain, use cases, blocs
├── widget/        # Widget tests (goldens planned)
└── integration/   # End-to-end flows
```

Current: Core flows manually tested; automated coverage ramp-up in progress.

---

## 📦 Build & Deploy

### Android
```bash
flutter build apk --release
flutter build appbundle --release
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/
```

### iOS (macOS only)
```bash
flutter build ios --release
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

### Desktop (Dev)
```bash
flutter run -d windows
```

### Deployment (High Level)
- Android: Sign, upload AAB to Play Console
- iOS: Archive in Xcode, distribute via App Store Connect
- Web: Host `/build/web` on static hosting / CDN

---

## 🤝 Contributing

1. Fork repository
2. Create feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. Implement & test
4. Ensure quality:
   ```bash
   flutter analyze
   flutter test
   flutter format .
   ```
5. Commit & push:
   ```bash
   git commit -m "feat: add amazing feature"
   git push origin feature/amazing-feature
   ```
6. Open Pull Request

### Standards
- Effective Dart style
- Tests for new logic (where reasonable)
- Clear commit messages (conventional preferred)

---

## 📞 Support & Contact

- 📧 Email: bolicious123@gmail.com
- 💬 Issues: [GitHub Issues](https://github.com/Dacoband/stream-cart-mobile/issues)
- 📖 Wiki: Project documentation (work in progress)
- 🌐 Demo: `flutter run -d web`

### 🎯 Project Status
- Stage: Active Development (Core Feature‑Complete)
- API: Production microservices connected
- Real-time Stack: SignalR + LiveKit + FCM operational
- Platforms: ✅ Web ✅ Android ✅ iOS ✅ Windows (dev)
- Last Updated: Aug 2025

---

## 📄 License

Licensed under the MIT License – see [LICENSE](LICENSE).

---

<div align="center">
  
  **Made with ❤️ using Flutter**
  
  **🔥 Core Features Production‑Ready**
  
  ⭐ Star this repo if it helps you!
  
  ---
  
  **Quick Start**: `git clone` → `cd stream_cart_mobile` → `flutter pub get` → `flutter run -d web`
  
</div>
