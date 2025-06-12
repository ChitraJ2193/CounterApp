//
//  ContentView.swift
//  CounterApp
//
//  Created by Chitra Joshy on 15/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    @State private var buildTime = Date()
    
    var body: some View {
        VStack(spacing: 25) {
            Text("iOS Counter App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("CI/CD Pipeline Demo v2.0")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            // Build timestamp for tracking
            Text("Build: \(formatBuildTime())")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Text("\(count)")
                .font(.system(size: 80, weight: .medium, design: .rounded))
                .foregroundColor(count >= 0 ? .blue : .red)
                .animation(.easeInOut(duration: 0.2), value: count)
            
            HStack(spacing: 30) {
                Button(action: {
                    count -= 1
                }) {
                    VStack {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                        Text("Subtract")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: {
                    count = 0
                    buildTime = Date() // Update timestamp on reset
                }) {
                    VStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.orange)
                        Text("Reset")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Button(action: {
                    count += 1
                }) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.green)
                        Text("Add")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Progress indicator
            if count > 0 {
                ProgressView(value: Double(count), total: 10)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(1.2)
                    .padding(.horizontal, 40)
                Text("Progress: \(count)/10")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    private func formatBuildTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm:ss"
        return formatter.string(from: buildTime)
    }
}

#Preview {
    ContentView()
}
