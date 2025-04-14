//
//  ProductItemViewModel.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation

class ProductItemViewModel: ObservableObject {
  @Published var item: ProductItem
  @Published var iconName: String
  
  init(item: ProductItem) {
    self.item = item
    
    self.iconName = ProductItemViewModel.getIconName(selected: item.selected)
  }
  
  func updateSelected() {
    self.item.selected.toggle()
    updateIconName()
  }
  
  func updateIconName() {
    self.iconName = ProductItemViewModel.getIconName(selected: self.item.selected)
  }
  
  func getPriceText() -> String {
    return String(format: "$%.02f", self.item.price)
  }
  
  func getWeightText() -> String {
    return "\(self.item.weight) g"
  }
  
  class func getIconName(selected: Bool) -> String {
    if selected {
      "checkmark.square.fill"
    } else {
      "square"
    }
  }
}
