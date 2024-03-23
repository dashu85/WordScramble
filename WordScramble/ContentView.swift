//
//  ContentView.swift
//  WordScramble
//
//  Created by Marcus Benoit on 23.03.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            ForEach(0..<10) {
                Text("this is row number: \($0)")
            }
        }
    }
}

#Preview {
    ContentView()
}
