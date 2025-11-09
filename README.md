# 📱 Product Quote Builder

A professional Flutter application for creating and managing product/service quotations with real-time calculations and a clean, responsive interface.

## 🎯 Features

### Core Features
- ✅ **Client Information Management** - Store client name, address, and contact details
- ✅ **Dynamic Line Items** - Add/remove products or services with ease
- ✅ **Real-Time Calculations** - Automatic calculation of:
  - Per-item totals: `(rate - discount) × quantity + tax`
  - Subtotal (before tax)
  - Total tax
  - Grand total
- ✅ **Professional Quote Preview** - Print-ready invoice layout
- ✅ **Responsive Design** - Works seamlessly on mobile, tablet, and desktop
- ✅ **Quote Status Tracking** - Draft, Sent, Accepted status badges

### Technical Features
- 🏗️ **Clean Architecture** - Organized folder structure for scalability
- 🧠 **Riverpod State Management** - With code generation for type safety
- 🎨 **Material Design 3** - Modern, professional UI
- 📊 **Input Validation** - Number-only fields with proper formatting
- 💾 **Data Models** - Well-structured with JSON serialization support

## 🏗️ Project Structure

```
lib/
├── models/              # Data models and business logic
│   ├── client_info.dart
│   ├── quote_item.dart
│   └── quote.dart
├── providers/           # Riverpod state management
│   ├── quote_provider.dart
│   └── quote_provider.g.dart (generated)
├── screens/             # Full-page views
│   ├── quote_form_screen.dart
│   └── quote_preview_screen.dart
├── widgets/             # Reusable UI components
│   ├── client_info_section.dart
│   ├── quote_items_section.dart
│   ├── quote_item_row.dart
│   └── quote_totals_section.dart
├── utils/               # Helper functions and constants
│   ├── helpers.dart
│   └── theme.dart
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An Android/iOS device or emulator

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd productqoute
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run code generation** (for Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## 📸 Screenshots

### Quote Form Screen
- Enter client information
- Add multiple line items
- See calculations in real-time

### Quote Preview Screen
- Professional invoice layout
- Itemized table
- Total summary
- Print/share ready

*(Add screenshots here)*

## 🎓 Learning Highlights

This project demonstrates:
- **State Management** - Riverpod with code generation
- **Clean Architecture** - Separation of concerns
- **Responsive Design** - Adaptive layouts for different screen sizes
- **Form Handling** - Input validation and formatting
- **Navigation** - Screen transitions
- **Code Quality** - Human-readable comments and clean code principles

See [LEARNING_SUMMARY.md](LEARNING_SUMMARY.md) for detailed explanations!

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.10      # State management
  riverpod_annotation: ^2.3.3    # Code generation annotations
  intl: ^0.19.0                  # Number/date formatting
  pdf: ^3.10.7                   # PDF generation (bonus feature)

dev_dependencies:
  build_runner: ^2.4.8           # Code generation tool
  riverpod_generator: ^2.3.9     # Riverpod code generator
```

## 🎯 Assignment Requirements ✅

| Requirement | Status | Implementation |
|------------|--------|----------------|
| Client info input (name, address, reference) | ✅ | `ClientInfoSection` widget |
| Line items (product, qty, rate, discount, tax%) | ✅ | `QuoteItemRow` widget |
| Add/remove rows dynamically | ✅ | Provider methods |
| Per-item calculation | ✅ | `QuoteItem.itemTotal` getter |
| Quote subtotal and grand total | ✅ | `Quote` model getters |
| Responsive layout | ✅ | Adaptive layouts |
| Professional preview | ✅ | `QuotePreviewScreen` |

## 🔮 Future Enhancements

Potential features to add:
- [ ] Local storage (save/load quotes)
- [ ] PDF export functionality
- [ ] Email/share quotes
- [ ] Tax-inclusive/exclusive modes
- [ ] Multi-currency support
- [ ] Quote templates
- [ ] Search and filter quotes
- [ ] Dark mode theme

## 🛠️ Development

### Running in development
```bash
flutter run
```

### Running in release mode
```bash
flutter run --release
```

### Building APK
```bash
flutter build apk --release
```

### Re-generating Riverpod code
```bash
dart run build_runner watch
```
(This watches for changes and regenerates automatically)

## 📝 Code Quality

- ✅ Clean, readable code with meaningful variable names
- ✅ Human-like comments explaining WHY, not just WHAT
- ✅ Modular structure for easy maintenance
- ✅ Single Responsibility Principle
- ✅ DRY (Don't Repeat Yourself)
- ✅ Scalable architecture for future growth

## 🤝 Contributing

This is an assignment project, but suggestions are welcome!

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Author

Created as part of a company assignment to demonstrate Flutter development skills.

---

**Built with ❤️ using Flutter and Riverpod**

