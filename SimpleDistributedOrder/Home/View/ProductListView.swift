//
//  ProductListView.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import SwiftUI

struct ProductListView: View {
  @State private var showOrderView = false
  @ObservedObject var productViewModel: ProductListViewModel
  
  @State private var showSheet = false
  @State private var invalidSelectedItems = false
  @State private var errorMessage = ""
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color(hexStringToUIColor(hex: "#29272E"))
          .ignoresSafeArea()
        
        List {
          ForEach(productViewModel.productList, id: \.self) { productItem in
            let itemModel = ProductItemViewModel(item: productItem)
            ZStack {
              ProductItemView(itemModel: itemModel)
            }.contentShape(Rectangle())
              .frame(maxWidth: .infinity)
              .onTapGesture {
                itemModel.updateSelected()
                productViewModel.updateSelected()
              }
            
          }.listRowSeparator(.hidden)
        }
      }
      .safeAreaInset(edge: .bottom) {
        Button(action: {
          let (validSelectedItems, validationMessage) = productViewModel.validateItemSelection()
          
          invalidSelectedItems = !validSelectedItems
          errorMessage = validationMessage
          if validSelectedItems {
            productViewModel.updatePackages()
            showOrderView.toggle()
          }
          
        }) {
          Text("Place Order")
            .padding(.all, 10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .bold()
        }
        .alert(errorMessage, isPresented: $invalidSelectedItems) {
          Button("OK") {
            errorMessage = ""
            invalidSelectedItems.toggle()
          }
        }
        .sheet(isPresented: $showOrderView) {
          PlaceOrderView(productViewModel: productViewModel)
        }
      }
    }
  }
}

struct PlaceOrderView: View {
  @ObservedObject var productViewModel: ProductListViewModel
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationStack {
      VStack {
        List {
          ForEach(productViewModel.packageList, id: \.self) { package in
            let packageModel = ProductPackageViewModel(package: package)
            ProductPackageView(packageModel: packageModel)
            
          }.listRowSeparator(.hidden)
        }
        
        HStack {
          Spacer()
          VStack(alignment: .trailing) {
            Text("Total packages: ")
            Text("Total weight: ")
            Text("Total price: ")
          }
          VStack(alignment: .trailing) {
            Text("\(productViewModel.packageList.count)")
              .bold()
            Text("\(productViewModel.totalWeight()) g")
              .bold()
            Text(String(format: "$%.02f", productViewModel.totalPrice()))
              .bold()
          }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        
      }
      .safeAreaInset(edge: .bottom) {
        Button(action: {
          dismiss()
        }) {
          Text("Done")
            .padding()
            .cornerRadius(10)
        }
        .background(.bar)
        .cornerRadius(10)
      }
    }
    
  }
}

#Preview {
  var firstLaunch = true
  let datasource = ProductSwiftDataService.shared(isFirstTimeLaunch: &firstLaunch)
  let productViewModel = ProductListViewModel(dataSource: datasource)
  productViewModel.updatePackages()
  return PlaceOrderView(productViewModel: productViewModel)
}
