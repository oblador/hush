import SwiftUI

struct InstructionsView: View {
    let safariBundleIdentifier = "com.apple.Safari"

    var body: some View {
        VStack {
            Text("Hush is not enabled")
                .font(.title)
                .bold()
                .padding(.bottom, 20)

            InstructionView(
                imageName: "Safari",
                text: AnyView(HStack(spacing: 0) {
                    Text("Open ")
                    Button("Safari") {
                        do {
                            let safariURL = try FileManager.default.url(for: .applicationDirectory, in: .localDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Safari.app")
                            NSWorkspace.shared.open([], withApplicationAt: safariURL, configuration: .init()) { (runningApp, error) in
                                print("running app", runningApp ?? "nil")
                            }
                        } catch {
                            print(error)
                        }
                    }
                    Link(destination: URL(string: "prefs:safari")!, label: {
                        Text("Safari")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                })
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
