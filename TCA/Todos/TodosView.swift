//
//  TodosView.swift
//  TCA
//
//  Created by Luis Costa on 20.01.23.
//

import ComposableArchitecture
import SwiftUI

struct TodosView: View {
    let store: StoreOf<Todos>
    
    @ObservedObject var viewStore: ViewStore<ViewState, Todos.Action>
    
    init(store: StoreOf<Todos>) {
        
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }
    
    struct ViewState: Equatable {
        var isClearCompletedButtonDisabled: Bool
        
        init(state: Todos.State) {
            self.isClearCompletedButtonDisabled = !state.todos.contains(where: \.isComplete)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEachStore(
                    self.store.scope(state: \.todos, action: Todos.Action.todo(id:action:))
                ) {
                    TodoView(store: $0)
                }
                .onDelete { self.viewStore.send(.deleteTodos($0))}
                
            }
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: HStack(spacing: 20) {
                Button("Clear", action: { self.viewStore.send(.clearAllCompletedTodos, animation: .default) })
                    .disabled(self.viewStore.isClearCompletedButtonDisabled)
                Button("Add Todo", action: { self.viewStore.send(.addTodoButtonTapped, animation: .default) })
            })
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView(
            store: .init(
                initialState: Todos.State(),
                reducer: Todos()
            )
        )
    }
}
