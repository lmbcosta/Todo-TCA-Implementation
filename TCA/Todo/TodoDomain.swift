//
//  TodoDomain.swift
//  TCA
//
//  Created by Luis Costa on 20.01.23.
//

import ComposableArchitecture
import Foundation

struct TodoEnvironment {}

struct Todo: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        
        let id: UUID
        var description = ""
        var isComplete = false
        
        init(id: UUID, description: String = "", isComplete: Bool = false) {
            self.id = id
            self.description = description
            self.isComplete = isComplete
        }
    }
    
    enum Action: Equatable {
        case checkboxTapped
        case checkboxDescriptionChanged(String)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .checkboxTapped:
                state.isComplete.toggle()
            case let .checkboxDescriptionChanged(text):
                state.description = text
            }
            
            return .none
        }
    }
}
