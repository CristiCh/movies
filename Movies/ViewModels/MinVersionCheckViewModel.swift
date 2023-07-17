//
//  MinVersionCheckViewModel.swift
//  Movies
//
//  Created by Cristian Chertes on 06.07.2023.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

class MinVersionCheckViewModel: ObservableObject {
    @Published var shouldUpgrade: Bool = false
    @Published var remoteConfigMinVersion: RemoteConfigMinVersion? = nil
    private var remoteConfig: RemoteConfig? = nil
    
    func getMinVersion() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        
        remoteConfig?.fetch { [self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig?.activate { changed, error in
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            let stringValue = self.remoteConfig?.configValue(forKey: "Min_Version_iOS").stringValue
            if let remoteConfigMinValue = RemoteConfigMinVersion.build(data: stringValue, type: RemoteConfigMinVersion.self) {
                print(remoteConfigMinValue.build)
                print(remoteConfigMinValue.version)
                self.remoteConfigMinVersion = remoteConfigMinValue
                guard let currentBuild = DeviceInfo().build else {
                    return
                }
                self.shouldUpgrade = currentBuild < remoteConfigMinValue.build
            }
        }
    }
    
    func goToAppStore(url: String) {
        guard let _url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(_url)
    }
}

class DeviceInfo {
    var build: Int? {
        guard let code = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return nil
        }
        
        return Int(code)
    }
}
