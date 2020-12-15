//
//  AppState.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-15.
//

import Foundation

enum ContentBlockerEnabledState {
    case undetermined
    case disabled
    case enabled
}

class AppState: ObservableObject {
    @Published var contentBlockerEnabledState: ContentBlockerEnabledState = .undetermined
}
