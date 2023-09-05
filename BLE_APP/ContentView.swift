//
//  ContentView.swift
//  BLE_APP
//
//  Created by Uday  on 25/08/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var Ble = BleHelper.shared
    var body: some View {
        VStack(alignment: .leading) {
            Text("Device list")
                .font(.headline)
            ScrollView {
                if Ble.peripherals.isEmpty {
                    
                    Text("No DEVICES FOUND..")
                    
                }else{
                    ForEach(Ble.peripherals,id: \.self) { i in
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("\(i.name ?? "")")
                                    .bold()
                                Text("\(Ble.connectionStatus == .connected ? "Connected" : "Not Connected")")
                            }
                            
                            Spacer()
                            Text(Ble.connectionStatus == .connected ? "Disconnect" : "Connect")
                                .onTapGesture {
                                    
                                    if Ble.connectionStatus == .connected {
                                        Ble.disconnect()
                                        
                                    } else {
                                        Ble.connectToAPeripheral(cbPeripheral: i)
                                    }
                                }
                        }.padding()
                        
                    }
                }
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
