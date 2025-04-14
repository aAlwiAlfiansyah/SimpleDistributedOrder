//
//  ProductPackageViewModel.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation

class ProductPackageViewModel: ObservableObject {
  @Published var package: ProductsPackage
  
  init(package: ProductsPackage) {
    self.package = package
  }
  
  func getItemNames() -> String {
    var names = [String]()
    for item in self.package.products {
      names.append(item.name)
    }
    
    return names.joined(separator: ", ")
  }
}


extension ProductsPackage: Equatable {
  static func == (lhs: ProductsPackage, rhs: ProductsPackage) -> Bool {
    var isProductEqual = true
    if lhs.products.count != rhs.products.count {
      isProductEqual = false
    } else {
      let sortedLhsProducts = lhs.products.sorted { a, b in
        a.name < b.name
      }
      let sortedRhsProducts = rhs.products.sorted { a, b in
        a.name < b.name
      }
      for (i, _) in sortedLhsProducts.enumerated() {
        let itemLhs = sortedLhsProducts[i]
        let itemRhs = sortedRhsProducts[i]
        
        if itemLhs != itemRhs {
          isProductEqual = false
          break
        }
      }
    }
    
    return lhs.name == rhs.name &&
    lhs.totalPrice == rhs.totalPrice &&
    lhs.totalWeight == rhs.totalWeight &&
    lhs.courierCharge == rhs.courierCharge &&
    isProductEqual
  }
}

extension ProductItem: Equatable {
  static func == (lhs: ProductItem, rhs: ProductItem) -> Bool {
    return lhs.name == rhs.name &&
    lhs.selected == rhs.selected &&
    lhs.price == rhs.price &&
    lhs.weight == rhs.weight
  }
}

extension ProductsPackage: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(totalPrice)
    hasher.combine(totalWeight)
    hasher.combine(courierCharge)
    hasher.combine(products)
  }
}
