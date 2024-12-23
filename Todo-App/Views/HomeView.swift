//
//  ContentView.swift
//  Todo-App
//
//  Created by Lê Tiến Đạt on 21/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    
    var filterTodos: [TodoItem] {
        if homeViewModel.searchText.isEmpty {
            return homeViewModel.todos.sorted(by: { $0.timeUpdated > $1.timeUpdated })
        }
        return homeViewModel.todos.filter {
            $0.title.lowercased().contains(homeViewModel.searchText.lowercased())
        }.sorted(by: { $0.timeUpdated > $1.timeUpdated })
    }
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    List {
                        ForEach(filterTodos, id: \.id) { todo in
                            if let index = homeViewModel.todos.firstIndex(where: { $0.id == todo.id }) {
                                NavigationLink(destination: TodoDetailView(todo: $homeViewModel.todos[index]) {
                                    homeViewModel.deleteTodo(id: todo.id)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            let (title, colorTitle) = getStatusTitle(for: homeViewModel.todos[index])
                                            
                                            Text(title)
                                                .foregroundColor(colorTitle)
                                                .font(.system(size: 16))
                                            Text(Utilities.formatDate(homeViewModel.todos[index].timeUpdated))
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text(homeViewModel.todos[index].status.rawValue)
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                                        }
                                        .background(homeViewModel.todos[index].status == .pending ? .orange : .green)
                                        .cornerRadius(20)
                                    }
                                    .padding(.vertical, 5)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(action: {
                                        homeViewModel.deleteTodo(id: homeViewModel.todos[index].id)
                                    }) {
                                        Label("Delete", systemImage: "trash.slash.fill")
                                    }
                                    .tint(.red)
                                }
                                .swipeActions(edge: .leading) {
                                    let (statusImage, statusColor) = getStatusDetails(for: homeViewModel.todos[index])

                                    Button(action: {
                                        homeViewModel.toggleStatus(for: homeViewModel.todos[index])
                                    }) {
                                        Label("Mark", systemImage: statusImage)
                                    }
                                    .tint(statusColor)
                                }
                            }
                        }
                    }
                    .navigationTitle("Todo List")
                }
                .tabItem {
                    Text("\(filterTodos.count) todos")
                }
            }
            .accentColor(Color(.label))
            .searchable(text: $homeViewModel.searchText)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        homeViewModel.showingSheet.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .renderingMode(.original)
                    }
                }
            }
            .sheet(isPresented: $homeViewModel.showingSheet) {
                NavigationView {
                    CreateTodoView(showingSheet: $homeViewModel.showingSheet, onCreate: { title, content in
                        homeViewModel.addTodo(title: title, content: content)
                    })
                }
            }
        }
    }
    
    private func getStatusTitle(for todo: TodoItem) -> (String, Color) {
        return todo.title.isEmpty ? ("No title", Color(.label)) : (todo.title, Color(.label))
    }
    
    private func getStatusDetails(for todo: TodoItem) -> (String, Color) {
        switch todo.status {
        case .pending:
            return ("checkmark.seal.fill", .green)
        case .completed:
            return ("xmark.seal.fill", .yellow)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        homeViewModel.todos.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CreateTodoView: View {
    @Binding var showingSheet: Bool
    var onCreate: ((String, String) -> Void)
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isTitleFocus: Bool
    
    var body: some View {
        VStack() {
            TextField("Title", text: $title)
                .font(.system(size: 30, weight: .bold))
                .focused($isTitleFocus)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isTitleFocus = true
                    }
                }
                .padding(.trailing, 15)
                .padding(.bottom, -10)
            TextEditor(text: $content)
                .padding(.trailing, 8)
                .padding(.leading, -4)
                .background(.clear)
                .overlay(
                    Group {
                        if content.isEmpty {
                            Text("Content")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 2)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
        }
        .padding(.leading, 15)
        .padding(.top, 10)
        .navigationBarTitle(Text("Add todo"), displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            showingSheet = false
        }) {
            Text("Cancel")
                .font(.system(size: 15, weight: .medium))
        }, trailing: Button(action: {
            onCreate(title, content)
            showingSheet = false
        }) {
            Text("Add")
                .font(.system(size: 15, weight: .bold))
        }
            .disabled(title.isEmpty)
        )
        
        Spacer()
    }
}
