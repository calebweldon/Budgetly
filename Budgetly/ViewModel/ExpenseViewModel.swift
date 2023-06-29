//
//  ExpenseViewModel.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/18/23.
//

import SwiftUI
import SwiftUICharts

class ExpenseViewModel: ObservableObject {
    
    // Filterable date range
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var activeMonthStartDate: Date = Date()
    
    // Expense/Income tab
    @Published var tabName: ExpenseType = .all
    
    // PieChart vs lineChart tab
    @Published var chartTabName: String = "Pie"
    
    // Filter view
    @Published var showFilterView: Bool = false
    
    // New expense properties
    @Published var addNewExpense: Bool = false
    @Published var name: String = ""
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var category: Category = .Other
    
    
    init(){
        // Gets active month start date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: Date())
        
        startDate = calendar.date(from: components)!
        activeMonthStartDate = calendar.date(from: components)!
    }
    
    // Date range string with current date
    func activeMonthDateString()->String{
        return activeMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " +
        Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    // Date range string with custom selected date range
    func changedMonthDateString()->String{
        return startDate.formatted(date: .abbreviated, time: .omitted) + " - " +
        endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    // Converts date to string
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    // Converts number to price form
    func convertNumberToPrice(value: Double)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    // Returns an array of of all expenses
    func extractExpenseData(expensesString: String)-> [[String: String]]{
        let distinctExpenses = expensesString.components(separatedBy: ", ")
        var expenses: [[String: String]] = []
        
        for expense in distinctExpenses {
            let elementName = expense.slice(from: "name = ", to: ";") ?? ""
            let elementAmount = expense.slice(from: "amount = ", to: ";") ?? ""
            let elementType = expense.slice(from: "type = ", to: ";") ?? ""
            let elementDate = expense.slice(from: "date = ", to: ";") ?? ""
            let elementCategory = expense.slice(from: "category = ", to: ";") ?? ""
            
            let expense = [ "name": elementName, "amount": elementAmount, "type": elementType, "date": elementDate, "category": elementCategory]
            
            expenses.append(expense)
        }
        
        return expenses
    }
    
    // Orders expenses chronologically by date
    func sortExpensesChronologically(expenseData: [[String: String]])->[[String: String]]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let expenseDataSorted = expenseData.sorted { (expense1, expense2) -> Bool in
            guard let date1String = expense1["date"]?.dropLast().dropFirst().description,
                  let date2String = expense2["date"]?.dropLast().dropFirst().description,
                  let date1 = dateFormatter.date(from: date1String),
                  let date2 = dateFormatter.date(from: date2String) else {
                return false
            }
            return date1 < date2
        }
    
        return expenseDataSorted.reversed()
    }
    
    // Orders expenses within the specified startDate and endDate
    func sortExpensesByDate(expenseData: [[String: String]]) -> [[String: String]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let filteredExpenses = expenseData.filter { expense -> Bool in
            guard let dateString = expense["date"]?.dropLast().dropFirst().description,
                  let expenseDate = dateFormatter.date(from: dateString) else {
                return false
            }

            return expenseDate >= startDate && expenseDate <= endDate
        }

        return filteredExpenses
    }
    
    // Extracts data for line charts
    func getLineChartData(expenseData: [[String:String]])-> [[Double]] {
        var incomes: [Double] = []
        var expenses: [Double] = []
        var totals: [Double] = []
        var incomesSum: Double = 0
        var expensesSum: Double = 0
        var totalsSum: Double = 0

        for expense in expenseData {
            if let amountString = expense["amount"],
               let amount = Double(amountString) {
                if expense["type"] == "Income" {
                    incomesSum += amount
                    incomes.append(incomesSum)
                } else {
                    expensesSum += amount
                    expenses.append(expensesSum)
                }
                totalsSum = expense["type"] == "Income" ? totalsSum + amount : totalsSum - amount
                totals.append(totalsSum)
            }
        }
        
        return [incomes, expenses, totals]
    }
    
    // Takes expense data from a string to a chronological list of expenses in selected date Range
    func getExpenseData()-> [[String:String]] {
        if let expenses = UserDefaults.standard.array(forKey: "expenses") {
            let expensesString = expenses.map { String(describing: $0)}.joined(separator: ", ")
            let expenseData = extractExpenseData(expensesString: expensesString)
            let chronologicalExpenseData = sortExpensesChronologically(expenseData: expenseData)
            let chronologicalExpenseDataInMonth = sortExpensesByDate(expenseData: chronologicalExpenseData)
            return chronologicalExpenseDataInMonth
        }
        return []
    }
    
    // Returns totals for income, expenses, and total balance
    func getExpenseTotals(expenseData: [[String:String]])-> [Double] {
        var incomeTotal: Double = 0
        var expenseTotal: Double = 0
        var total: Double = 0
        
        for expense in expenseData {
            if let amountString = expense["amount"],
               let amount = Double(amountString) {
                if expense["type"] == "Income" {
                    incomeTotal += amount
                } else {
                    expenseTotal += amount
                }
            }
        }
        total = incomeTotal - expenseTotal
        return [incomeTotal, expenseTotal, total]
    }
    
    // Extracts data for Pie Chart
    func getPieChartCategoryData(expenseData: [[String:String]])-> [Double] {
        // Initialize total variables
        let otherTotal: Double = 0
        let socialTotal: Double = 0
        let foodTotal: Double = 0
        let shoppingTotal: Double = 0
        let billsTotal: Double = 0
        let entertainmentTotal: Double = 0
        let transportationTotal: Double = 0
        let personalTotal: Double = 0
        let incomeTotal: Double = 0
        var allTotals: [String: Double] = ["questionmark": otherTotal, "person.2.fill": socialTotal, "fork.knife": foodTotal, "bag.fill": shoppingTotal, "doc.text.fill": billsTotal, "ticket.fill": entertainmentTotal, "car.rear.fill": transportationTotal, "heart.fill": personalTotal, "dollarsign": incomeTotal]
        
        // Calculate totals
        for expense in expenseData {
            if let amountString = expense["amount"],
               let amount = Double(amountString) {
                for category in allTotals.keys {
                    if expense["category"] == category || expense["category"]?.dropLast().dropFirst() ?? "" == category {
                        if let categoryTotal = allTotals[category] {
                            allTotals[category] = categoryTotal + amount
                        }
                    }
                }
            }
        }
        
        // Calculate total balance
        let total: Double = allTotals.values.reduce(0, +)
        
        // Calculate percentages
        let otherPercent = total != 0 ? (allTotals["questionmark"]! / total) * 100 : 0
        let socialPercent = total != 0 ? (allTotals["person.2.fill"]! / total) * 100 : 0
        let foodPercent = total != 0 ? (allTotals["fork.knife"]! / total) * 100 : 0
        let shoppingPercent = total != 0 ? (allTotals["bag.fill"]! / total) * 100 : 0
        let billsPercent = total != 0 ? (allTotals["doc.text.fill"]! / total) * 100 : 0
        let entertainmentPercent = total != 0 ? (allTotals["ticket.fill"]! / total) * 100 : 0
        let transportationPercent = total != 0 ? (allTotals["car.rear.fill"]! / total) * 100 : 0
        let personalPercent = total != 0 ? (allTotals["heart.fill"]! / total) * 100 : 0
        let incomePercent = total != 0 ? (allTotals["dollarsign"]! / total) * 100 : 0
        
        return [otherPercent, socialPercent, foodPercent, shoppingPercent, billsPercent, entertainmentPercent, transportationPercent, personalPercent, incomePercent]
    }
}
