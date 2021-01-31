import Foundation

enum ContentBlockerEnabledState {
    case undetermined
    case disabled
    case enabled
}

class AppState: ObservableObject {
    @Published var contentBlockerEnabledState: ContentBlockerEnabledState
    init(initialContentBlockerEnabledState:ContentBlockerEnabledState) {
        self.contentBlockerEnabledState = initialContentBlockerEnabledState
    }
}
