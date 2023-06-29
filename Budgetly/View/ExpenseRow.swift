//
//  ExpenseRow.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/21/23.
//

import SwiftUI

import SwiftUI

struct ExpenseRow: View {
    // Environment values
    var expense: [String: String]
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    // View
    var body: some View {
        ZStack{
            // Background card
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.backgroundGradient)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .shadow(color: .background2.opacity(0.4), radius:3)
                
            // Card content
            HStack{
                // Icon
                Icon()
                
                // Description and date field
                DescriptionDate()
                
                // Amount field
                Amount()
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
        }
        .padding(.horizontal,10)
        .frame(maxWidth: .infinity, maxHeight: 80)
    }
    
    @ViewBuilder
    func Amount()-> some View{
        // Expense element variables
        let amount = expense["amount"] ?? ""
        let type = expense["type"] ?? ""
        
        Text(type == "Income" ? "+$" + String(format: "%.2f", Double(amount) ?? 0) : "-$" + String(format: "%.2f", Double(amount) ?? 0))
            .font(.system(size:18))
            .font(.title2)
            .fontWeight(.medium)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .foregroundColor(type == "Income" ? .greenMoney : .redMoney)
            .opacity(0.8)
            .padding(.trailing)
    }
    
    @ViewBuilder
    func Icon()-> some View{
        // Expense element variables
        let category = String(expense["category"] ?? "")
        
        Image(systemName: category == "questionmark" || category == "dollarsign" ? category : String(category.dropLast().dropFirst()))
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(category == "questionmark" || category == "dollarsign" ? colorDict[category]! : colorDict[String(category.dropLast().dropFirst())] ?? LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 66, height: 66))
            .font(.system(size:36))
            .frame(width: 66, height: 66)
            .foregroundColor(.black)
            .padding(.leading,8)
    }
    
    @ViewBuilder
    func DescriptionDate()-> some View{
        // Expense element variables
        let name = expense["name"] ?? ""
        let date = expense["date"]?.dropLast().dropFirst() ?? ""
        
        VStack(alignment: .leading, spacing: 5){
            Spacer()
            
            Text(name)
                .font(.system(size:18))
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(date)
                .font(.system(size:16))
                .font(.title3)
                .padding(.bottom,10)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue2.opacity(0.8))
            
            Spacer()
        }
        .padding(.leading,5)
    }
}

struct ExpenseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(expense: sampleExpenses[1])
    }
}
