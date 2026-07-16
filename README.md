# 🛍️ Buyza — iOS E-Commerce App
> A premium, full-featured iOS shopping application built with SwiftUI, powered by Shopify, Firebase, and Google Gemini AI.
---
## 📱 Overview
**Buyza** is a production-ready iOS e-commerce application that delivers a seamless, end-to-end shopping experience — from browsing curated product collections to AI-assisted discovery, a full checkout flow, and real-time order tracking. Built with a clean, scalable architecture and a modern SwiftUI interface, Buyza demonstrates best practices in iOS development across networking, persistence, authentication, and AI integration.

---
## ✨ Features
### 🏠 Home
- Curated product feed with categories and brand collections
- Promotional ad banners for featured items
- Browse by **Men**, **Women**, **Kids**, and **Sale** categories
- Filter and explore products by brand (vendor)
### 🔍 Search
- Full-text product search across the Shopify catalog
- Real-time results with advanced filtering by price, type, and status
- `ProductFilterCriteria` model for composable, multi-parameter filtering
### 🤖 AI Shopping Assistant (Buyza AI)
- Powered by **Google Gemini** with a custom system prompt and personality
- Handles natural-language shopping queries in a conversational chat interface
- Security-hardened system prompt prevents exposure of API keys, tokens, or internal architecture
### 🛍️ Product Detail
- Rich product page with images, descriptions, size/variant selection
- Add to Cart and Add to Favorites actions
### 🛒 Cart
- Persistent cart powered by **CoreData** for offline support
- Item management: add, remove, and update quantities
- Real-time cart summary (subtotal, item count)
### ❤️ Favorites / Wishlist
- Save and manage favorite products
- Persisted globally via `FavoritesStore` environment object
### 💳 Payment & Checkout
- Multi-step checkout flow with Address selection/management
- Supports multiple payment methods:
  - **PayPal** (via a secure WKWebView integration)
  - **Paymob** (via a secure WKWebView integration)
  - Cash on Delivery
- Order pending and order success confirmation screens
### 📦 Orders
- Full order history with status tracking
- Detailed order view with item breakdown
### 👤 Authentication
- **Email/Password** sign-in and registration via Firebase Auth
- **Google Sign-In** integration
- **Guest Mode** — browse the app without creating an account
- **Forgot Password** flow with email reset
- Keychain-backed secure credential storage
### ⚙️ Settings and Profile
- Edit profile (display name, etc.)
- **Language Switching** — full multi-language support with RTL layout support
- Logout with confirmation
### 🌍 Localization
- Full localization system with a custom `LocalizationManager`
- Supports **RTL** (Right-to-Left) layout direction automatically
- Centralized `L10n` string keys for all UI text
### 🎬 Onboarding and Splash
- Beautiful splash screen with authentication state detection
- Smooth onboarding flow for first-time users (shown only once via `@AppStorage`)
---
## 🏗️ Architecture
Buyza follows **Clean Architecture** principles with a clear, three-layer separation of concerns:
```
Buyza App/
├── Domain/               # Business logic — pure Swift, no dependencies
│   ├── Models/           # UI models (Product, Order, Cart, User, etc.)
│   ├── Repo/             # Repository protocols (interfaces)
│   └── UseCase/          # Business use cases (one per feature)
│
├── Data/                 # Data layer — implements repository protocols
│
├── Presentation/         # UI Layer — SwiftUI Views + ViewModels (MVVM)
│
├── Services/             # Cross-cutting infrastructure
|
├── Router/               # App-level navigation state and routing
```

## 🔌 Integrations
### Shopify
- **Admin API** (`/admin/api/2026-01/`) — Products, Collections, Brands, Orders
- **Storefront API** (GraphQL) — Cart and Checkout mutations
- Storefront and Admin access tokens managed securely via `.xcconfig`
### Firebase
- **Firebase Auth** — Email/Password and Google Sign-In
- **Firestore** — User profile, order, and address persistence
- Configured via `GoogleService-Info.plist`
### Google Gemini AI
- Used for the in-app **Buyza AI** chat assistant
- Custom `GeminiConfig` with multi-section system prompt (Design, Layers, Agents)
- Registered function-calling tools for seamless in-app navigation
---
## 🚀 Getting Started
### Prerequisites
- iOS 16+ device or simulator
- Active Shopify store with Storefront and Admin API access
- Firebase project configured
- Google Gemini API key
### Installation
**1. Clone the repository**
```bash
git clone <repository-url>
cd "Buyza App"
```
**2. Set up secrets**
Create or update `Secrets.xcconfig` in the project root with your credentials:
```
SHOPIFY_STOREFRONT_TOKEN = your_storefront_access_token
SHOPIFY_ADMIN_TOKEN      = your_admin_access_token
GEMINI_API_KEY           = your_gemini_api_key
```
**3. Configure Firebase**
- Download your `GoogleService-Info.plist` from the Firebase console
- Place it inside `Buyza App/Services/`
**4. Open in Xcode**
```bash
open "Buyza App.xcodeproj"
```
**5. Build and Run**
- Select your target device or simulator
- Press `Cmd + R` to build and run
---

## 👥 Team
Built by **iOS Team 10** — a collaborative team of iOS developers.
