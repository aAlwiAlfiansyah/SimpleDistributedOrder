# 📦 SimpleDistributedOrder
A simple SwiftUI-based app that allows users to select products, auto-package them under business constraints (price and weight), and calculate courier charges.

---

## 🚀 Features
- Select product items from a list
- Grouped the selected product items into packages upon placing order

---

## 🚀 Specification
- If total price of selected items is less than or equal to $250, all items should be placed into a single package
- If total price exceeds $250 automatically group into packages:
  - No package has a total price equal to or exceeding $250
  - The total weight of the items should be evenly distributed across packages
- Each package incurs a fixed courier charge of $15

---

## 🛠 Instructions to Run the Application

### 📱 Requirements
- Xcode 15.1 or newer
- iOS 17+ simulator or device
- SwiftUI support

### ▶️ Run in Simulator
1. Clone this repository
```bash
git clone https://github.com/alwialfiansyah/SimpleDistributedOrder.git
cd SimpleDistributedOrder
```

2. Open the project in Xcode
```bash
open SimpleDistributedOrder.xcodeproj
```

3. Select a simulator (e.g. iPhone 17)
4. Click **Run** ▶️ or press **Cmd + R**

### 📲 Run on Real Device
1. Plug in your iPhone
2. Select your device in the Xcode target bar
3. Make sure your Apple Developer Account is configured in Xcode (Preferences → Accounts)
4. Click **Run** ▶️

---

## 🧪 Testing
- Unit tests are provided for the business logic in `SimpleDistributedOrderTests`
- Run tests via the **Product → Test** menu or `Cmd + U`

---
