//
//  ProductPackageViewModelTests.swift
//  SimpleDistributedOrderTests
//
//  Created by Alwi Alfiansyah Ramdan on 14/04/25.
//

import XCTest
import Quick
import Nimble
import Mockingbird

@testable import SimpleDistributedOrder

final class ProductPackageViewModelTests: QuickSpec {
  override class func spec(){
    describe("ProductPackageViewModel") {
      var name: String!
      var price: Double!
      var weight: Int!
      var courirCharge: Double!
      
      var items: [ProductItem]!
      var package: ProductsPackage!
      var sut: ProductPackageViewModel!
      
      beforeEach {
        name = "Product Package"
        price = 130.0
        weight = 245
        courirCharge = 15.0
        items = [
          ProductItem(name: "Item 1", weight: 20, price: 100),
          ProductItem(name: "Item 2", weight: 200, price: 20),
          ProductItem(name: "Item 3", weight: 25, price: 10)
        ]
        
        package = ProductsPackage(name: name, totalPrice: price, totalWeight: weight, courierCharge: courirCharge, products: items)
        sut = ProductPackageViewModel(package: package)
      }
      
      describe("getItemNames") {
        it("should return the names string correctly") {
          let expected = "Item 1, Item 2, Item 3"
          expect(sut.getItemNames()).to(equal(expected))
        }
      }
    }
    
    describe("ProductPackage") {
      var name: String!
      var price: Double!
      var weight: Int!
      var courirCharge: Double!
      
      var items1: [ProductItem]!
      var items3: [ProductItem]!
      var sut1: ProductsPackage!
      var sut2: ProductsPackage!
      var sut3: ProductsPackage!
      
      beforeEach {
        name = "Product Package"
        price = 130.0
        weight = 245
        courirCharge = 15.0
        items1 = [
          ProductItem(name: "Item 1", weight: 20, price: 100),
          ProductItem(name: "Item 2", weight: 200, price: 20),
          ProductItem(name: "Item 3", weight: 25, price: 10)
        ]
        
        items3 = [
          ProductItem(name: "Item 1", weight: 20, price: 100),
          ProductItem(name: "Item 2", weight: 200, price: 20),
          ProductItem(name: "Item 3", weight: 25, price: 10),
          ProductItem(name: "Item 4", weight: 25, price: 10),
        ]
        
        sut1 = ProductsPackage(name: name, totalPrice: price, totalWeight: weight, courierCharge: courirCharge, products: items1)
        sut2 = ProductsPackage(name: name, totalPrice: price, totalWeight: weight, courierCharge: courirCharge, products: items1)
        sut3 = ProductsPackage(name: name, totalPrice: price, totalWeight: weight, courierCharge: courirCharge, products: items3)
      }
      
      it("should return equal") {
        expect(sut1 == sut2).to(beTrue())
      }
      
      it("should not return equal") {
        expect(sut1 == sut3).to(beFalse())
      }
    }
  }
}
