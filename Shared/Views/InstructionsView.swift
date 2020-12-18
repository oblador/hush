import SwiftUI

struct InstructionView: View {
    var imageName: String
    var text: AnyView
    
    var body: some View {
        HStack (alignment: .center, spacing: 10){
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 34, height: 34)
            text
        }
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            VStack {
                Text("Hush is not enabled")
                    .font(.title)
                    .bold()
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(.bottom, 20)

            #if os(macOS)
            InstructionView(
                imageName: "Safari",
                text: AnyView(
                    Text("Open ") +
                        Text("Safari").bold()
                )
            )
            InstructionView(
                imageName: "Settings",
                text: AnyView(
                    Text("Select ") +
                        Text("Extensions").bold() +
                        Text(" in ") +
                        Text("Settings").bold()
                )
            )
            InstructionView(
                imageName: "Checkbox",
                text: AnyView(
                    Text("Enable ") +
                        Text("Hush").bold()
                )
            )
            #else
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
            #endif
        }
    }
}


struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
