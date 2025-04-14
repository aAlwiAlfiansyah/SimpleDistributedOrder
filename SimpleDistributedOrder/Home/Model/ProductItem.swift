//
//  ProductItem.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation
import SwiftData

@Model
class ProductItem: Codable {
//class ProductItem {
  var name: String
  var weight: Int
  var price: Double
  var selected: Bool
  
  enum ProductItemKeys: CodingKey {
    case name, weight, price, selected
  }
  
  init(name: String, weight: Int, price: Double) {
    self.name = name
    self.weight = weight
    self.price = price
    self.selected = false
  }
  
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: ProductItemKeys.self)
    
    self.name = try values.decode(String.self, forKey: .name)
    self.weight = try values.decode(Int.self, forKey: .weight)
    self.price = try values.decode(Double.self, forKey: .price)
    self.selected = try values.decode(Bool.self, forKey: .selected)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ProductItemKeys.self)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.weight, forKey: .weight)
    try container.encode(self.price, forKey: .price)
    try container.encode(self.selected, forKey: .selected)
  }
}
