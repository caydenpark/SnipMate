//
//  ListView.swift
//  SnipMate
//
//  Created by Cayden Glenn Park on 11/16/24.
//

import SwiftUI
import AppKit

struct ListView: View {
    @Binding var snippets: [String: [String: String]]
    @Binding var selectedCategory: String
    @Binding var editingSnippet: String?
    @Binding var editingTitle: String
    @Binding var editingContent: String
    @Binding var showToast: [String: Bool]
    
    @State private var hoveredKey: String?
    @State private var isHoveringTrashButton: [String: Bool] = [:]
    @State private var isHoveringEditButton: [String: Bool] = [:]
    
    var body: some View {
        VStack {
            List {
                let filteredSnippets: [String: String] = snippets[selectedCategory] ?? [:]
                
                ForEach(Array(filteredSnippets.keys.sorted().enumerated()), id: \.element) { (index, key) in
                    HStack {
                        if editingSnippet == key {
                            VStack {
                                TextField("Title", text: $editingTitle)
                                    .textFieldStyle(SquareBorderTextFieldStyle())
                                    .font(.headline)
                                
                                TextField("Content", text: $editingContent)
                                    .textFieldStyle(SquareBorderTextFieldStyle())
                                
                                HStack {
                                    Button(action: {
                                        if let oldKey = editingSnippet {
                                            if var category = snippets[selectedCategory] {
                                                category.removeValue(forKey: oldKey)
                                                category[editingTitle] = editingContent
                                                snippets[selectedCategory] = category
                                            }
                                            UserDefaults.standard.set(snippets, forKey: "snippets")
                                            editingSnippet = nil
                                        }
                                    }) {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                    }.buttonStyle(.plain)
                                    
                                    Button(action: {
                                        editingSnippet = nil
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.red)
                                    }.buttonStyle(.plain)
                                }
                            }.padding(.vertical)
                            
                        } else {
                            Text("⌘\(index + 1)")
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading) {
                                Button(action: {
                                    copyToClipboard(content: snippets[selectedCategory]?[key] ?? "")
                                    showToast[key] = true
                                    
                                    // Hide the toast after 2 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showToast[key] = false
                                    }
                                }) {
                                    Text(key)
                                        .font(.headline)
                                        .scaleEffect(hoveredKey == key ? 1.1 : 1.0)
                                        .onHover { isHovering in
                                            hoveredKey = isHovering ? key : nil
                                        }
                                }
                                .buttonStyle(.plain)
                                .keyboardShortcut(shortcutKey(for: index), modifiers: .command)
                            }
                            
                            if showToast[key] == true {
                                Spacer()
                                Text("Copied!")
                                    .foregroundColor(.yellow)
                                    .animation(.easeInOut, value: showToast[key])
                            }
                            Spacer()
                            
                            Button(action: {
                                editingSnippet = key
                                editingTitle = key
                                editingContent = snippets[selectedCategory]?[key] ?? ""
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .scaleEffect(isHoveringEditButton[key] == true ? 1.1 : 1.0)
                            }
                            .buttonStyle(.plain)
                            .onHover { hovering in
                                isHoveringEditButton[key] = hovering
                            }
                            
                            Button(action: {
                                deleteSnippet(for: key)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(isHoveringTrashButton[key] == true ? .red : .primary)
                                    .scaleEffect(isHoveringTrashButton[key] == true ? 1.1 : 1.0)
                            }
                            .buttonStyle(.plain)
                            .onHover { hovering in
                                isHoveringTrashButton[key] = hovering
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    private func shortcutKey(for index: Int) -> KeyEquivalent {
        switch index {
        case 0: return "1"
        case 1: return "2"
        case 2: return "3"
        case 3: return "4"
        case 4: return "5"
        case 5: return "6"
        case 6: return "7"
        case 7: return "8"
        case 8: return "9"
        default: return .return
        }
    }
    
    private func copyToClipboard(content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
    }
    
    private func deleteSnippet(for key: String) {
        snippets[selectedCategory]?.removeValue(forKey: key)
        UserDefaults.standard.set(snippets, forKey: "snippets")
    }
}

#Preview {
    ListView(
        snippets: .constant(["Personal": ["SSH": "SSH @123.456.78", "Email": "johnny@mail.com", "Intro": "Hello, World!"]]),
        selectedCategory: .constant("Personal"),
        editingSnippet: .constant(""),
        editingTitle: .constant(""),
        editingContent: .constant(""),
        showToast: .constant([ "SSH": false, "Email": false, "Intro": false ])
    )
    .frame(width: 250)
}

