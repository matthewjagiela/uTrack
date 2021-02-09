//
//  WelcomeView.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/8/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to uTrack")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.light)
            Spacer()
            Text("uTrack allows you to be notified when hot items come in stock. First, we need to get information on what products you would like to get notified about")
            Spacer()
        }.padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
