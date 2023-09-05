//
//  BleHelper.swift
//  BLE_APP
//
//  Created by UDAY on 05/09/2023.
//

import Foundation
import CoreBluetooth
import UIKit
import SwiftUI

let BLEDeviceSearchKeywords = ["race"] // Put only lower cases

class BleHelper:  NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BleHelper()
    
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    @Published var peripherals = Array<CBPeripheral>()
    @Published var connectionStatus:ConnectStatus = .notconnected
    
    func initialise() {
        
        centralManager = CBCentralManager(delegate: BleHelper.shared, queue: nil)
    }
    //MARK: BLE States.........
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state){
        case.unsupported:
            print("BLE is not supported")
        case.unauthorized:
            print("BLE is unauthorized")
        case.unknown:
            print("BLE is Unknown")
        case.resetting:
            print("BLE is Resetting")
        case.poweredOff:
            print("BLE service is powered off")
        case.poweredOn:
            print("BLE service is powered on")
            print("Start Scanning")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("unknown....")
        }
    }
    //MARK: BLE Discoverd P_names.........

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pname = peripheral.name {
            if iS_Ur_Device(deviceName: pname) {
            let duplicatePeripherals = BleHelper.shared.peripherals.filter({$0.name == pname && $0.identifier == peripheral.identifier})
            print("pnames==\(pname)====\(peripheral.identifier))")
                if duplicatePeripherals.count == 0 {
                    peripherals.append(peripheral)
                }
            }
        }
      
        print(peripherals)
    }
    //MARK: BLE connectToAPeripheral.........

    func connectToAPeripheral(cbPeripheral: CBPeripheral) {
        myPeripheral = cbPeripheral
        myPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(myPeripheral!, options: nil)
        print("Connecting.....")
    }
    //MARK: BLE did connect To Peripheral.........
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected.....")
        self.connectionStatus = .connected
    }
    func disconnect() {
        print(#function)
        
        BleHelper.shared.centralManager.cancelPeripheralConnection(myPeripheral)
        self.connectionStatus = .disconnected
    }
    //MARK: BLE filterd names.........
    func iS_Ur_Device(deviceName: String?) -> Bool {
        if let deviceName = deviceName, !deviceName.isEmpty {
            if BLEDeviceSearchKeywords.filter({$0.contains(deviceName.lowercased()) || deviceName.lowercased().contains($0)}).count > 0 {
                return true
            }
        }
        return false
    }
}

enum ConnectStatus {
    case connecting,connected,notconnected,disconnected
}
