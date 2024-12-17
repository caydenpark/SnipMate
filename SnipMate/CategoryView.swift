//
//  CategoryView.swift
//  SnipMate
//
//  Created by Cayden Glenn Park on 11/20/24.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory: String
    @Binding var categories: [String]
    
    @State private var isEditing: Bool = false
    @State private var editedCategories: [String] = []
    @State private var newCategoryName: String = ""
    
    @State private var isHoveringEditButton = false
    @State private var isHoveringAddCategoryButton = false
    @State private var isHoveringTrash: [Bool] = []
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isEditing.toggle()
                    if isEditing {
                        editedCategories = categories
                        resetHoverState()
                    } else {
                        categories = editedCategories
                    }
                }) {
                    Image(systemName: "square.and.pencil")
                        .scaleEffect(isHoveringEditButton ? 1.1 : 1.0)
                        .onHover { hovering in
                            isHoveringEditButton = hovering
                        }
                }
                .buttonStyle(.plain)
                
                Picker("", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding(.horizontal)
            
            if isEditing {
                VStack(alignment: .leading) {
                    ForEach(Array(editedCategories.enumerated()), id: \.offset) { index, category in
                        HStack {
                            TextField("", text: Binding(
                                get: { editedCategories[index] },
                                set: { newValue in
                                    editedCategories[index] = newValue
                                    categories = editedCategories
                                }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                deleteCategory(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .scaleEffect(isHoveringTrash[index] ? 1.1 : 1.0)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    HStack {
                        TextField("New Category...", text: $newCategoryName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            addCategory()
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                                .scaleEffect(isHoveringAddCategoryButton ? 1.1 : 1.0)
                                .onHover { hovering in
                                    isHoveringAddCategoryButton = hovering
                                }
                        }
                        .buttonStyle(.plain)
                        .disabled(newCategoryName.isEmpty)
                    }
                    .padding(.vertical, 4)
                }
                .padding()
                
                Divider().padding(.horizontal)
            }
        }
    }
    
    private func deleteCategory(at index: Int) {
        editedCategories.remove(at: index)
        isHoveringTrash.remove(at: index)
        categories = editedCategories
        resetHoverState()
    }
    
    private func addCategory() {
        guard !newCategoryName.isEmpty else { return }
        if !editedCategories.contains(newCategoryName) {
            editedCategories.append(newCategoryName)
            categories = editedCategories
            isHoveringTrash.append(false)
        }
        newCategoryName = ""
    }
    
    // Helper function to reset the hover state array
    private func resetHoverState() {
        isHoveringTrash = Array(repeating: false, count: editedCategories.count)
    }
}
