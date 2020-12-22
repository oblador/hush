import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack ( alignment: .leading, spacing: 40) {
            Spacer()
            VStack {
                Image(self.appState.contentBlockerEnabledState == .disabled ? "Disabled" : "Enabled")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.invertedBackgroundColor)
                    .frame(width: 200, height: 155)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            VStack { () -> AnyView? in
                switch(self.appState.contentBlockerEnabledState) {
                case .disabled: return AnyView(InstructionsView())
                case .enabled: return AnyView(EnabledView())
                case .undetermined: return nil
                }
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState(initialContentBlockerEnabledState: .enabled))
        ContentView()
            .environmentObject(AppState(initialContentBlockerEnabledState: .disabled))
    }
}
