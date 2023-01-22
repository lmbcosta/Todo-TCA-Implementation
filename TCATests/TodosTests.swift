//
//  TodosTests.swift
//  TCATests
//
//  Created by Luis Costa on 22.01.23.
//

import ComposableArchitecture
import Foundation
import XCTest
@testable import TCA

final class TodosTests: XCTestCase {
    
    let testScheculer = DispatchQueue.test
    
    func testCompletingTodo() {
        
        let initialState = Todos.State(
            todos: [
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Milk",
                    isComplete: false
                ),
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Eggs",
                    isComplete: false
                ),
            ]
        )
        
        let store = TestStore(
            initialState: initialState,
            reducer: Todos()
        ) {
            $0.mainQueue = testScheculer.eraseToAnyScheduler()
        }
        
        store.send(Todos.Action.todo(
            id: initialState.todos[0].id,
            action: .checkboxTapped)
        ) {
            $0.todos[0].isComplete = true
        }
        
        do { self.testScheculer.advance(by: 1) }
        
        store.receive(Todos.Action.todoDelayCompleted) {
            $0.todos = [
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Eggs",
                    isComplete: false
                ),
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Milk",
                    isComplete: true
                ),
            ]
        }
    }
    
    func testTodoSorting() {
        
        let initialState = Todos.State(
            todos: [
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Eggs",
                    isComplete: false
                ),
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Milk",
                    isComplete: false
                )
            ]
        )
        
        let store = TestStore(
            initialState: initialState,
            reducer: Todos()
        ) {
            $0.mainQueue = testScheculer.eraseToAnyScheduler()
        }
        
        store.send(
            Todos.Action.todo(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                action: .checkboxTapped
            )
        ) {
            
            $0.todos[0].isComplete = true
        }
        
        do { self.testScheculer.advance(by: 1) }
        
        store.receive(Todos.Action.todoDelayCompleted) {
            
            $0.todos = [
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Milk",
                    isComplete: false
                ),
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Eggs",
                    isComplete: true
                )
            ]
        }
    }
    
    func testTodoSortingWithCancelation() {
        
        let initialState = Todos.State(
            todos: [
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Eggs",
                    isComplete: false
                ),
                Todo.State(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Milk",
                    isComplete: false
                )
            ]
        )
        
        let store = TestStore(
            initialState: initialState,
            reducer: Todos()
        ) {
            $0.mainQueue = testScheculer.eraseToAnyScheduler()
        }
        
        store.send(
            Todos.Action.todo(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                action: .checkboxTapped
            )
        ) {
            
            $0.todos[0].isComplete = true
        }
        
        do { self.testScheculer.advance(by: 0.5) }
        
        store.send(
            Todos.Action.todo(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                action: .checkboxTapped
            )
        ) {
            
            $0.todos[0].isComplete = false
        }
        
        do { self.testScheculer.advance(by: 1) }
        
        store.receive(.todoDelayCompleted)
    }
    
    func testAddTodo() {
        
        let testStore = TestStore(
            initialState: Todos.State(),
            reducer: Todos()
        ) {
            
            $0.uuid = .incrementing
        }
        
        testStore.send(.addTodoButtonTapped) {
            $0.todos.insert(Todo.State(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, description: "", isComplete: false), at: 0)
        }
        
        testStore.send(.addTodoButtonTapped) {
            $0.todos = [
                Todo.State(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, description: "", isComplete: false),
                Todo.State(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, description: "", isComplete: false),
            ]
        }
    }
}
