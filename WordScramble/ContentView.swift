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
            Section("Section 1") {
                Text("Static row 1")
                Text("Static row 2")
            }
            
            Section("Section 2") {
                ForEach(0..<4) {
                    Text("Dynamic row: \($0 + 1)")
                }
            }
            
            
            
            Section("Section 3") {
                Text("Static row 3")
                Text("Static row 4")
            }
        }
        .listStyle(.grouped)
        
        List(0..<4) {
            Text("dynamic list \($0)")
        }
    }
}

#Preview {
    ContentView()
}
