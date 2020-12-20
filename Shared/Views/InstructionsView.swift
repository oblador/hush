import SwiftUI

struct InstructionView: View {
    var imageName: String
    var text: Text
    
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
                Text("Follow these steps to enable:")
            }

            #if os(macOS)
            VStack (alignment: .leading, spacing: 10) {
                InstructionView(
                    imageName: "Safari",
                    text:
                        Text("Open ") +
                        Text("Safari").bold()
                )
                InstructionView(
                    imageName: "Settings",
                    text:
                        Text("Select ") +
                        Text("Extensions").bold() +
                        Text(" in ") +
                        Text("Settings").bold()
                )
                InstructionView(
                    imageName: "Checkbox",
                    text:
                        Text("Enable ") +
                        Text("Hush").bold()
                )
            }
            #else
            VStack (alignment: .leading, spacing: 15) {
                InstructionView(
                    imageName: "Settings",
                    text:
                        Text("Open ") +
                        Text("Settings").bold() +
                        Text(" app")
                )
                InstructionView(
                    imageName: "Safari",
                    text:
                        Text("Tap ") +
                        Text("Safari").bold() +
                        Text(", then ") +
                        Text("Content Blockers").bold()
                )
                InstructionView(
                    imageName: "Toggle",
                    text:
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
