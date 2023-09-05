//
//  BLE_APPApp.swift
//  BLE_APP
//
//  Created by Uday  on 25/08/2023.
//

import SwiftUI

@main
struct BLE_APPApp: App {
    
    init (){
        BleHelper.shared.initialise()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
