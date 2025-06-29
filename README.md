# MyCart - iOS E-commerce App

A modern iOS e-commerce application built with SwiftUI, MVVM architecture, and Combine framework. This app provides a complete shopping experience with product browsing, detailed product views, and cart management.

## 🚀 Features

- **Home Screen**: Product catalog with category filtering and search functionality
- **Product Details**: Detailed product information with add to cart functionality
- **Cart Management**: Persistent cart with quantity management and total calculation
- **Modern UI**: Clean, responsive design with custom tab bar
- **Real-time Search**: Debounced search with Combine
- **Offline Support**: Core Data persistence for cart items

## 🏗️ Architecture & Approach

### **MVVM + Combine Architecture**

The app follows the **Model-View-ViewModel (MVVM)** pattern enhanced with **Combine framework** for reactive programming:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│      View       │◄──►│   ViewModel      │◄──►│      Model      │
│   (SwiftUI)     │    │   (Combine)      │    │   (Core Data)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │   Services       │
                       │ (Network/Storage)│
                       └──────────────────┘
```

### **Key Architectural Decisions**

1. **Reactive Programming with Combine**
   - Debounced search (500ms delay)
   - Automatic UI updates through `@Published` properties
   - Proper memory management with `Set<AnyCancellable>`

2. **Separation of Concerns**
   - **ViewModels**: Business logic and state management
   - **Views**: Pure UI components
   - **Services**: Network and data persistence
   - **Models**: Data structures and Core Data entities

3. **Dependency Injection**
   - Singleton services for shared resources
   - Environment objects for navigation
   - Proper dependency management

### **Project Structure**

```
MyCart/
├── App/
│   ├── MyCartApp.swift          # App entry point
│   ├── BaseVM.swift             # Base ViewModel
│   └── ContentView.swift        # Root view
├── View+VM/
│   ├── Home/                    # Home screen
│   │   ├── HomeView.swift
│   │   └── HomeVM.swift
│   ├── ViewProduct/             # Product details
│   │   ├── ViewProductView.swift
│   │   └── ViewProductVM.swift
│   ├── Cart/                    # Cart management
│   │   ├── CartView.swift
│   │   └── CartVM.swift
│   ├── MainTab/                 # Tab navigation
│   │   └── TabBarView.swift
│   └── SharedComponents/        # Reusable components
├── Utilities/
│   ├── Models/                  # Data models
│   │   ├── ProductModel.swift
│   │   ├── CartModel.swift
│   │   └── UserModel.swift
│   ├── Services/
│   │   ├── Network/             # API services
│   │   │   ├── NetworkService.swift
│   │   │   └── AsyncAPIWrapper.swift
│   │   └── Storage/             # Data persistence
│   │       ├── CartDataManager.swift
│   │       ├── Persistence.swift
│   │       └── userDefaults.swift
│   ├── Extensions/              # Swift extensions
│   ├── Helpers/                 # Utility classes
│   ├── Validations/             # Input validation
│   ├── Navigations/             # Navigation logic
│   └── Resources/               # Assets and launch screen
└── Preview Content/             # SwiftUI previews
```

## 🛠️ Technical Implementation

### **Network Layer**
- **RESTful API**: Integration with FakeStoreAPI
- **Combine Publishers**: Reactive network calls
- **Error Handling**: Comprehensive error management
- **Caching**: URLSession with optimized configuration

### **Data Persistence**
- **Core Data**: Cart items and user preferences
- **UserDefaults**: App settings and authentication tokens
- **CRUD Operations**: Full cart management capabilities

### **UI/UX Features**
- **Custom Tab Bar**: Branded navigation
- **Search Functionality**: Real-time product search
- **Category Filtering**: Dynamic product filtering
- **Responsive Design**: Support for multiple screen sizes
- **Loading States**: Progress indicators and error handling

### **Dependencies**
```swift
// Network & Image Loading
Alamofire (5.10.2)           // HTTP networking
SDWebImageSwiftUI (3.1.3)    // Image caching and loading

// UI & Progress
RappleProgressHUD (4.1.0)    // Loading indicators

// Data Processing
SwiftyJSON (5.0.2)           // JSON parsing
```

## 📱 Screens & Functionality

### **1. Home Screen (`HomeView`)**
- Product grid with lazy loading
- Category filter tabs
- Search bar with debouncing
- Pull-to-refresh functionality
- Loading states and error handling

### **2. Product Details (`ViewProductView`)**
- Detailed product information
- Image gallery with SDWebImage
- Add to cart functionality
- Rating and review display
- Navigation to cart

### **3. Cart Screen (`CartView`)**
- Persistent cart items
- Quantity adjustment
- Total price calculation
- Remove items functionality
- Empty cart state

## ⚙️ Assumptions Made

### **Technical Assumptions**
1. **iOS 18.2+**: Minimum deployment target for modern SwiftUI features
2. **FakeStoreAPI**: Using external API for product data
3. **Core Data**: Local persistence for cart management
4. **Combine Framework**: Reactive programming for state management
5. **SwiftUI**: Modern declarative UI framework

### **Business Assumptions**
1. **Single User**: No multi-user authentication system
2. **Local Cart**: Cart persists only on device
3. **No Payment**: Focus on cart management, not checkout
4. **Offline Capable**: Basic offline functionality with cached data
5. **Simple Categories**: Basic product categorization

### **UI/UX Assumptions**
1. **Tab-based Navigation**: Simple 2-tab structure (Home/Cart)
2. **Search & Filter**: Basic search and category filtering
3. **Responsive Design**: Works on iPhone and iPad
4. **Loading States**: User feedback for async operations
5. **Error Handling**: Graceful error states

## ⏱️ Development Time

### **Total Time: 1 Day (8-10 hours)**

### **Breakdown:**
- **Project Setup & Architecture**: 1 hour
  - Xcode project creation
  - Folder structure setup
  - Dependencies integration

- **Core Infrastructure**: 2 hours
  - Network service implementation
  - Core Data setup
  - Base ViewModel creation
  - Navigation system

- **Home Screen**: 2.5 hours
  - Product grid layout
  - Search functionality
  - Category filtering
  - Combine integration

- **Product Details**: 1.5 hours
  - Detail view layout
  - Add to cart functionality
  - Image loading

- **Cart Management**: 2 hours
  - Cart UI implementation
  - Core Data integration
  - Quantity management
  - Total calculation

- **UI Polish & Testing**: 1 hour
  - Custom tab bar
  - Loading states
  - Error handling
  - Final testing

## 🚀 Getting Started

### **Prerequisites**
- Xcode 15.0+
- iOS 18.2+ deployment target
- Swift 5.0+

### **Installation**
1. Clone the repository
2. Open `MyCart.xcodeproj` in Xcode
3. Build and run the project
4. The app will automatically fetch products from FakeStoreAPI

### **Configuration**
- No additional configuration required
- App uses FakeStoreAPI for product data
- Cart data persists locally using Core Data

## 🔧 Customization

### **API Configuration**
Edit `NetworkService.swift` to change the base URL:
```swift
private let baseURL = "https://fakestoreapi.com"
```

### **UI Customization**
- Colors: Modify `Assets.xcassets/Colors/`
- Icons: Update `Assets.xcassets/Icons/`
- Launch Screen: Edit `Launch Screen.storyboard`

### **Features to Add**
- User authentication
- Payment integration
- Wishlist functionality
- Product reviews
- Push notifications
- Offline mode enhancement

## 📄 License

This project is created for demonstration purposes. Feel free to use and modify as needed.

## 👨‍💻 Developer

**Dilshan Thalagahapitiya**
- Created: June 29, 2025
- Architecture: MVVM + Combine
- Framework: SwiftUI
- Language: Swift 5.0


