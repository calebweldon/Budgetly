//
//  FilterView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/27/23.
//

import SwiftUI

struct FilterView: View {
    // Environment values
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Namespace var animation
    
    // View
    var body: some View {
        ZStack{
            // Background blur
            Color.black
                .opacity(expenseViewModel.showFilterView ? 0.75 : 0)
                .ignoresSafeArea()

            // If the calendar view is selected
            if expenseViewModel.showFilterView{
                VStack(alignment: .center, spacing: 8){
                    // Start date
                    Spacer()
                    Text("Start Date")
                        .font(.system(size:16))
                        .font(.caption)
                        .foregroundColor(.blue2)
                    DatePicker("", selection: $expenseViewModel.startDate, in: Date.distantPast...Date(), displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .font(.title3)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.orangeGradient)
                                .shadow(color: .orange2.opacity(0.8), radius: 3)
                        )
                        .padding(.bottom)
                    
                    // End date
                    Text("End Date")
                        .font(.system(size:16))
                        .font(.title3)
                        .padding(.top)
                        .foregroundColor(.blue2)
                    DatePicker("", selection: $expenseViewModel.endDate, in: Date.distantPast...Date(), displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .font(.title2)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.orangeGradient)
                                .shadow(color: .orange2.opacity(0.8), radius: 3)
                        )
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .frame(width:250, height: 250)
                .background{
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.backgroundGradient)
                        .padding()
                        .shadow(color: Color.background2.opacity(0.4), radius: 5)
                }
                
                // Close button
                .overlay(alignment: .topTrailing){
                    Button{
                        expenseViewModel.showFilterView = false
                    } label: {
                        ZStack{
                            Circle()
                                .frame(width:40,height:40)
                                .foregroundColor(.background4)
                                .opacity(0.8)
                            Image(systemName: "multiply")
                                .font(.system(size:25))
                                .foregroundColor(.gray2)
                        }
                    }
                    .offset(x:-25,y:30)
                }
            }
        }
        // Animation
        .animation(.easeInOut(duration: 0.5), value: expenseViewModel.showFilterView)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environmentObject(ExpenseViewModel())
    }
}
