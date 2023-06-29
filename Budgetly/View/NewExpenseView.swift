//
//  NewExpenseView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/19/23.
//

import SwiftUI

struct NewExpenseView: View {
    // Environment values
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @State private var selectedTab: Tab = .plusApp
    @State private var selectedCategory: Category = .Other
    @State private var isPressed = false
    
    // Saves data to user defaults
    private func saveDataToUserDefaults() {
        let userDefaults = UserDefaults.standard
        var expenses = userDefaults.array(forKey: "expenses") as? [[String: Any]] ?? []
        
        let expense: [String: Any] = [
            "name": expenseViewModel.name.replacingOccurrences(of: "\"", with: "") as NSString,
            "amount": expenseViewModel.amount as NSString,
            "type": expenseViewModel.type.rawValue as NSString,
            "date": expenseViewModel.dateString(from: expenseViewModel.date) as NSString,
            "category": selectedCategory.rawValue as NSString
        ]
        expenses.append(expense)
        userDefaults.set(expenses, forKey: "expenses")
    }
    
    // View
    var body: some View {
        VStack{
            // Category picker
            CategoryPicker()
            
            Spacer()
            
            // Currency field
            CurrencyField()
            
            // Other input fields
            VStack(alignment: .leading, spacing: 30){
                DescriptionField()
                TypeField()
                DateField()
            }
            .offset(y: 25)
            
            Spacer()
            
            // Save button
            SaveButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
    
    // Save button
    @ViewBuilder
    func SaveButton()-> some View{
        Button{
            saveDataToUserDefaults()
        } label:{
            Text("Save")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .font(.title2)
                .frame(maxWidth: .infinity)
                .background{
                    // Background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.orangeGradient)
                        .frame(maxWidth: .infinity)
                        .frame(height:50)
                }
        }
        .padding(.horizontal,30)
        .disabled(expenseViewModel.name == "" || expenseViewModel.type == .all || expenseViewModel.amount == "")
        .opacity(expenseViewModel.name == "" || expenseViewModel.type == .all || expenseViewModel.amount == "" ? 0.6 : 1)
        .padding(.bottom, 40)
        
        // Animation
        .scaleEffect(isPressed ? 1.1 : 1.0)
        .opacity(isPressed ? 0.6: 1.0)
        .pressEvent {
            withAnimation(.easeIn(duration: 0.1)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation {
                isPressed = false
            }
        }
    }
    
    // Description field
    @ViewBuilder
    func DescriptionField()-> some View{
        ZStack{
            // Background
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.background2.opacity(0.4), lineWidth: 3)
                }
                .shadow(color: .blue2.opacity(0.4), radius:3)
                .frame(maxWidth: .infinity)
                .frame(height:70)
                .foregroundColor(.background1)
            
            // Text and icon
            HStack{
                Image(systemName: "bubble.left")
                    .foregroundColor(.gray2)
                    .font(.system(size: 20))
                Label {
                    TextField("Description",text: $expenseViewModel.name)
                        .foregroundColor(.blue2)
                        .font(.title2)
                        .padding(.leading,10)
                        .background{
                            HStack{
                                Text(expenseViewModel.name == "" ? "Description" :
                                        expenseViewModel.name)
                                .font(.title2)
                                .foregroundColor(.blue2)
                                .padding(.leading,10)
                                .opacity(0.4)
                                Spacer()
                            }
                        }
                } icon: {}
                Spacer()
            }
            .padding(.leading,20)
        }
        .padding(.horizontal,15)
        .frame(maxWidth: .infinity)
    }
    
    // Type field
    @ViewBuilder
    func TypeField()-> some View{
        ZStack{
            // Background
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.background2.opacity(0.4), lineWidth: 3)
                }
                .shadow(color: .blue2.opacity(0.4), radius:3)
                .frame(maxWidth: .infinity)
                .frame(height:70)
                .foregroundColor(.background1)
            
            // Text and icon
            HStack{
                Image(systemName: "checklist")
                    .foregroundColor(.gray2)
                    .font(.system(size: 20))
                Label {
                    CustomCheckboxes()
                } icon: {}
                Spacer()
            }
            .padding(.leading,20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
    }
    
    // Date field
    @ViewBuilder
    func DateField()-> some View{
        ZStack{
            // Background
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.background2.opacity(0.4), lineWidth: 3)
                }
                .shadow(color: .blue2.opacity(0.4), radius:3)
                .frame(maxWidth: .infinity)
                .frame(height:70)
                .foregroundColor(.background1)
            
            // Text and icon
            HStack{
                Image(systemName: "calendar")
                    .foregroundColor(.gray2)
                    .font(.system(size: 20))
                Label {
                    DatePicker.init("", selection: $expenseViewModel.date, in: Date.distantPast...Date(), displayedComponents: [.date])
                        .labelsHidden()
                        .offset(x:10)
                        .datePickerStyle(.compact)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .background{
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(Color.background2.opacity(0.4), lineWidth: 3)
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.blue2.opacity(0.4))
                                .offset(x:10)
                        }
                } icon: {}
                Spacer()
            }
            .padding(.leading,20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal,15)
        .padding(.bottom,50)
    }
    
    // Currency field
    @ViewBuilder
    func CurrencyField()-> some View{
        if let symbol = expenseViewModel.convertNumberToPrice(value: 0).first{
        
        // User input text field
        TextField("0.00", text: Binding(
            get: { expenseViewModel.amount },
            set: { newValue in
                if newValue.count > 7 {
                    expenseViewModel.amount = String(newValue.prefix(7))
                } else {
                    expenseViewModel.amount = newValue
                }
            }))
            .multilineTextAlignment(.center)
            .foregroundColor(.orange2)
            .font(.system(size: 100))
            .background{
                
                // Placeholder currency text
                Text(expenseViewModel.amount == "" ? "0.00" : expenseViewModel.amount)
                    .font(.system(size:100))
                    .foregroundColor(.orange2)
                    .opacity(0.9)
                    .shadow(color: .orange1.opacity(0.7), radius: 2)
                    .overlay(alignment: .leading) {
                        
                        // Dollar Sign
                        Text(String(symbol))
                            .font(.system(size:75))
                            .foregroundColor(.orange2)
                            .shadow(color: .orange1.opacity(0.7), radius: 2)
                            .opacity(expenseViewModel.amount == "" ? 0.9 : 1)
                            .offset(x: -42, y: -20)
                    }
            }
            .offset(y:-30)
        }
    }
    
    // Category picker
    @ViewBuilder
    func CategoryPicker()-> some View{
        ZStack{
            // Picker
            Picker("", selection: $selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    HStack{
                        Image(systemName: category.rawValue)
                            .tag(category)
                    }
                    .foregroundColor(.blue2.opacity(0.7))
                }
            }
            .pickerStyle(.inline)
            .background{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.background1)
            }
            
            // Text
            Text("Category")
                .font(.system(size: 20))
                .font(.title)
                .foregroundColor(.blue2.opacity(0.4))
                .fontWeight(.medium)
                .padding(.bottom,20)
                .shadow(color: .blue2.opacity(0.7), radius: 2)
                .offset(y:-25)
        }
        .ignoresSafeArea()
    }
    
    // Custom checkboxes
    @ViewBuilder
    func CustomCheckboxes()-> some View{
        HStack{
            ForEach([ExpenseType.income,ExpenseType.expense], id: \.self){type in
                // Checkboxes
                ZStack{
                    // Make Checkbox
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.blue2.opacity(0.4))
                        .frame(width:30, height:30)
                    
                    // Add checkmark to selected checkbox
                    if expenseViewModel.type == type{
                        Image(systemName: "checkmark")
                            .bold(true)
                            .foregroundColor(.blue2)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture{
                    expenseViewModel.type = type
                }
                
                // Icon
                Text(type.rawValue.capitalized)
                    .foregroundColor(.blue2.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading,10)
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExpenseView()
            .environmentObject(ExpenseViewModel())
    }
}
