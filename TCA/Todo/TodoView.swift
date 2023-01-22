//
//  TodoView.swift
//  TCA
//
//  Created by Luis Costa on 20.01.23.
//

import ComposableArchitecture
import SwiftUI

struct TodoView: View {
    let store: StoreOf<Todo>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkboxTapped, animation: .default) }) {
                    Image(systemName:  viewStore.isComplete ? "checkmark.square" : "square")
                }
                TextField(
                    "Untitle Todo",
                    text: viewStore.binding(
                        get: \.description,
                        send: Todo.Action.checkboxDescriptionChanged
                    )
                )
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(store: .init(
            initialState: Todo.State(id: UUID()),
            reducer: Todo())
        )
    }
}
