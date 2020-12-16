import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("Hush is not enabled")
                .font(.title)
                .bold()
                .padding(.bottom, 20)

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
        }
    }
}


struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
