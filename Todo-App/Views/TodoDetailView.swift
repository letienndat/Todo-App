//
//  TodoDetailView.swift
//  Todo-App
//
//  Created by Lê Tiến Đạt on 21/12/2024.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var todo: TodoItem
    
    var onDelete: (() -> Void)
    
    var body: some View {
        VStack() {
            VStack (spacing: 5) {
                Text("Time created: \(Utilities.formatDate(todo.timeCreated))")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                Text("Time updated: \(Utilities.formatDate(todo.timeUpdated))")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                if (todo.status == .completed) {
                    Text("Time completed: \(Utilities.formatDate(todo.timeCompleted!))")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                }
            }
            TextField("Title", text: $todo.title)
                .font(.system(size: 30, weight: .bold))
                .onChange(of: todo.title) { _ in
                    todo.timeUpdated = .now
                }
                .padding(.trailing, 15)
                .padding(.bottom, -10)
            TextEditor(text: $todo.content)
                .padding(.trailing, 8)
                .padding(.leading, -4)
                .background(.clear)
                .overlay(
                    Group {
                        if todo.content.isEmpty {
                            Text("Content")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 2)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
                .onChange(of: todo.content) { _ in
                    todo.timeUpdated = .now
                }
        }
        .padding(.leading, 15)
        .padding(.top, -30)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    switch todo.status {
                    case .pending:
                        Button(action: {
                            todo.status = .completed
                            todo.timeCompleted = .now
                        }) {
                            Label("Mark completed", systemImage: "checkmark.seal")
                        }
                    case .completed:
                        Button(action: {
                            todo.status = .pending
                            todo.timeCompleted = nil
                        }) {
                            Label("Mark pending", systemImage: "xmark.seal")
                        }
                    }
                    Button(action: {
                        onDelete()
                    }) {
                        Label("Delete todo", systemImage: "trash.slash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        
        Spacer()
    }
}
