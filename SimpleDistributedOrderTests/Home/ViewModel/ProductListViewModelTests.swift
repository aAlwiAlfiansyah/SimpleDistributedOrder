//
//  ProductListViewModelTests.swift
//  SimpleDistributedOrderTests
//
//  Created by Alwi Alfiansyah Ramdan on 14/04/25.
//

import XCTest
import Quick
import Nimble
import Mockingbird

@testable import SimpleDistributedOrder

final class ProductListViewModelTests: QuickSpec {
  override class func spec(){
    describe("SimpleDistributedOrder") {
      var productList: [ProductItem]!
      var product1: ProductItem!
      var product2: ProductItem!
      var product3: ProductItem!
      var dataSource: ProductSwiftDataServiceProtocolMock!
      var sut: ProductListViewModel!
      
      beforeEach {
        product1 = ProductItem(name: "Item 1", weight: 20, price: 100)
        product2 = ProductItem(name: "Item 2", weight: 200, price: 20)
        product3 = ProductItem(name: "Item 3", weight: 25, price: 10)
        productList = [
          product1,
          product2,
          product3
        ]
        
        dataSource = mock(ProductSwiftDataServiceProtocol.self)
        given(dataSource.fetchProductList()) ~> productList
        
        sut = ProductListViewModel(dataSource: dataSource)
      }
      
      describe("init") {
        it("should set up correctly") {
          verify(dataSource.fetchProductList()).wasCalled()
          
          expect(sut.selectedProductList).to(beEmpty())
        }
      }
      
      describe("updateSelected") {
        it("should update selected array correctly") {
          product1.selected = true
          product3.selected = true
          
          let expected: [ProductItem] = [
            product1,
            product3
          ]
          
          sut.updateSelected()
          expect(sut.selectedProductList).to(equal(expected))
        }
      }
      
      describe("totalWeight") {
        it("should return correct value for weight") {
          product1.selected = true
          product3.selected = true
          sut.updateSelected()
                    
          expect(sut.totalWeight()).to(equal(45))
        }
      }
      
      describe("totalPrice") {
        it("should return correct value for total price") {
          product1.selected = true
          product3.selected = true
          
          sut.packageList = [
            ProductsPackage(),
            ProductsPackage(),
          ]
          
          sut.updateSelected()
          
          expect(sut.totalPrice()).to(equal(140.0))
        }
      }
      
      describe("packagePrice") {
        it("should return correct value for total package price") {
          let package = ProductsPackage()
          package.products = [
            product1,
            product2
          ]
          
          expect(sut.packagePrice(package: package)).to(equal(120.0))
        }
      }
      
      describe("packageWeight") {
        it("should return correct value for total package weight") {
          let package = ProductsPackage()
          package.products = [
            product2,
            product3
          ]
          
          expect(sut.packageWeight(package: package)).to(equal(225))
        }
      }
      
      describe("updatePackageInfo") {
        it("should update package info correctly") {
          var package = ProductsPackage()
          package.products = [
            product2,
            product3
          ]
          let packageName = "Package name"
          
          sut.updatePackageInfo(name: packageName, package: &package)
          
          expect(package.name).to(equal(packageName))
          expect(package.totalPrice).to(equal(30.0))
          expect(package.totalWeight).to(equal(225))
          expect(package.courierCharge).to(equal(15.0))
        }
      }
      
      describe("updatePackages") {
        var product4: ProductItem!
        var product5: ProductItem!
        var product6: ProductItem!
        var product7: ProductItem!
        var product8: ProductItem!
        var product9: ProductItem!
        
        beforeEach {
          product1 = ProductItem(name: "Item 1", weight: 200, price: 10)
          product2 = ProductItem(name: "Item 2", weight: 20, price: 100)
          product3 = ProductItem(name: "Item 3", weight: 300, price: 30)
          product4 = ProductItem(name: "Item 4", weight: 500, price: 20)
          product5 = ProductItem(name: "Item 5", weight: 250, price: 30)
          product6 = ProductItem(name: "Item 6", weight: 10, price: 40)
          product7 = ProductItem(name: "Item 7", weight: 10, price: 200)
          product8 = ProductItem(name: "Item 8", weight: 500, price: 120)
          product9 = ProductItem(name: "Item 9", weight: 790, price: 130)
          
          sut.selectedProductList = [
            product1,
            product2,
            product3,
            product4,
            product5,
            product6,
            product7,
            product8,
            product9
          ]
        }
        
        describe("total price is less than 250") {
          it ("should return single package") {
            sut.selectedProductList = [
              product1,
              product2,
              product3,
              product4,
              product5,
              product6
            ]
            
            let expectedPackageList = [ProductsPackage(
              name: "Product Package",
              totalPrice: 230.0,
              totalWeight: 1280,
              courierCharge: 15.0,
              products: sut.selectedProductList
            )]
            
            sut.updatePackages()
            
            expect(sut.packageList.count).to(equal(1))
            expect(sut.packageList).to(equal(expectedPackageList))
          }
        }
        
        describe("total price is equal to 250") {
          it ("should return single package") {
            sut.selectedProductList = [
              product8,
              product9
            ]
            
            let expectedPackageList = [ProductsPackage(
              name: "Product Package",
              totalPrice: 250.0,
              totalWeight: 1290,
              courierCharge: 15.0,
              products: sut.selectedProductList
            )]
            
            sut.updatePackages()
            
            expect(sut.packageList.count).to(equal(1))
            expect(sut.packageList).to(equal(expectedPackageList))
          }
        }
        
        describe("total price is more than 250") {
          it("should return correct packages") {
            let expectedPackageList = [
              ProductsPackage(
                name: "Product Package 1",
                totalPrice: 70.0,
                totalWeight: 260,
                courierCharge: 15.0,
                products: [
                  product6,
                  product5
                ]
              ),
              ProductsPackage(
                name: "Product Package 2",
                totalPrice: 230.0,
                totalWeight: 310,
                courierCharge: 15.0,
                products: [
                  product7,
                  product3
                ]
              ),
              ProductsPackage(
                name: "Product Package 3",
                totalPrice: 120.0,
                totalWeight: 520,
                courierCharge: 15.0,
                products: [
                  product2,
                  product4
                ]
              ),
              ProductsPackage(
                name: "Product Package 4",
                totalPrice: 10.0,
                totalWeight: 200,
                courierCharge: 15.0,
                products: [
                  product1
                ]
              ),
              ProductsPackage(
                name: "Product Package 5",
                totalPrice: 120,
                totalWeight: 500,
                courierCharge: 15.0,
                products: [
                  product8
                ]
              ),
              ProductsPackage(
                name: "Product Package 6",
                totalPrice: 130.0,
                totalWeight: 790,
                courierCharge: 15.0,
                products: [
                  product9
                ]
              )
            ]
            
            sut.updatePackages()
            
            expect(sut.packageList.count).to(equal(6))
            expect(sut.packageList[0]).to(equal(expectedPackageList[0]))
            expect(sut.packageList[1]).to(equal(expectedPackageList[1]))
            expect(sut.packageList[2]).to(equal(expectedPackageList[2]))
            expect(sut.packageList[3]).to(equal(expectedPackageList[3]))
            expect(sut.packageList[4]).to(equal(expectedPackageList[4]))
            expect(sut.packageList[5]).to(equal(expectedPackageList[5]))
          }
        }
      }
    }
  }
  
}
