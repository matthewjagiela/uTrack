//
//  IntroView.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/8/21.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        TabView {
            WelcomeView()
            Text("2")
            Text("3")
            Text("4")
        }.tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
