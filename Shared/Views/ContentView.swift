import SwiftUI

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Color.appBackgroundColor.ignoresSafeArea()
            VStack (spacing: 40) {
                Image(self.appState.contentBlockerEnabledState == .disabled ? "Disabled" : "Enabled")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.invertedBackgroundColor)
                    .frame(width: 200, height: 155)
                VStack { () -> AnyView? in
                    switch(self.appState.contentBlockerEnabledState) {
                    case .disabled: return AnyView(InstructionsView())
                    case .enabled: return AnyView(AllOKView().padding(10))
                    case .undetermined: return nil
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
