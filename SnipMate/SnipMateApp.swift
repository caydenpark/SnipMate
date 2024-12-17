//
//  SnipMateApp.swift
//  SnipMate
//
//  Created by Cayden Glenn Park on 11/7/24.
//

import SwiftUI

@main
struct SnipMateApp: App {
    @StateObject private var dataModel = SnipMateDataModel()
    
    var body: some Scene {
        MenuBarExtra("SnipMate", systemImage: "scissors") {
            ContentView()
                .frame(width: 300)
        }
        .menuBarExtraStyle(.window)
    }
}

class SnipMateDataModel: ObservableObject {
    @Published var categories: [String] = ["Work", "Personal"] // Default categories
    @Published var snippets: [String: [String: String]] = [ // Default snippets
        "Work": ["SSH Command": "ssh user@host"],
        "Personal": ["Email": "myemail@example.com"]
    ]
}
