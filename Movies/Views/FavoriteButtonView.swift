//
//  FavoriteButtonView.swift
//  Movies
//
//  Created by Cristian Chertes on 12.06.2023.
//

import SwiftUI

struct FavoriteButtonView: View {
    var isFavorite: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .white)
                
        }.frame(width: 40, height: 40, alignment: .center)
            .background(Color.black)
            .cornerRadius(16)
            .buttonStyle(IconButtonDefault())
    }
}
//
//struct IconButtonDefault: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 1.4 : 1.0)
//            .animation(.easeOut(duration: 0.6), value: configuration.isPressed)
//    }
//}

struct FavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FavoriteButtonView(isFavorite: false) {}
            FavoriteButtonView(isFavorite: true) {}
        }
    }
}
