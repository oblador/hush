import SwiftUI

struct Instruction: View {
    var imageName: String
    var label: Text
    
    var body: some View {
        HStack (alignment: .center, spacing: 10){
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 34, height: 34)
            label
        }
    }
}

struct InstructionsView: View {
    #if os(macOS)
    let verticalSpacing: CGFloat = 10
    #else
    let verticalSpacing: CGFloat = 20
    #endif

    var body: some View {
        VStack (alignment: .leading, spacing: 30) {
            VStack (alignment: .leading, spacing: 10) {
                Text("Hush is not enabled")
                    .font(.title)
                    .accessibilityIdentifier("extension disabled")
                Text("Follow these steps to enable:")
            }

            #if os(macOS)
            VStack (alignment: .leading, spacing: 10) {
                Instruction(
                    imageName: "Safari",
                    label:
                        Text("Open ") +
                        Text("Safari").bold()
                )
                Instruction(
                    imageName: "Settings",
                    label:
                        Text("Select ") +
                        Text("Extensions").bold() +
                        Text(" in ") +
                        Text("Settings").bold()
                )
                Instruction(
                    imageName: "Checkbox",
                    label:
                        Text("Enable ") +
                        Text("Hush").bold()
                )
            }
            #else
            VStack (alignment: .leading, spacing: 15) {
                Instruction(
                    imageName: "Settings",
                    label:
                        Text("Open ") +
                        Text("Settings").bold() +
                        Text(" app")
                )
                Instruction(
                    imageName: "Safari",
                    label:
                        Text("Tap ") +
                        Text("Safari").bold() +
                        Text(", then ") +
                        Text("Content Blockers").bold()
                )
                Instruction(
                    imageName: "Toggle",
                    label:
                        Text("Enable ") +
                        Text("Hush").bold()
                )
            }
            
            HStack(spacing: 0) {
                Text("Lets go! ")
                Link(destination: URL(string: UIApplication.openSettingsURLString)!, label: {
                    Text("Open Settings")
                        .underline()
                        .bold()
                        .foregroundColor(.primary)
                })
                Text(".")
            }
            #endif
        }
    }
}


struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
