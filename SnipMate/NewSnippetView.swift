//
//  NewSnippetView.swift
//  SnipMate
//
//  Created by Cayden Glenn Park on 11/18/24.
//

import SwiftUI

struct NewSnippetView: View {
    @Binding var snippets: [String: [String: String]]
    @Binding var newTitle: String
    @Binding var newContent: String
    @Binding var selectedCategory: String
    
    @State private var isHoveringSave = false
    @State private var isHoveringQuit = false
    
    var body: some View {
        VStack {
            TextField("Enter title...", text: $newTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
            TextField("Enter content...", text: $newContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
        }

        HStack {
            Button(action: {
                if !newTitle.isEmpty && !newContent.isEmpty && !selectedCategory.isEmpty {
                    snippets[selectedCategory, default: [:]][newTitle] = newContent
                    saveSnippets()
                    newTitle = ""
                    newContent = ""
                }
            }) {
                Text("Save Snippet")
                    .foregroundColor(.primary)
                    .scaleEffect(isHoveringSave == true ? 1.05 : 1.0)
            }
            .onHover { isHovering in
                isHoveringSave = isHovering
            }
            
            Spacer()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
                    .foregroundColor(.primary)
                    .scaleEffect(isHoveringQuit == true ? 1.05 : 1.0)
            }
            .onHover { isHovering in
                isHoveringQuit = isHovering
            }
        }
    }
    
    private func saveSnippets() {
        UserDefaults.standard.set(snippets, forKey: "snippets")
    }
}

#Preview {
    NewSnippetView(
        snippets: .constant(["Personal": ["Sample": "Content"]]),
        newTitle: .constant(""),
        newContent: .constant(""),
        selectedCategory: .constant("Personal")
    )
    .frame(width: 250)
}
