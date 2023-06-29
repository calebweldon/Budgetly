//
//  HomeView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/18/23.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    // Environment values -> initialize ExpenseViewModel
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    @State private var selectedTab: Tab = .house
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    // View
    var body: some View {
        VStack{
            
            // Tab selection determines which view to show
            TabView(selection: $selectedTab){
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    ZStack{
                        // House view
                        if selectedTab == .house{
                            HouseView()
                                .environmentObject(expenseViewModel)
                        
                        // Charts view
                        } else if selectedTab == .graph1{
                            ChartsView()
                                .environmentObject(expenseViewModel)
                            
                        // NewExpense view
                        } else {
                            NewExpenseView()
                                .environmentObject(expenseViewModel)
                        }
                    }
                    .tag(tab)
                }
            }
            // Custom tab bar
            ZStack{
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .background(Color.background1)
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
