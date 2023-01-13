//
//  Cardify.swift
//  Celheit_WeatherApp
//
//  Created by Jakub Łata on 12/01/2023.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isRefreshed: Bool) {
        //initialize the view modifier and if the card is face up then rotate to 0 degrees, showing the contents of the card
        rotation = isRefreshed ? 360 : 0
    }
    
    // in order to not let this switch immediately from 0 to 180 degrees we use var animatableData on animatableModifier protocol to struct Cardify
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // custom animation parameter to make sure animation work the way we intend, in degrees
    
    func body(content: Content) -> some View {
        
        ZStack {
            content
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        
    }
    
}
