//
//  ExpenseModel.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/18/23.
//

import Foundation
import SwiftUI

// Expense type
enum ExpenseType: String{
    case income = "Income"
    case expense = "Expense"
    case all = "All"
}

// Tab bar tabs
enum Tab: String, CaseIterable {
    case house
    case plusApp
    case graph1
}

// Colors dictionary
let colorDict: [String: LinearGradient] = ["questionmark": Color.whiteGradient, "person.2.fill": Color.purpleGradient, "fork.knife": Color.orangeGradient, "bag.fill": Color.pinkGradient, "doc.text.fill": Color.redGradient, "ticket.fill": Color.yellowGradient, "car.rear.fill": Color.blueGradient, "heart.fill": Color.darkBlueGradient, "dollarsign": Color.greenGradient,]

// Category name dictionary
let allCategories: [String: String] = ["questionmark": "Other", "person.2.fill": "Social", "fork.knife": "Food", "bag.fill": "Shopping", "doc.text.fill": "Bills", "ticket.fill": "Entertainment", "car.rear.fill": "Transportation", "heart.fill": "Personal Care", "dollarsign": "Income"]

// Category type
enum Category: String, Hashable, CaseIterable{
    case Other = "questionmark"
    case Social = "person.2.fill"
    case Food = "fork.knife"
    case Shopping = "bag.fill"
    case Bills = "doc.text.fill"
    case Entertainment = "ticket.fill"
    case Transportation = "car.rear.fill"
    case PersonalCare = "heart.fill"
    case Income = "dollarsign"
}

// Sample expenses
let sampleExpenses: [[String: String]] = [
    ["name": "Expense 1", "amount": "100.0", "type": "Food", "date": "06/15/2023", "category": "car.rear.fill"],
    ["name": "Utilities Jan 6th", "amount": "100", "type": "Income", "date": "06/17/2023", "category": "dollarsign"],
    ["name": "Thanksgiving dinner", "amount": "200.0", "type": "Entertainment", "date": "06/12/2023", "category": "dollarsign"]]
