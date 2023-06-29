//
//  ContentView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    var body: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
