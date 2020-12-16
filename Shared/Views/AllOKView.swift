import SwiftUI

struct AllOKView: View {    
    var body: some View {
        VStack{
            Text("Looking good!")
                .font(.title)
                .bold()
                .padding(.bottom, 5)
            Text("You may close the app and browse nag-free.")
                .font(.subheadline)
        }
    }
}

struct AllOKView_Previews: PreviewProvider {
    static var previews: some View {
        AllOKView()
    }
}
