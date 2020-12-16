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
