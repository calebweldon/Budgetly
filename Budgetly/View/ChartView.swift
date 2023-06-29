//
//  ChartsView.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/24/23.
//

import SwiftUI
import SwiftUICharts

struct ChartsView: View {
    
    // Environment values
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @State private var selectedTab: Tab = .house
    @Namespace var animation
    init(){
        UITabBar.appearance().isHidden = true
    }
   
    // View
    var body: some View {
        VStack{
            // Calendar bar
            CalendarBar()
            
            // Title and date text
            TitleDateSummary()
                .padding(.leading,8)
            
            // Tab selector
            TabSelection()
                .padding(.top,5)
            
            ScrollView{
                // Pie chart tab
                if expenseViewModel.chartTabName == "Pie" {
                    VStack{
                        // Pie chart
                        pieChartView()
                        
                        // Category scroller
                        categoryScroll()
                    }
                    .background{
                        Rectangle()
                            .fill(Color.backgroundGradient)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .shadow(color: Color.background2.opacity(0.4), radius: 5)
                            .offset(y:230)
                    }
                
                // Line chart tab
                } else {
                    VStack{
                        // Total balance line chart
                        LineChartView(type: "All")
                        
                        ScrollView(.horizontal){
                            HStack(spacing: 40){
                                // Income line chart
                                LineChartView(type: "Income")
                                
                                // expenses line chart
                                LineChartView(type: "Expense")
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
            .background(Color.background1)
            .ignoresSafeArea()
            
            // Calendar filter view
            .overlay {
                FilterView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
    
    // Calendar bar
    @ViewBuilder
    func CalendarBar()-> some View{
        HStack{
            Spacer()
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
    
    // Line chart
    @ViewBuilder
    func LineChartView(type: String)->some View{
        // Extract expense data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let lineChartData = type == "All" ? expenseViewModel.getLineChartData(expenseData: chronologicalExpenseDataInMonth)[2]: type == "Income" ? expenseViewModel.getLineChartData(expenseData: chronologicalExpenseDataInMonth)[0] : expenseViewModel.getLineChartData(expenseData: chronologicalExpenseDataInMonth)[1]
        let dataDisplayed = lineChartData.last ?? 0
        let dataDifferencePercent = ((lineChartData.last ?? 0) - (lineChartData.first ?? 0)) / (lineChartData.last ?? 1)
            
        if !lineChartData.isEmpty {
            // Chart card
            CardView(showShadow: false){
                VStack(alignment: .leading, spacing:10){
                        
                    // Title and subtitle
                    VStack(alignment: .leading, spacing:3){
                        HStack{
                            Text(type == "All" ? "Balance" : type == "Income" ? "Income" : "Expenses")
                                .font(.system(size:25))
                                .foregroundColor(type == "All" ? .blue2 : type == "Income" ? .green1 : .red2)
                                .padding(.top,5)
                                .padding(.leading,15)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.trailing,20)
                        ChartLabel("$" + String(format: "%.2f", dataDisplayed), type: .custom(size: 23, padding: EdgeInsets(top: 0, leading: 15, bottom: 0, trailing:0), color: type == "All" ? .blue2 : type == "Income" ? .green1 : .red2), format: "$%.2f")
                    }
                        
                    // Arrow and percent
                    HStack{
                        Image(systemName: dataDifferencePercent >= 0 ? "arrow.up": "arrow.down")
                            .foregroundColor(type == "All" ? .blue2 : type == "Income" ? .green1 : .red2)
                            .font(.system(size:20))
                            .fontWeight(.semibold)
                            .background{
                                Circle()
                                    .foregroundColor(.background1)
                                    .opacity(0.6)
                                    .frame(width: 30, height:30)
                            }
                        Text(String(format: "%.2f", dataDifferencePercent * 100) + "%")
                            .foregroundColor(type == "All" ? .blue2 : type == "Income" ? .green1 : .red2)
                            .font(.system(size:20))
                            .fontWeight(.medium)
                            .offset(x:3)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top,5)
                    
                    // Line chart
                    LineChart()
                }
                .background(Color.backgroundGradient)
            }
            .data(lineChartData)
            .chartStyle(ChartStyle(backgroundColor: ColorGradient(.background2, .background3), foregroundColor: type == "All" ? ColorGradient(.blue1, .blue2) : type == "Income" ? ColorGradient(.green1, .green2) : ColorGradient(.red1, .red2)))
            .frame(width: type == "All" ? 350 : 280, height: type == "All" ? 350 : 280)
                
            // Background
            .background{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.backgroundGradient)
                    .frame(width: type == "All" ? 360 : 290, height: type == "All" ? 360 : 290)
                    .shadow(color: Color.background2.opacity(0.4), radius: 5)
            }
            .padding(.top)
                
        // If data is empty, display empty messages
        } else {
            ZStack{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.backgroundGradient)
                    .frame(width: type == "All" ? 360 : 290, height: type == "All" ? 360 : 290)
                    .shadow(color: Color.background2.opacity(0.4), radius: 5)
                Text(type == "Income" ? "No Income" : "No Expenses")
                    .font(.system(size:25))
                    .font(.title)
                    .foregroundColor(type == "All" ? .blue2 : type == "Income" ? .green1 : .red2)
                    .fontWeight(.medium)
                    .shadow(color: type == "All" ? .blue2.opacity(0.5) : type == "Income" ? .green1.opacity(0.5) : .red2.opacity(0.5), radius: 2)
            }
        }
    }
    
    // Category scroll
    @ViewBuilder
    func categoryScroll()-> some View{
        // Extract expense data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let pieChartData = expenseViewModel.getPieChartCategoryData(expenseData: chronologicalExpenseDataInMonth)
        let allPercents: [String: Double] = ["questionmark": pieChartData[0], "person.2.fill": pieChartData[1], "fork.knife": pieChartData[2], "bag.fill": pieChartData[3], "doc.text.fill": pieChartData[4], "ticket.fill": pieChartData[5], "car.rear.fill": pieChartData[6], "heart.fill": pieChartData[7], "dollarsign": pieChartData[8]]
        
        // Sort percentage data in descending order
        let sortedCategories = allPercents.keys.sorted { key1, key2 in
            let percent1 = allPercents[key1] ?? 0
            let percent2 = allPercents[key2] ?? 0
            return percent1 > percent2
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                // Category tabs
                ForEach(Array(sortedCategories), id: \.self) { category in
                    if allPercents[category] != 0 {
                        VStack(spacing: 18){
                            Text(String(allCategories[category] ?? ""))
                                .font(.system(size:25))
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.top,30)
                            Text(String(format: "%.2f",allPercents[category] ?? 0.0) + "%")
                                .font(.system(size:40))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        // Tab background
                        .background{
                            ZStack{
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(colorDict[category]!)
                                    .frame(width:170,height:200)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.background1, lineWidth: 3)
                                            .shadow(color: Color.background2.opacity(0.4), radius: 5)
                                    )
                                Image(systemName: category)
                                    .opacity(0.08)
                                    .frame(width:170,height:200)
                                    .font(.system(size:120))
                            }
                        }
                        .frame(width:170, height: 200)
                    }
                }
            }
        }
        
        // Background
        .background{
            Rectangle()
                .fill(Color.backgroundGradient)
                .frame(maxWidth: .infinity)
                .frame(height:200)
                .shadow(color: Color.background2.opacity(0.4), radius: 5)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    // Pie chart
    @ViewBuilder
    func pieChartView()-> some View{
        // Extract expense data
        let chronologicalExpenseDataInMonth = expenseViewModel.getExpenseData()
        let pieChartData = expenseViewModel.getPieChartCategoryData(expenseData: chronologicalExpenseDataInMonth)
        let dataDisplayed = pieChartData.max() ?? 0
        
        VStack{
            if !chronologicalExpenseDataInMonth.isEmpty {
                // Displays pie chart if data is not empty
                CardView(showShadow: false) {
                    VStack(spacing: 8){
                        
                        // Title and subtitle
                        VStack(alignment: .leading, spacing:3){
                            HStack{
                                Text("Categories")
                                    .font(.system(size:30))
                                    .foregroundColor(.blue2)
                                    .fontWeight(.semibold)
                                    .padding(.leading,15)
                                    .padding(.bottom,8)
                                Spacer()
                            }
                            ChartLabel(String(format: "%.2f%%", dataDisplayed), type: .custom(size: 25, padding: EdgeInsets(top: 0, leading: 15, bottom: 0, trailing:0), color: .blue2), format: "%.2f%%")
                        }
                        
                        // Pie chart
                        PieChart()
                            .background(Color.backgroundGradient)
                            .padding(.bottom)
                    }
                    .background(Color.backgroundGradient)
                }
                .data(pieChartData)
                .chartStyle(ChartStyle(backgroundColor: ColorGradient(.background2, .background3), foregroundColor: [ColorGradient(.white1, .white2), ColorGradient(.purple1, .purple2), ColorGradient(.orange1, .orange2),ColorGradient(.pink1, .pink2),ColorGradient(.red1, .red2),ColorGradient(.yellow1, .yellow2),ColorGradient(.blue1, .blue2),ColorGradient(.darkBlue1, .darkBlue2),ColorGradient(.green1, .green2)]))
                .frame(width: 350, height: 350)
                // Background
                .background{
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.backgroundGradient)
                        .frame(width:360,height:360)
                        .shadow(color: Color.background2.opacity(0.4), radius: 5)
                }
                .padding(.top)
            
            // Displays "No Transactions" if data is empty
            } else {
                ZStack{
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.backgroundGradient)
                        .frame(width:360,height:360)
                        .shadow(color: Color.background2.opacity(0.4), radius: 5)
                    Text("No Transactions")
                        .font(.system(size:30))
                        .font(.title)
                        .foregroundColor(.blue2)
                        .fontWeight(.medium)
                        .shadow(color: .blue2.opacity(0.5), radius: 2)
                }
            }
        }
    }
    
    // Tab Selector
    @ViewBuilder
    func TabSelection() -> some View {
        HStack(spacing:0){
            ForEach(["Pie", "Line"], id: \.self) { tab in
                Text(tab + " Charts")
                    .font(.system(size:17))
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(expenseViewModel.chartTabName == tab ? .black : .blue2)
                    .opacity(expenseViewModel.chartTabName == tab ? 1 : 0.7)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background {
                        
                        // Matched geometry
                        if expenseViewModel.chartTabName == tab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.orangeGradient)
                                .shadow(color: .orange2.opacity(0.8), radius: 5)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            expenseViewModel.chartTabName = tab
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
    
    // Title and date text
    @ViewBuilder
    func TitleDateSummary()-> some View{
        HStack{
            VStack(alignment: .leading){
                Text("Charts")
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
        .offset(x:-10)
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
            .environmentObject(ExpenseViewModel())
    }
}
