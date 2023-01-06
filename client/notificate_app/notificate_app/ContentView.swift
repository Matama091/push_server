//
//  ContentView.swift
//  notificate_app
//
//  Created by matama on 2022/12/28.
//

import SwiftUI

var textContent = "Loading..."

struct ContentView: View {
    @State var TestText = ""
    var body: some View {
    Text(TestText)
                .padding()
                .onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.TestText = textContent
                    }
                })
    }}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
