//
//  SummaryCard.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/20/23.
//

import SwiftUI

struct SummaryCard: View {
    // Environment values
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    var isFilter: Bool = false
    
    // View
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                // Card
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.orangeGradient)
                    .shadow(color: .orange2.opacity(0.8), radius: 5)
                
                VStack{
                    // Date and total balance
                    DateBalanceSummary()
                    
                    Spacer()
                    
                    HStack(spacing:20){
                        
                        // Income summary
                        IncomeSummary()
                        
                        Spacer()
                        
                        // Expense summary
                        ExpenseSummary()
                    }
                    .padding()
                }
                .foregroundColor(.black)
            }
        }
        .frame(height:220)
        .padding()
    }
    
    // Income summary
    @ViewBuilder
    func IncomeSummary()-> some View {
        // Extract data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let data = expenseViewModel.getExpenseTotals(expenseData: chronologicalExpenseDataInMonth)
        
        Image(systemName: "arrow.up")
            .foregroundColor(.greenMoney)
            .font(.system(size:25))
            .fontWeight(.semibold)
            .background{
                Circle()
                    .fill(Color.blue2)
                    .opacity(0.6)
                    .frame(width: 35, height:35)
            }
        VStack(alignment: .leading, spacing: 4){
            Text("Income")
                .font(.system(size:16))
                .font(.title3)
                .fontWeight(.light)
            Text("$" + String(format: "%.2f", data[0]))
                .font(.system(size:18))
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
    
    // Expense summary
    @ViewBuilder
    func ExpenseSummary()-> some View{
        // Extract data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let data = expenseViewModel.getExpenseTotals(expenseData: chronologicalExpenseDataInMonth)
        
        Image(systemName: "arrow.down")
            .foregroundColor(.redMoney)
            .font(.system(size:25))
            .fontWeight(.semibold)
            .background{
                Circle()
                    .foregroundColor(.blue2)
                    .opacity(0.6)
                    .frame(width: 35, height:35)
            }
        VStack(alignment: .leading, spacing: 4){
            Text("Expenses")
                .font(.system(size:16))
                .font(.title3)
                .fontWeight(.light)
            Text("-$" + String(format: "%.2f", data[1]))
                .font(.system(size:18))
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
    
    // Total balance and date summary
    @ViewBuilder
    func DateBalanceSummary()-> some View{
        // Extract data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let data = expenseViewModel.getExpenseTotals(expenseData: chronologicalExpenseDataInMonth)
        
        VStack(spacing: 30){
            // Date
            Text(expenseViewModel.changedMonthDateString())
                .font(.system(size:18))
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top,8)
            
            // Total balance
            Text(data[2] >= 0 ? "$" + String(format: "%.2f", data[2]) : "-$" + String(format: "%.2f", data[2]).dropFirst())
                .font(.system(size:40))
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.top)
    }
}

struct SummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        SummaryCard()
            .environmentObject(ExpenseViewModel())
    }
}
