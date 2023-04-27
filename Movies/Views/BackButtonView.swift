//
//  BackButtonView.swift
//  Movies
//
//  Created by Cristian Chertes on 20.03.2023.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    var body: some View {
        Button {
            self.presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(.white)
                
        }.frame(width: 40, height: 40, alignment: .center)
            .background(Color.black)
            .cornerRadius(16)
            .buttonStyle(IconButtonDefault())
    }
}

struct IconButtonDefault: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.4 : 1.0)
            .animation(.easeOut(duration: 0.6), value: configuration.isPressed)
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView()
    }
}
