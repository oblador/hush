import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("Hush is not enabled")
                .font(.title)
                .bold()
                .padding(.bottom, 20)

            InstructionView(
                imageName: "Settings",
                text: AnyView(HStack(spacing: 0) {
                    Text("Open ")
                    Link(destination: URL(string: "App-Prefs:root")!, label: {
                        Text("Settings")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                    Text(" app")
                })
            )
            InstructionView(
                imageName: "Safari",
                text: AnyView(
                    Text("Tap ") +
                    Text("Safari").bold() +
                    Text(" ⭢ ") +
                    Text("Content Blockers").bold()
                )
            )
            InstructionView(
                imageName: "Toggle",
                text: AnyView(
                    Text("Enable ") +
                    Text("Hush").bold()
                )
            )
        }
    }
}


struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
