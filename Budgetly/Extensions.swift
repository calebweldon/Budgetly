//
//  Extensions.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/18/23.
//

import Foundation
import SwiftUI

extension Color{
    // General Colors
    static let background_light = Color("Background_light")
    static let background_dark = Color("Background_dark")
    static let background1 = Color("Background1")
    static let background2 = Color("Background2")
    static let background3 = Color("Background3")
    static let background4 = Color("Background4")
    static let background5 = Color("Background5")
    static let gray1 = Color("gray1")
    static let gray2 = Color("gray2")
    static let redMoney = Color("redMoney")
    static let greenMoney = Color("greenMoney")
    
    // Icon Gradient Colors
    static let red1 = Color("red1")
    static let red2 = Color("red2")
    static let orange1 = Color("orange1")
    static let orange2 = Color("orange2")
    static let blue1 = Color("blue1")
    static let blue2 = Color("blue2")
    static let green1 = Color("green1")
    static let green2 = Color("green2")
    static let pink1 = Color("pink1")
    static let pink2 = Color("pink2")
    static let purple1 = Color("purple1")
    static let purple2 = Color("purple2")
    static let white1 = Color("white1")
    static let white2 = Color("white2")
    static let darkBlue1 = Color("darkBlue1")
    static let darkBlue2 = Color("darkBlue2")
    static let yellow1 = Color("yellow1")
    static let yellow2 = Color("yellow2")
    static let redGradient = LinearGradient(colors: [Color.red1, Color.red2], startPoint: .bottom, endPoint: .top)
    static let orangeGradient = LinearGradient(colors: [Color.orange1, Color.orange2], startPoint: .bottom, endPoint: .top)
    static let blueGradient = LinearGradient(colors: [Color.blue1, Color.blue2], startPoint: .bottom, endPoint: .top)
    static let greenGradient = LinearGradient(colors: [Color.green1, Color.green2], startPoint: .bottom, endPoint: .top)
    static let pinkGradient = LinearGradient(colors: [Color.pink1, Color.pink2], startPoint: .bottom, endPoint: .top)
    static let purpleGradient = LinearGradient(colors: [Color.purple1, Color.purple2], startPoint: .bottom, endPoint: .top)
    static let whiteGradient = LinearGradient(colors: [Color.white1, Color.white2], startPoint: .bottom, endPoint: .top)
    static let darkBlueGradient = LinearGradient(colors: [Color.darkBlue1, Color.darkBlue2], startPoint: .bottom, endPoint: .top)
    static let yellowGradient = LinearGradient(colors: [Color.yellow1, Color.yellow2], startPoint: .bottom, endPoint: .top)
    static let backgroundGradient = LinearGradient(colors: [Color.background2, Color.background3], startPoint: .bottom, endPoint: .top)
}

// Custom Date Formatter
extension DateFormatter{
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

// String Slicer for dividing expense data
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}


extension View{
    func pressEvent(onPress: @escaping (()->Void), onRelease: @escaping (()->Void))-> some View{
        modifier(ButtonPress(onPress: {onPress()}, onRelease: {onRelease()}))
    }
}
