//
//  ProductPackageView.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import SwiftUI

struct ProductPackageView: View {
  @ObservedObject var packageModel: ProductPackageViewModel
  var body: some View {
    LazyVStack(alignment: .leading) {
      Text(packageModel.package.name).bold()
      Spacer()
      Text("Product Items: \(packageModel.getItemNames())")
      Text("Total weight: \(packageModel.package.totalWeight) g")
      HStack {
        Spacer()
        VStack(alignment: .trailing) {
          Text("Package price: ")
          Text("Courier charge: ")
        }
        VStack(alignment: .trailing) {
          Text(String(format: "$%.02f", packageModel.package.totalPrice))
          Text(String(format: "$%.02f", packageModel.package.courierCharge))
        }
      }
      .padding()
      Line()
        .stroke(lineWidth: 1.0)
        .frame(height: 1)
    }
  }
}

#Preview {
  let package = ProductsPackage()
  package.name = "package 1"
  package.courierCharge = 15.0
  package.totalPrice = 250.0
  package.totalWeight = 500
  package.products = [
    ProductItem(name: "item 1", weight: 100, price: 20.0),
    ProductItem(name: "item 2", weight: 100, price: 20.0),
    ProductItem(name: "item 3", weight: 100, price: 20.0),
    ProductItem(name: "item 4", weight: 100, price: 20.0),
  ]
  return ProductPackageView(packageModel: ProductPackageViewModel(package: package))
}
