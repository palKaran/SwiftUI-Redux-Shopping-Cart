
# SwiftUI Redux Shopping Cart

A complete, production-ready Redux implementation in SwiftUI demonstrating modern state management patterns for iOS applications.

## 🎯 Overview

This project showcases a fully functional shopping cart application built with Redux architecture from scratch in SwiftUI. It demonstrates real-world patterns including user authentication, cart management, product browsing, and comprehensive error handling.

## ✨ Features

### Core Functionality
- 🛒 **Shopping Cart Management** - Add, remove, update quantities
- 🔐 **User Authentication** - Login/register with error handling
- 📱 **Product Catalog** - Browse, search, and filter products
- 💳 **Checkout Flow** - Complete order processing
- 🔄 **Real-time Updates** - Instant UI updates across tabs

### Production Features
- 🎯 **Type-Safe State Management** - Compile-time safety for all actions
- 🔀 **Middleware System** - Async operations, logging, analytics, persistence
- 💾 **Offline Persistence** - Automatic state saving and restoration
- ⚡ **Performance Optimized** - Efficient state updates and view rendering
- 🧪 **Mock Data System** - Complete mock implementation for development
- 🚨 **Error Handling** - Comprehensive error management with user feedback
- 📊 **Analytics Integration** - Action tracking and user behavior monitoring

## 🏗️ Architecture

### Redux Core
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Actions   │───▶│  Reducers   │───▶│    State    │
└─────────────┘    └─────────────┘    └─────────────┘
       ▲                                      │
       │                                      ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    Views    │◀───│ ViewStore   │◀───│    Store    │
└─────────────┘    └─────────────┘    └─────────────┘
```

### State Structure
```swift
AppState
├── UserState      // Authentication & user data
├── CartState      // Shopping cart items & checkout
├── ProductState   // Product catalog & search
└── UIState        // Navigation & user interface
```

### Middleware Pipeline
```
Action → Logging → Async → Analytics → Persistence → Reducer → New State
```

## 🚀 Quick Start

### Prerequisites
- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/SwiftUI-Redux-Shopping-Cart.git

# Navigate to project directory
cd SwiftUI-Redux-Shopping-Cart

# Open in Xcode
open "Shopping Cart.xcodeproj"

# Build and run
⌘ + R
```

### Mock Data Testing
The app includes comprehensive mock data for immediate testing:

```swift
// Test different user scenarios
Login Emails:
✅ user@example.com       // Successful login
❌ locked@example.com     // Account locked error
❌ error@example.com      // Server error simulation
❌ unverified@example.com // Unverified account

Password: Any 6+ characters
```

## 📚 Project Structure

```
Shopping Cart/
├── Shopping_CartApp.swift           # App entry point
├── StoreEnvironmentKey.swift        # SwiftUI environment setup
├── Actions/                         # Redux actions
│   ├── Action.swift                 # Base action protocol
│   ├── CartActions.swift           # Cart-related actions
│   ├── ProductActions.swift        # Product-related actions
│   ├── UIActions.swift             # UI-related actions
│   └── UserActions.swift           # User-related actions
├── Middleware/                      # Redux middleware
│   ├── AnalyticsMiddleware.swift   # User behavior tracking
│   ├── AsyncMiddleware.swift       # Async operation handling
│   ├── LoggingMiddleware.swift     # Action/state logging
│   ├── Middleware.swift            # Base middleware protocol
│   └── PersistenceMiddleware.swift # State persistence
├── Mocks/                          # Mock implementations
│   ├── MockAPIService.swift       # Mock API responses
│   ├── MockData.swift             # Sample data
│   └── StoreFactory.swift         # Store configuration
├── Models/                         # Data models
│   ├── CartItem.swift             # Shopping cart item
│   ├── Product.swift              # Product model
│   └── User.swift                 # User model
├── Reducer/                        # Redux reducers
│   ├── AppReducer.swift           # Main app reducer
│   ├── CartReducer.swift          # Cart state reducer
│   ├── ProductReducer.swift       # Product state reducer
│   ├── UIReducer.swift            # UI state reducer
│   └── UserReducer.swift          # User state reducer
├── Services/                       # External services
│   ├── APIService.swift           # Real API implementation
│   └── PersistenceService.swift   # Data persistence
├── State/                         # State definitions
│   ├── AppState.swift            # Main app state
│   ├── CartState.swift           # Cart state
│   ├── ProductState.swift        # Product state
│   ├── UIState.swift             # UI state
│   └── UserState.swift           # User state
├── Store/                         # Store implementation
│   ├── Store.swift               # Main Redux store
│   └── ViewStore.swift           # SwiftUI integration
└── Views/                        # SwiftUI views
    ├── Cart/                     # Shopping cart views
    ├── Components/               # Reusable components
    ├── Login/                    # Authentication views
    ├── ProductList/              # Product catalog views
    ├── Profile/                  # User profile views
    └── ContentView.swift         # Main app view
```

## 🧪 Key Implementation Details

### Type-Safe Actions
```swift
enum CartActions: CartAction {
    case addItem(productId: String, quantity: Int = 1)
    case removeItem(productId: String)
    case updateQuantity(productId: String, quantity: Int)
    case clearCart
    case initiateCheckout
}
```

### Pure Reducers
```swift
func cartReducer(state: CartState, action: any Action) -> CartState {
    var newState = state
    
    switch action {
    case let cartAction as CartActions:
        switch cartAction {
        case .addItem(let productId, let quantity):
            // Pure state transformation logic
        }
    }
    
    return newState
}
```

### Middleware Pattern
```swift
struct AsyncMiddleware: Middleware {
    func process(
        action: any Action,
        state: AppState,
        dispatch: @escaping (any Action) -> Void
    ) -> any Action {
        // Handle async operations
        return action
    }
}
```

### SwiftUI Integration
```swift
struct ProductListView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        List(store.state.products.items) { product in
            ProductRow(
                product: product,
                onAddToCart: {
                    store.dispatch(CartActions.addItem(productId: product.id))
                }
            )
        }
    }
}
```

## 🔧 Configuration

### Environment Setup
```swift
// For development with mock data
let store = StoreFactory.createMockStore(shouldSimulateErrors: false)

// For production with real API
let store = StoreFactory.createProductionStore()
```

### Middleware Configuration
```swift
let middleware: [any Middleware<AppState>] = [
    LoggingMiddleware(isEnabled: !isProduction),
    AsyncMiddleware(apiService: apiService),
    PersistenceMiddleware(),
    AnalyticsMiddleware()
]
```


### Manual Testing Scenarios
1. **Authentication Flow**
   - Login with valid/invalid credentials
   - Registration process
   - Logout functionality

2. **Shopping Cart**
   - Add products to cart
   - Update quantities
   - Remove items
   - Checkout process

3. **Error Handling**
   - Network failures
   - Invalid user input
   - Server errors

## 🔗 Related Resources

### Articles
- 📖 **[Building Redux from Scratch in SwiftUI](to be published)** - Comprehensive tutorial covering the concepts and implementation details

### Documentation
- 🏗️ Architecture Overview
- 🧪 Testing Guide
- 🔀 Middleware Development
- 🎯 Best Practices

### Example Implementations
- Basic Redux Usage
- Advanced Patterns
- Custom Middleware

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by Redux principles from the React ecosystem
- Built with modern SwiftUI patterns and best practices
- Designed for real-world iOS application development

## 📞 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/palkaran/SwiftUI-Redux-Shopping-Cart/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/palkaran/SwiftUI-Redux-Shopping-Cart/discussions)
- 📧 **Email**: karan.pal.edu@gmail.com

---

⭐ **Star this repository if it helped you build better SwiftUI apps with Redux!**
