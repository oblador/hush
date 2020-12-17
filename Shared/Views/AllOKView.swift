import SwiftUI

func makeStoreURL(appID: String, action: String) -> URL {
    #if os(macOS)
    let scheme = "macappstore:"
    #elseif targetEnvironment(simulator)
    let scheme = "https:"
    #else
    let scheme = "itms-apps:"
    #endif

    return URL(string: "\(scheme)//apps.apple.com/app/id\(appID)?action=\(action)")!
}

struct AllOKView: View {
    let reviewURL = makeStoreURL(appID:"1544743900", action: "write-review")
    let reportWebsiteURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeox139lwja1Yl94dIZLSg8Ga8Wt4PAWSmRwtIe7NPb7WtHMA/viewform")!
    let starProjectURL = URL(string: "https://github.com/oblador/hush")!
    
    
    var body: some View {
        VStack (alignment: .center, spacing: 40) {
            
            (Text("All set! ")
                .bold()
                +
            Text("You may close the app and browse nag-free."))
                .font(.subheadline)

            VStack (alignment: .center, spacing: 15) {
                Text("Problem? ")
                    .bold() +
                Text("No problem! ")

                Link(destination: reportWebsiteURL, label: {
                    Text("Report website")
                        .underline()
                        .bold()
                        .foregroundColor(.primary)
                })
            }
            
            VStack (alignment: .center, spacing: 15) {
                Text("Love it? ")
                    .bold() +
                    Text("Spread it! ")
                
                HStack (spacing: 0) {
                    Link(destination: reviewURL, label: {
                        Text("Write a review")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                    Text(" or ")
                    Link(destination: starProjectURL, label: {
                        Text("Star on GitHub")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                }
            }
        }
    }
}

struct AllOKView_Previews: PreviewProvider {
    static var previews: some View {
        AllOKView()
    }
}
