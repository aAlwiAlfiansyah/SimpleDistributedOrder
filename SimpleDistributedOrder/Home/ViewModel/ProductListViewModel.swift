//
//  ProductListViewModel.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation
import SwiftData

class ProductListViewModel: ObservableObject {
  @Published var productList: [ProductItem] = [ProductItem]()
  @Published var selectedProductList: [ProductItem] = [ProductItem]()
  @Published var packageList: [ProductsPackage] = [ProductsPackage]()
  
  private let dataSource: ProductSwiftDataServiceProtocol
  
  init(dataSource: ProductSwiftDataServiceProtocol) {
    self.dataSource = dataSource
    self.productList = dataSource.fetchProductList()
    
    self.updateSelected()
  }
  
  func updateSelected() {
    self.selectedProductList = self.productList.filter({ item in
      item.selected
    })
  }
  
  func totalPrice() -> Double {
    let totalSelectedPrice = self.selectedProductList.reduce(0) { $0 + $1.price }
    let totalCourirCharge = self.packageList.count * 15
    
    return totalSelectedPrice + Double(totalCourirCharge)
  }
  
  func totalWeight() -> Int {
    return self.selectedProductList.reduce(0) { $0 + $1.weight }
  }
  
  func packagePrice(package: ProductsPackage) -> Double {
    return package.products.reduce(0) { $0 + $1.price }
  }
  
  func packageWeight(package: ProductsPackage) -> Int {
    return package.products.reduce(0) { $0 + $1.weight }
  }
  
  func updatePackageInfo(name: String, package: inout ProductsPackage) {
    package.name = name
    package.totalPrice = packagePrice(package: package)
    package.totalWeight = packageWeight(package: package)
    package.courierCharge = 15.0
  }
  
  func validateItemSelection() -> (Bool, String) {
    if self.selectedProductList.isEmpty {
      return (false, "Please select product(s) to place your order!")
    }
    
    var message = ""
    for (_, item) in self.selectedProductList.enumerated() {
      var itemMessage = ""
      if item.price <= 0 || item.price > 250 {
        itemMessage += "the price (\(String(format: "$%.02f", item.price))) is invalid; "
      }
      if item.weight <= 0 {
        itemMessage += "the weight (\(item.weight) g) is invalid; "
      }
      
      if itemMessage.count > 0 {
        message += "\(item.name) is invalid: \(itemMessage)\n"
      }
    }
    
    return (message.isEmpty, message)
  }
  
  func updatePackages() {
    self.packageList = generatePackages()
  }
  
  func generatePackages() -> [ProductsPackage] {
    var packages: [ProductsPackage] = []

    let courierCharge = 15.0
    let totalPrice = self.selectedProductList.reduce(0) { $0 + $1.price }
    let totalWeight = self.selectedProductList.reduce(0) { $0 + $1.weight }
    
    guard totalPrice > 250 else {
      let package = ProductsPackage(
        name: "Product Package",
        totalPrice: totalPrice,
        totalWeight: totalWeight,
        courierCharge: courierCharge,
        products: self.selectedProductList
      )
      packages.append(package)
      
      return packages
    }
    
    let estimatedNum = Int(ceil(totalPrice / 250.0)) + 1
    let estimatedAverageWeight = Int(ceil(Double(totalWeight / estimatedNum)))
    
    return distributeProductItems(producList: self.selectedProductList, priceConstraint: 250.0, weightConstraint: estimatedAverageWeight, groupCount: estimatedNum)
  }
  
  func distributeProductItems(producList: [ProductItem], priceConstraint: Double, weightConstraint: Int, groupCount: Int) -> [ProductsPackage] {
    var packages: [ProductsPackage] = []
    
    let sortedProductList = producList.sorted { a, b in
      if a.weight == b.weight {
          return a.price < b.price
      }
      return a.weight < b.weight
    }
    
    for _ in 0..<groupCount {
      let package = ProductsPackage()
      packages.append(package)
    }
    
    for item in sortedProductList {
      var bestGroupIndex: Int? = nil
      var minWeight: Int = Int.max
      
      for (index, package) in packages.enumerated() {
        if packageWeight(package: package) < minWeight && packageWeight(package: package) + item.weight < weightConstraint {
          if packagePrice(package: package) + item.price < priceConstraint {
            minWeight = packageWeight(package: package)
            bestGroupIndex = index
          }
        }
      }
      
      if let index = bestGroupIndex {
        packages[index].products.append(item)
      } else {
        let package = ProductsPackage()
        package.products.append(item)
        packages.append(package)
      }
    }
    
    for n in 1...packages.count {
      var package = packages[n - 1]
      updatePackageInfo(name: "Product Package \(n)", package: &package)
    }
    
    return packages
  }
}
