//
//  CustomTabBar.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/19/23.
//

import SwiftUI

struct CustomTabBar: View {
    // Environment values
    @Binding var selectedTab: Tab
    @State private var isPressed = false
    
    // View
    var body: some View {
        VStack {
            HStack {
                // Home button
                Spacer()
                HomeButton()
                Spacer()
                Spacer()
                
                // Plus button
                PlusButton()
                Spacer()
                Spacer()
                
                // Chart button
                ChartButton()
                Spacer()
            }
            .frame(height: 70)
            .background(Color.background1)
            .cornerRadius(10)
            .padding()
        }
    }
    
    // Home button
    @ViewBuilder
    func HomeButton()-> some View{
        Button{
            selectedTab = .house
        } label: {
            Image(systemName: selectedTab == .house ? "house.fill" : "house")
                .scaleEffect(selectedTab == .house ? 1.4 : 1.0)
                .foregroundColor(selectedTab == .house ? .orange2: .gray1)
                .font(.system(size: 22))
                .onTapGesture{
                    withAnimation(.easeIn(duration: 0.2)) {
                        selectedTab = .house
                    }
                }
                .shadow(color: selectedTab == .house ? .orange2.opacity(0.5) : .clear, radius: 4)
        }
    }
    
    // Plus button
    func PlusButton()-> some View{
        Button{
            selectedTab = .plusApp
        } label: {
            Image("YellowAddButton")
                .resizable()
                .frame(width:55, height:55)
            
                // Tab animation
                .onTapGesture{
                    withAnimation(.easeIn(duration: 0.2)) {
                        selectedTab = .plusApp
                    }
                }
            
                // Button press animation
                .scaleEffect(isPressed ? 1.4 : 1.0)
                .opacity(isPressed ? 0.6: 1.0)
                .pressEvent {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressed = false
                    }
                }
                .shadow(color: selectedTab == .plusApp ? .orange2.opacity(0.5) : .clear, radius: 4)
        }
    }
    
    // Chart button
    func ChartButton()-> some View{
        Button{
            selectedTab = .graph1
        } label: {
            Image(systemName: selectedTab == .graph1 ? "chart.bar.fill" : "chart.bar")
                .resizable()
                .frame(width: 25, height: 25)
                .scaleEffect(selectedTab == .graph1 ? 1.4 : 1.0)
                .foregroundColor(selectedTab == .graph1 ? .orange2: .gray1)
                .onTapGesture{
                    withAnimation(.easeIn(duration: 0.2)) {
                        selectedTab = .graph1
                    }
                }
                .shadow(color: selectedTab == .graph1 ? .orange2.opacity(0.5) : .clear, radius: 4)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
