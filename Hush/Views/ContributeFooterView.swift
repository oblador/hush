//
//  ContributeFooterView.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-15.
//

import SwiftUI

struct ContributeFooterView: View {
    var body: some View {
        HStack(spacing: 0) {
            Link(destination: URL(string: "https://github.com/sponsors/oblador")!, label: {
                Text("Sponsor me")
                    .underline()
                    .bold()
                    .foregroundColor(.primary)
            })
            Text(" or ")
            Link(destination: URL(string: "https://github.com/oblador/hush")!, label: {
                Text("star project")
                    .underline()
                    .bold()
                    .foregroundColor(.primary)
            })
            Text(" on GitHub")
        }
        .font(.footnote)
    }
}


struct ContributeFooterView_Previews: PreviewProvider {
    static var previews: some View {
        ContributeFooterView()
    }
}
