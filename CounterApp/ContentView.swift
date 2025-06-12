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
        VStack(spacing: 30) {
            Text("iOS Counter App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("CI/CD Pipeline Test")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(count)")
                .font(.system(size: 80, weight: .medium, design: .rounded))
                .foregroundColor(count >= 0 ? .blue : .red)
                .animation(.easeInOut(duration: 0.2), value: count)
            
            HStack(spacing: 30) {
                Button(action: {
                    count -= 1
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    count = 0
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.orange)
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
