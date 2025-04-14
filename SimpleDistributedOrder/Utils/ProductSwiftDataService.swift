//
//  ProductSwiftDataService.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import Foundation
import SwiftData

actor OrderContainer {
  @MainActor
  static func create(isFirstTimeLaunch: inout Bool) -> ModelContainer {
    let schema = Schema([
      ProductItem.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
    
    if isFirstTimeLaunch {
      let items = ProductItemJSONDecoder.fetchData(from: "ProductItems")
      if !items.isEmpty {
        items.forEach { item in
          let weight: Int = Int(item.weight) ?? 0
          let price: Double = Double(item.price) ?? 0
          let product = ProductItem(name: item.name, weight: weight, price: price)
          
          container.mainContext.insert(product)
        }
      }
      isFirstTimeLaunch = false
    }
    
    return container
  }
}

protocol ProductSwiftDataServiceProtocol {
  func getModelContainer() -> ModelContainer
  func fetchProductList() -> [ProductItem]
}

class ProductSwiftDataService: ProductSwiftDataServiceProtocol {
  private let modelContainer: ModelContainer
  private let modelContext: ModelContext
  
  @MainActor
  static func shared(isFirstTimeLaunch: inout Bool) -> ProductSwiftDataService {
    return ProductSwiftDataService(container: OrderContainer.create(isFirstTimeLaunch: &isFirstTimeLaunch))
  }
  
  @MainActor
  private init(container: ModelContainer) {
      self.modelContainer = container
      self.modelContext = modelContainer.mainContext
  }
  
  func getModelContainer() -> ModelContainer {
    return self.modelContainer
  }
  
  func fetchProductList() -> [ProductItem] {
    do {
      let descriptor = FetchDescriptor<ProductItem>(sortBy: [SortDescriptor(\.name)])
      return try modelContext.fetch(descriptor)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

struct ProductItemResponse: Decodable {
  var name: String
  var price: String
  var weight: String
}

struct ProductItemJSONDecoder {
  static func fetchData(from filename: String) -> [ProductItemResponse] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let items = try? JSONDecoder().decode([ProductItemResponse].self, from: data) else {
      return []
    }
    
    return items
  }
  
}
