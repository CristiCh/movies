//
//  UpgradeModalView.swift
//  Movies
//
//  Created by Cristian Chertes on 06.07.2023.
//

import Foundation
import SwiftUI

struct UpgradeModalView: View {
    var isPresented: Bool = false
    var minRemoteConfig: RemoteConfigMinVersion?
    var action: (String) -> Void
    var width: CGFloat {
        UIScreen.main.bounds.width - (isIpad ? 300 : 60)
    }
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        if isPresented, let minRemoteConfig = minRemoteConfig {
            ZStack {
                Color.black.opacity(0.6)
                VStack {
                    Text("You need to upgrade the application, the minimum version is \(minRemoteConfig.version)")
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    HStack {
                        Spacer()
                        Button {
                            action(minRemoteConfig.appStoreURL)
                        } label: {
                            Text("Go to AppStore")
                                .foregroundColor(.black)
                                .font(.body.weight(.semibold))
                        }
                        .padding(20)
                    }
                }.padding(20)
                    .background(.white)
                    .frame(width: width)
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
            .ignoresSafeArea()
        }
    }
}
