//
//  ContentView.swift
//  CounterApp
//
//  Created by Chitra Joshy on 15/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("New Counter Test New label IPA")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(count)")
                .font(.system(size: 60))
                .fontWeight(.medium)
            
            HStack(spacing: 20) {
                Button(action: {
                    count -= 1
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    count += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
