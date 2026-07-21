# Smart Expense Tracker

Smart Expense Tracker is a modern, professional Flutter application designed for seamless personal finance management. It provides users with a comprehensive suite of tools to track transactions, visualize spending patterns, convert currencies with live rates, and maintain complete control over their financial data with local persistence.

---

## 🚀 Features

- **Transaction Management**
  - Full CRUD operations (Add, Edit, Delete) for expenses and income.
  - Detailed transaction history with date-based grouping.
  - Search functionality by transaction title.
  - Advanced filtering by type, category, and date range.
  - Multi-criteria sorting (Newest, Oldest, Amount).

- **Dashboard & Analytics**
  - Real-time balance calculation.
  - Income and Expense summary cards.
  - Recent transactions overview for quick access.

- **Currency Converter**
  - Live exchange rates using Open Exchange Rates API.
  - Support for popular global currencies (USD, EUR, GBP, INR, etc.).
  - Instant conversion calculations.
  - Swap base and target currencies with one tap.

- **User Experience & UI**
  - Professional, responsive design with smooth transitions.
  - Theme switching (Light, Dark, and System Default).
  - Clean and intuitive navigation using Bottom Navigation Bar.
  - Interactive empty states and feedback animations.

- **Data & Persistence**
  - Secure local storage using Hive database.
  - Data persistence across app restarts.
  - Option to clear all data via settings.

---

## 📱 Screens

- **Dashboard**: High-level financial summary and recent activity.
- **Transaction List**: Searchable and filterable history of all records.
- **Add/Edit Transaction**: Specialized forms for data entry with validation.
- **Transaction Details**: In-depth view of a specific transaction.
- **Currency Converter**: Dedicated tool for live rate conversions.
- **Settings**: Appearance and data management controls.

---

## 🛠 Tech Stack

| Technology | Purpose |
|------------|----------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Riverpod** | Robust state management & dependency injection |
| **Hive** | Lightweight, blazing fast local NoSQL database |
| **Dio** | Efficient HTTP client for API communication |
| **Go Router** | Declarative routing and deep linking |
| **Intl** | Internationalization and formatting |
| **Google Fonts** | Modern typography |

---

## 🏗 Architecture

The project follows a **Feature-First Layered Architecture**, ensuring scalability, maintainability, and clear separation of concerns.

- **App Layer**: Contains application-level configuration, routing (`GoRouter`), and global theme definitions.
- **Features Layer**: Organized by domain (dashboard, transaction, currency, settings). Each feature contains its own:
  - **Screens**: UI layouts.
  - **Widgets**: Reusable components specific to the feature.
  - **Providers**: Business logic and state management.
- **Data Layer**: Handles data sourcing and mapping.
  - **Models**: Data structures and serialization.
  - **Repositories**: Abstracted data access logic.
  - **Local/Remote**: Hive implementation and API services.
- **Core Layer**: Shared utilities, constants, common widgets, and network clients used across the entire app.

---

## 📂 Folder Structure

```text
lib/
├── app/            # Global config, router, themes
├── core/           # Constants, utils, common widgets, services
├── data/           # Repositories, models, network, local storage
├── features/       # Feature-based modules
│   ├── dashboard/  # Balance & summary views
│   ├── transaction/# CRUD, filters, search
│   ├── currency/   # Live converter
│   └── settings/   # Theme & data management
└── main.dart       # Entry point
```

---

## 🔄 State Management

The application utilizes **Riverpod** for predictable and efficient state management:

- **Separation of Logic**: Business logic is decoupled from the UI using `StateNotifier` and `Provider`.
- **Reactive Updates**: The UI automatically rebuilds only when relevant state changes occur.
- **Dependency Injection**: Providers are used to inject repositories and services, making the code testable and modular.
- **Filtered States**: Complex logic (like transaction filtering) is computed via dedicated providers to keep screens clean.

---

## 📦 Local Storage

Local persistence is powered by **Hive**, providing a high-performance database experience:

- **Type Adapters**: Custom `TransactionAdapter` for seamless object storage.
- **Box Management**: Dedicated boxes for transactions and user settings.
- **Offline First**: All financial data is stored locally, ensuring the app is fully functional without an internet connection.

---

## 💱 Currency Conversion

The conversion module integrates with the **Opener API** (`https://open.er-api.com/`) to provide real-time financial data:

- **API Integration**: Uses `Dio` for optimized network calls.
- **Dynamic Rates**: Fetches the latest rates whenever a base currency is changed or refreshed.
- **Error Handling**: Graceful handling of network failures with retry capabilities.

---

## ✨ Project Highlights

- **Clean Architecture**: Strict separation of concerns for a scalable codebase.
- **Responsive UI**: Optimized for different screen sizes and orientations.
- **Local-First**: Fast performance and offline availability.
- **Professional Theming**: Polished Light and Dark modes with custom color palettes.
- **Reusable Components**: Highly modular widget system.

---

## 📦 Dependencies

From `pubspec.yaml`:

| Package | Version |
|---------|---------|
| flutter_riverpod | ^3.3.2 |
| hive_flutter | ^1.1.0 |
| dio | ^5.10.0 |
| go_router | ^17.3.0 |
| fl_chart | ^1.2.0 |
| intl | ^0.20.3 |
| uuid | ^4.6.0 |
| google_fonts | ^8.2.0 |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.12.2 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/Bunny-099/smart_expense_tracker.git
   ```
2. **Navigate to the project directory**
   ```bash
   cd smart_expense_tracker
   ```
3. **Install dependencies**
   ```bash
   flutter pub get
   ```
4. **Generate Hive Adapters (if modified)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. **Run the application**
   ```bash
   flutter run
   ```

---

## 📸 Screenshots

> Add application screenshots here to showcase the professional UI.

- **Dashboard**
- **Transactions**
- **Currency Converter**
- **Settings**

---

## 🔮 Future Improvements

- **Cloud Synchronization**: Sync data across multiple devices using Firebase/Supabase.
- **Advanced Analytics**: Implement spending trend charts and category-wise distribution using `fl_chart`.
- **Export Functionality**: Export transaction history to PDF or CSV formats.
- **Budgeting**: Set monthly budgets for specific categories with progress alerts.
- **Recurring Transactions**: Support for automated periodic records (e.g., subscriptions).

---

## 👨‍💻 Author

**Kushal Kant**
- **Role**: Flutter Developer
- **GitHub**: [@Bunny-099](https://github.com/Bunny-099)
- **Portfolio**: [kushal99.vercel.app](https://kushal99.vercel.app)

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
