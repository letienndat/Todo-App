//
//  HomeViewModel.swift
//  Todo-App
//
//  Created by Lê Tiến Đạt on 21/12/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var searchText = ""
    @Published var showingSheet = false
    private let todosKey = "todos"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.loadTodos()
        
        $todos
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] newTodos in
                guard let self = self else { return }
                self.saveTodos(newTodos)
            }
            .store(in: &cancellables)
    }
    
    func addTodo(title: String, content: String) {
        let todo = TodoItem(
            title: title,
            content: content,
            status: .pending,
            timeCreated: Date.now,
            timeUpdated: Date.now
        )
        todos.append(todo)
    }
    
    func updateTodo(todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].title = todo.title
            todos[index].content = todo.content
            todos[index].timeUpdated = .now
        }
    }
    
    func deleteTodo(id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
        }
    }
    
    func toggleStatus(for todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            switch todos[index].status {
            case .pending:
                todos[index].status = .completed
                todos[index].timeCompleted = .now
            case .completed:
                todos[index].status = .pending
                todos[index].timeCompleted = nil
            }
        }
    }
    
    func loadTodos() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: todosKey) {
            do {
                let todos = try decoder.decode([TodoItem].self, from: data)
                self.todos = todos
                print("Todos loaded successfully: \(todos.count) items")
            } catch {
                print("Failed to decode todos: \(error)")
            }
        } else {
            print("No data found for key 'todos'")
        }
    }

    func saveTodos(_ todos: [TodoItem]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(todos)
            UserDefaults.standard.set(encoded, forKey: todosKey)
            print("Todos saved successfully")
        } catch {
            print("Failed to encode todos: \(error)")
        }
    }
}
