//
//  HouseView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/20/23.
//

import SwiftUI

struct HouseView: View {
    // Environment values
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Namespace var animation
    
    // View
    var body: some View {
        VStack{
            // Top bar
            TopBar()
            
            Spacer()
            
            // View body
            HouseBody()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
    
    // Top selction bar
    @ViewBuilder
    func TopBar()->some View{
        HStack{
            // Undo button -> removes most recent expense
            Button{
                let userDefaults = UserDefaults.standard
                var expenses = userDefaults.array(forKey: "expenses") as? [[String: Any]] ?? []
                if !expenses.isEmpty {
                    expenses.removeLast()
                    userDefaults.set(expenses, forKey: "expenses")
                }
            } label: {
                HStack{
                    ZStack{
                        Circle()
                            .frame(width:40,height:40)
                            .foregroundColor(.background3)
                            .opacity(0.8)
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size:20))
                            .foregroundColor(.gray2)
                    }
                }
            }
            .offset(x:20)
            
            Spacer()
            
            // Calendar button
            Button{
                expenseViewModel.showFilterView = true
            } label:{
                ZStack{
                    Circle()
                        .frame(width:40,height:40)
                        .foregroundColor(.background3)
                        .opacity(0.8)
                    Image(systemName: "calendar")
                        .font(.system(size:20))
                        .foregroundColor(.gray2)
                }
            }
            .offset(x:-20)
        }
    }
    
    // Animated tab selector
    @ViewBuilder
    func TabSelection()-> some View {
        HStack(spacing:0){
            ForEach([ExpenseType.income, ExpenseType.all, ExpenseType.expense], id: \.rawValue) { tab in
                Text(tab.rawValue == "Expense" ? "Expenses" : tab.rawValue)
                    .font(.system(size:17))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(expenseViewModel.tabName == tab ? .black : .blue2)
                    .opacity(expenseViewModel.tabName == tab ? 1 : 0.7)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background {
                        
                        // Matched geometry
                        if expenseViewModel.tabName == tab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.orangeGradient)
                                .shadow(color: .orange2.opacity(0.8), radius: 5)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            expenseViewModel.tabName = tab
                        }
                    }
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.backgroundGradient)
        }
        .padding(.horizontal)
    }
    
    // Text containing date range and "Transactions"
    @ViewBuilder
    func DateBar()-> some View{
        HStack{
            VStack(alignment: .leading){
                Text("Transactions")
                    .font(.system(size:30))
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.blue2)
                    .padding(.leading,20)
                HStack{
                    Text("from")
                        .foregroundColor(.white)
                    Text(expenseViewModel.changedMonthDateString() + ":")
                        .foregroundColor(.blue2)
                        .offset(x:-2)
                }
                .font(.system(size:16))
                .font(.title3)
                .fontWeight(.medium)
                .padding(.leading,25)
            }
            Spacer()
        }
    }
    
    // Recent transactions list
    @ViewBuilder
    func RecentTransactions()-> some View{
        // Extract expense data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        
        // Transactions title and date range
        DateBar()
        
        // All recent transactions
        if expenseViewModel.tabName == .all {
            if chronologicalExpenseDataInMonth.isEmpty {
                Text("No Transactions")
                    .font(.system(size:30))
                    .font(.title)
                    .foregroundColor(.blue2)
                    .fontWeight(.medium)
                    .padding(.top, 80)
            } else {
                VStack{
                    ScrollView(.vertical){
                        ForEach(chronologicalExpenseDataInMonth, id: \.self) { expense in
                            ExpenseRow(expense: expense)
                        }
                    }
                }
            }
        
        // Recent incomes
        } else if expenseViewModel.tabName == .income {
            let recentIncomeData = chronologicalExpenseDataInMonth.filter { expense in
            if let type = expense["type"], type == "Income" {
                return true
            }
                return false
            }
            if recentIncomeData.isEmpty {
                Text("No Incomes")
                    .font(.system(size:30))
                    .font(.title)
                    .foregroundColor(.blue2)
                    .fontWeight(.medium)
                    .padding(.top, 80)
            } else {
                VStack{
                    ScrollView(.vertical){
                        ForEach(recentIncomeData, id: \.self) { expense in
                            ExpenseRow(expense: expense)
                        }
                    }
                }
            }
            
        // Recent Expenses
        } else {
            let recentExpenseData = chronologicalExpenseDataInMonth.filter { expense in
            if let type = expense["type"], type == "Expense" {
                return true
            }
                return false
            }
            if recentExpenseData.isEmpty {
                Text("No Expenses")
                    .font(.system(size:30))
                    .font(.title)
                    .foregroundColor(.blue2)
                    .fontWeight(.medium)
                    .padding(.top, 80)
            } else {
                VStack{
                    ScrollView(.vertical){
                        ForEach(recentExpenseData, id: \.self) { expense in
                            ExpenseRow(expense: expense)
                        }
                    }
                }
            }
        }
    }
    
    // Body of HouseView besides TopBar()
    @ViewBuilder
    func HouseBody()-> some View{
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                SummaryCard(isFilter: true)
                    .environmentObject(expenseViewModel)
                TabSelection()
                RecentTransactions()
            }
        }
        .navigationBarHidden(true)
        .background(Color.background1)
        .ignoresSafeArea()
        
        // Filter view overlay
        .overlay {
            FilterView()
        }
        .fullScreenCover(isPresented: $expenseViewModel.addNewExpense) {

        } content: {
            NewExpenseView()
                .environmentObject(expenseViewModel)
        }
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
            .environmentObject(ExpenseViewModel())
    }
}
