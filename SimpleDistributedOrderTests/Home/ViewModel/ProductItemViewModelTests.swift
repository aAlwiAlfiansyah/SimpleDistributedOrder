//
//  ProductItemViewModelTests.swift
//  SimpleDistributedOrderTests
//
//  Created by Alwi Alfiansyah Ramdan on 14/04/25.
//

import XCTest
import Quick
import Nimble
import Mockingbird

@testable import SimpleDistributedOrder

final class ProductItemViewModelTests: QuickSpec {
  override class func spec(){
    describe("ProductItemViewModel") {
      var item: ProductItem!
      var sut: ProductItemViewModel!
      
      beforeEach {
        item = ProductItem(name: "Item 1", weight: 20, price: 100.0)
        
        sut = ProductItemViewModel(item: item)
      }
      
      describe("init") {
        beforeEach {
          item.selected = false
          sut = ProductItemViewModel(item: item)
        }
        it("should setup icon name correctly") {
          expect(sut.iconName).to(equal("square"))
        }
      }
      
      describe("updateIconName") {
        it("should update icon name correctly") {
          item.selected = false
          sut.updateIconName()
          expect(sut.iconName).to(equal("square"))
          
          item.selected = true
          sut.updateIconName()
          expect(sut.iconName).to(equal("checkmark.square.fill"))
        }
      }
      
      describe("updateSelected") {
        beforeEach {
          item.selected = true
        }
        it("should update icon name correctly") {
          sut.updateSelected()
          expect(sut.iconName).to(equal("square"))
          
          sut.updateSelected()
          expect(sut.iconName).to(equal("checkmark.square.fill"))
        }
      }
      
      describe("getPriceText") {
        it("should return price string correctly") {
          expect(sut.getPriceText()).to(equal("$100.00"))
        }
      }
      
      describe("getWeightText") {
        it("should return weight string correctly") {
          expect(sut.getWeightText()).to(equal("20 g"))
        }
      }
      
      describe("getIconName") {
        it("should return icon name correctly") {
          expect(ProductItemViewModel.getIconName(selected: true)).to(equal("checkmark.square.fill"))
          expect(ProductItemViewModel.getIconName(selected: false)).to(equal("square"))
        }
      }
    }
  }
}
