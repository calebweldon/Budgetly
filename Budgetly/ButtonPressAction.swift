//
//  ButtonPressAction.swift
//  Budgetly
//
//  Created by Caleb Weldon on 6/23/23.
//

import Foundation
import SwiftUI

// Button press animation modifier
struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content)-> some View{
        content
            .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({_ in
                    onPress()
                })
                .onEnded({_ in
                    onRelease()
                })
            )
    }
}
