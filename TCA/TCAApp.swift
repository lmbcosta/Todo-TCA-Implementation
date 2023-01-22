//
//  TCAApp.swift
//  TCA
//
//  Created by Luis Costa on 20.01.23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup<TodosView> {
            TodosView(
                store: Store(
                    initialState: Todos.State(),
                    reducer: Todos()._printChanges()
                )
            )
        }
    }
}
