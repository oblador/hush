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

struct EnabledView: View {
    let reviewURL = makeStoreURL(appID:"1544743900", action: "write-review")
    let reportWebsiteURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeox139lwja1Yl94dIZLSg8Ga8Wt4PAWSmRwtIe7NPb7WtHMA/viewform")!
    let starProjectURL = URL(string: "https://github.com/oblador/hush")!
    
    #if os(macOS)
    let verticalSpacing: CGFloat = 25
    #else
    let verticalSpacing: CGFloat = 40
    #endif
    
    var body: some View {
        VStack (alignment: .leading, spacing: verticalSpacing) {
            
            VStack (alignment: .leading, spacing: 5) {
                Text("Hush is enabled")
                    .font(.title)
                    .accessibilityIdentifier("extension enabled")
                 Text("You're now browsing without the nuisance.")
            }

            VStack (alignment: .leading, spacing: 10) {
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

            VStack (alignment: .leading, spacing: 10) {
                Text("Love it? ")
                    .bold() +
                    Text("Spread it! ")

                HStack (spacing: 0) {
                    Link(destination: reviewURL, label: {
                        Text("Review on App Store")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                    Text(" or ")
                    Link(destination: starProjectURL, label: {
                        Text("star on GitHub")
                            .underline()
                            .bold()
                            .foregroundColor(.primary)
                    })
                }
            }
        }
    }
}

struct EnabledView_Previews: PreviewProvider {
    static var previews: some View {
        EnabledView()
    }
}
