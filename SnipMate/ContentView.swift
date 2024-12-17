//
//  ContentView.swift
//  SnipMate
//
//  Created by Cayden Glenn Park on 11/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var newTitle = ""
    @State private var newContent = ""
    @State private var snippets: [String: [String: String]] = {
        if let storedSnippets = UserDefaults.standard.dictionary(forKey: "snippets") as? [String: [String: String]] {
            return storedSnippets
        }
        return [:]
    }()
    @State private var editingSnippet: String? = nil
    @State private var editingTitle: String = ""
    @State private var editingContent: String = ""
    @State private var showToast: [String: Bool] = [:]
    @State private var selectedCategory: String
    
    @State private var categories: [String] = {
        if let storedCategories = UserDefaults.standard.array(forKey: "categories") as? [String] {
            return storedCategories
        }
        return ["Personal", "Work", "Random"] // Default categories
    }()
    
    init() {
        let storedCategories = UserDefaults.standard.array(forKey: "categories") as? [String] ?? ["Personal", "Work", "Random"]
        _categories = State(initialValue: storedCategories)
        _selectedCategory = State(initialValue: storedCategories.first ?? "")
        
        if let storedSnippets = UserDefaults.standard.dictionary(forKey: "snippets") as? [String: [String: String]] {
            _snippets = State(initialValue: storedSnippets)
        }
    }
    
    var body: some View {
        VStack {
            CategoryView(selectedCategory: $selectedCategory, categories: $categories)
                .padding(.top)
                .onChange(of: categories) { newCategories in
                    saveCategories()
                }
            ListView(snippets: $snippets, selectedCategory: $selectedCategory, editingSnippet: $editingSnippet, editingTitle: $editingTitle, editingContent: $editingContent, showToast: $showToast)
            
            Divider().padding(.horizontal)
            
            NewSnippetView(snippets: $snippets, newTitle: $newTitle, newContent: $newContent, selectedCategory: $selectedCategory)
                .padding([.bottom, .top, .leading, .trailing])
        }
    }
    
    private func loadSnippets() {
        if let loadedSnippets = UserDefaults.standard.dictionary(forKey: "snippets") as? [String: [String: String]] {
            snippets = loadedSnippets
        }
    }
    
    private func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }
}

#Preview {
    ContentView().frame(width: 250, height: 500)
}
