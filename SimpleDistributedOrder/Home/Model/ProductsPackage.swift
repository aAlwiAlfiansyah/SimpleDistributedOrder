//
//  ProductsPackage.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation

class ProductsPackage {
  var name: String
  var totalPrice: Double
  var totalWeight: Int
  var courierCharge: Double
  var products: [ProductItem]
  
  init(name: String, totalPrice: Double, totalWeight: Int, courierCharge: Double, products: [ProductItem]) {
    self.name = name
    self.totalPrice = totalPrice
    self.totalWeight = totalWeight
    self.courierCharge = courierCharge
    self.products = products
  }
  
  init() {
    self.name = ""
    self.totalPrice = 0
    self.totalWeight = 0
    self.courierCharge = 0
    self.products = []
  }
}
