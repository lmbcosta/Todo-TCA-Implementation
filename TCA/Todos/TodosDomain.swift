//
//  TodosDomain.swift
//  TCA
//
//  Created by Luis Costa on 20.01.23.
//

import ComposableArchitecture
import Foundation

struct TodosEnvironment {}

struct Todos: ReducerProtocol {
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.mainQueue) var mainQueue
    
    struct State: Equatable {
        
        var todos: IdentifiedArrayOf<Todo.State> = []
    }
    
    enum Action: Equatable {
        case addTodoButtonTapped
        case clearAllCompletedTodos
        case todo(id: Todo.State.ID, action: Todo.Action)
        case todoDelayCompleted
        case deleteTodos(IndexSet)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .addTodoButtonTapped:
                state.todos.insert(.init(id: self.uuid()), at: 0)
                return .none
            
            case .clearAllCompletedTodos:
                state.todos.removeAll(where: \.isComplete)
                return .none
                
            case .todo(_, .checkboxTapped):
                struct CancelDelayID: Hashable {}
                
                return EffectTask(value: .todoDelayCompleted)
                    .debounce(id: CancelDelayID(), for: 1, scheduler: self.mainQueue)
                    //.delay(for: 1, scheduler: self.mainQueue)
                    //.eraseToEffect()
                    .animation()
                    .cancellable(id: CancelDelayID(), cancelInFlight: true)
                
            case .todoDelayCompleted:
                let sortedTodos = state.todos.sorted { lhs, rhs in
                    !lhs.isComplete && rhs.isComplete
                }
                
                state.todos = IdentifiedArray(uniqueElements: sortedTodos)
                return .none
                
            case let .deleteTodos(indexSet):
                indexSet.forEach({
                    let id = state.todos[$0].id
                    state.todos.remove(id: id)
                })
                return .none
                
            default: return .none
            }
        }
        .forEach(
            \.todos,
             action: /Action.todo(id:action:),
             { Todo() }
        )
    }
}



