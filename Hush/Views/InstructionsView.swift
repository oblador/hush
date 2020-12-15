//
//  InstructionsView.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-15.
//

import SwiftUI

struct InstructionView: View {
    var imageName: String
    var text: AnyView

    var body: some View {
        HStack{
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 40, height: 40)
                .padding(.trailing, 10)
                .padding(.top, 2)
            text
        }
        .padding(20)
        .frame(minWidth: 100, idealWidth: 200, maxWidth: 350, minHeight: 0, idealHeight: 0, maxHeight: 40, alignment: .leading)
    }
}

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
