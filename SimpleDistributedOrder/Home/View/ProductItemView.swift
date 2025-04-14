//
//  ProductItemView.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import SwiftUI

struct ProductItemView: View {
  @ObservedObject var itemModel: ProductItemViewModel
  var body: some View {
    LazyVStack {
      HStack {
        Image(systemName: itemModel.iconName)
          .foregroundStyle(Color.black)
          .dynamicTypeSize(.large)
          .bold()
        Spacer()
        Text(itemModel.item.name)
          .bold()
        Spacer()
        VStack {
          Text(itemModel.getPriceText())
            .bold()
          Text(itemModel.getWeightText())
            .italic()
        }
      }
      .padding()
      Line()
        .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        .frame(height: 1)
    }
    
  }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

#Preview {
  let item = ProductItem(name: "Item 1", weight: 20, price: 100)
  let itemModel: ProductItemViewModel = ProductItemViewModel(item: item)
  return ProductItemView(itemModel: itemModel).modelContainer(for: ProductItem.self, inMemory: true)
}
