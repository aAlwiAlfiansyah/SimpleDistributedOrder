//
//  SimpleDistributedOrderApp.swift
//  SimpleDistributedOrder
//
//  Created by Alwi Alfiansyah Ramdan on 13/04/25.
//

import SwiftUI
import SwiftData

@main
struct SimpleDistributedOrderApp: App {
  @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
  
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProductItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
      let datasource = ProductSwiftDataService.shared(isFirstTimeLaunch: &isFirstTimeLaunch)
      WindowGroup {
        ProductListView(productViewModel: ProductListViewModel(dataSource: datasource))
      }
      .modelContainer(sharedModelContainer)
    }
}
