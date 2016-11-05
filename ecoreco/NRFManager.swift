//
//  NRFManager.swift
//  nRF8001-Swift
//
//  Created by Michael Teeuw on 31-07-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import Foundation
import CoreBluetooth


public enum ConnectionMode {
    case none
    case pinIO
    case uart
}

public enum ConnectionStatus {
    case disconnected
    case scanning
    case connected
}



/*!
*  @class NRFManager
*
*  @discussion The manager for nRF8001 connections.
*
*/

// Mark: NRFManager Initialization
open class NRFManager:NSObject, CBCentralManagerDelegate, UARTPeripheralDelegate {
    

    //Private Properties
    fileprivate var bluetoothManager:CBCentralManager!
    fileprivate var currentPeripheral: UARTPeripheral? {
        didSet {
            if let p = currentPeripheral {
                p.verbose = self.verbose
            }
        }
    }
    
    //Public Properties
    open var verbose = false
    open var autoConnect = true
    open var delegate:NRFManagerDelegate?

    //callbacks
    open var connectionCallback:(()->())?
    open var disconnectionCallback:(()->())?
    open var dataCallback:((_ data:Data?, _ string:String?)->())?
    
    open fileprivate(set) var connectionMode = ConnectionMode.none
    open fileprivate(set) var connectionStatus:ConnectionStatus = ConnectionStatus.disconnected {
        didSet {
            if connectionStatus != oldValue {
                switch connectionStatus {
                    case .connected:
                        
                        connectionCallback?()
                        delegate?.nrfDidConnect?(self)
                    
                    default:

                        disconnectionCallback?()
                        delegate?.nrfDidDisconnect?(self)
                }
            }
        }
    }


    

    

    open class var sharedInstance : NRFManager {
        struct Static {
            static let instance : NRFManager = NRFManager()
        }
        return Static.instance
    }
 
    public init(delegate:NRFManagerDelegate? = nil, onConnect connectionCallback:(()->())? = nil, onDisconnect disconnectionCallback:(()->())? = nil, onData dataCallback:((_ data:Data?, _ string:String?)->())? = nil, autoConnect:Bool = true)
    {
        super.init()
        self.delegate = delegate
        self.autoConnect = autoConnect
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        self.connectionCallback = connectionCallback
        self.disconnectionCallback = disconnectionCallback
        self.dataCallback = dataCallback
    }
    
}

// MARK: - Private Methods
extension NRFManager {
    
    fileprivate func scanForPeripheral()
    {
        let connectedPeripherals = bluetoothManager.retrieveConnectedPeripherals(withServices: [UARTPeripheral.uartServiceUUID()])

        if connectedPeripherals.count > 0 {
            log("\(#file) \(#line) \nAlready connected ...")
            connectPeripheral(connectedPeripherals[0] as CBPeripheral)
        } else {
            log("\(#file) \(#line) \nScan for Peripherials")
            bluetoothManager.scanForPeripherals(withServices: [UARTPeripheral.uartServiceUUID()], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
    }
    
    fileprivate func connectPeripheral(_ peripheral:CBPeripheral) {
        log("\(#file) \(#line) \nConnect to Peripheral: \(peripheral)")
        
        bluetoothManager.cancelPeripheralConnection(peripheral)
        
        currentPeripheral = UARTPeripheral(peripheral: peripheral, delegate: self)
        
        bluetoothManager.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey:false])
    }
    
    fileprivate func alertBluetoothPowerOff() {
        log("\(#file) \(#line) \nBluetooth disabled");
        disconnect()
    }
    
    fileprivate func alertFailedConnection() {
        log("\(#file) \(#line) \nUnable to connect");
    }

    fileprivate func log(_ logMessage: String) {
        if (verbose) {
            print("NRFManager: \(logMessage)")
        }
    }
}

// MARK: - Public Methods
extension NRFManager {
    
    public func connect() {
        if currentPeripheral != nil && connectionStatus == .connected {
            log("\(#file) \(#line) \nAsked to connect, but already connected!")
            return
        }
        
        scanForPeripheral()
    }
    
    public func disconnect()
    {
        if currentPeripheral == nil {
            log("\(#file) \(#line) \nAsked to disconnect, but no current connection!")
            return
        }
        
        log("\(#file) \(#line) \nDisconnect ...")
        bluetoothManager.cancelPeripheralConnection((currentPeripheral?.peripheral)!)
    }
    
    public func writeString(_ string:String) -> Bool
    {
        if let currentPeripheral = self.currentPeripheral {
            if connectionStatus == .connected {
                currentPeripheral.writeString(string)
                return true
            }
        }
        log("\(#file) \(#line) \nCan't send string. No connection!")
        return false
    }
    
    public func writeData(_ data:Data) -> Bool
    {
        if let currentPeripheral = self.currentPeripheral {
            if connectionStatus == .connected {
                currentPeripheral.writeRawData(data)
                return true
            }
        }
        log("\(#file) \(#line) \nCan't send data. No connection!")
        return false
    }

}

// MARK: - CBCentralManagerDelegate Methods
extension NRFManager {

        public func centralManagerDidUpdateState(_ central: CBCentralManager)
        {
            log("\(#file) \(#line) \nCentral Manager Did UpdateState")
            if central.state == .poweredOn {
                //respond to powered on
                log("\(#file) \(#line) \nPowered on!")
                if (autoConnect) {
                    log("\(#file) \(#line) \n AutoConnect!")
                    connect()
                }
                
            } else if central.state == .poweredOff {
                log("\(#file) \(#line) \nPowered off!")
                connectionStatus = ConnectionStatus.disconnected
                connectionMode = ConnectionMode.none
            }
        }
    
        public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
        {
            log("\(#file) \(#line) \nDid discover peripheral: \(peripheral.name)")
            bluetoothManager.stopScan()
            connectPeripheral(peripheral)
        }
    
        public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
        {
            log("\(#file) \(#line) \nDid Connect Peripheral")
            if currentPeripheral?.peripheral == peripheral {
                if (peripheral.services) != nil {
                    log("\(#file) \(#line) \nDid connect to existing peripheral: \(peripheral.name)")
                    currentPeripheral?.peripheral(peripheral, didDiscoverServices: nil)
                } else {
                    log("\(#file) \(#line) \nDid connect peripheral: \(peripheral.name)")
                    currentPeripheral?.didConnect()
                }
            }
            connectionStatus = .connected
        }
    
        public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
        {
            log("\(#file) \(#line) \nPeripheral Disconnected: \(peripheral.name)")
            
            if currentPeripheral?.peripheral == peripheral {
                connectionStatus = ConnectionStatus.disconnected
                connectionMode = ConnectionMode.none
                currentPeripheral = nil
            }
            
            if autoConnect {
                connect()
            }
        }
    
        //optional func centralManager(central: CBCentralManager!, willRestoreState dict: [NSObject : AnyObject]!)
        //optional func centralManager(central: CBCentralManager!, didRetrievePeripherals peripherals: [AnyObject]!)
        //optional func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!)
        //optional func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!)
}

// MARK: - UARTPeripheralDelegate Methods
extension NRFManager {
    
    public func didReceiveData(_ newData:Data)
    {
       // if connectionStatus == .Connected || connectionStatus == .Scanning {
            log("\(#file) \(#line) \n\(#file) \(#line)Data: \(newData)");
            
            let string = NSString(data: newData, encoding:String.Encoding.utf8.rawValue)
            log("\(#file) \(#line) \nString: \(string)")
            
            dataCallback?(newData, string! as String)
            delegate?.nrfReceivedData?(self, data:newData, string: string! as String)
            
        //}
    }
    
    public func didReadHardwareRevisionString(_ string:String)
    {
        log("\(#file) \(#line) \nHW Revision: \(string)")
        connectionStatus = .connected
    }
    
    public func uartDidEncounterError(_ error:String)
    {
        log("\(#file) \(#line) \nError: error")
    }
    
}


// MARK: NRFManagerDelegate Definition
@objc public protocol NRFManagerDelegate {
    @objc optional func nrfDidConnect(_ nrfManager:NRFManager)
    @objc optional func nrfDidDisconnect(_ nrfManager:NRFManager)
    @objc optional func nrfReceivedData(_ nrfManager:NRFManager, data:Data?, string:String?)
}


/*!
*  @class UARTPeripheral
*
*  @discussion The peripheral object used by NRFManager.
*
*/

// MARK: UARTPeripheral Initialization
open class UARTPeripheral:NSObject, CBPeripheralDelegate {
    
    fileprivate var peripheral:CBPeripheral
    fileprivate var uartService:CBService?
    fileprivate var rxCharacteristic:CBCharacteristic?
    fileprivate var txCharacteristic:CBCharacteristic?
    
    fileprivate var delegate:UARTPeripheralDelegate
    fileprivate var verbose = false
    
    fileprivate init(peripheral:CBPeripheral, delegate:UARTPeripheralDelegate)
    {
        
        self.peripheral = peripheral
        self.delegate = delegate
        
        super.init()
        
        self.peripheral.delegate = self
    }
}

// MARK: Private Methods
extension UARTPeripheral {
    
    fileprivate func compareID(_ firstID:CBUUID, toID secondID:CBUUID)->Bool {
        return firstID.uuidString == secondID.uuidString
        
    }
    
    fileprivate func setupPeripheralForUse(_ peripheral:CBPeripheral)
    {
        log("\(#file) \(#line) \nSet up peripheral for use");
        if let services = peripheral.services {
            for service:CBService in services {
                if let characteristics = service.characteristics {
                    for characteristic:CBCharacteristic in characteristics {
                        if compareID(characteristic.uuid, toID: UARTPeripheral.rxCharacteristicsUUID()) {
                            log("\(#file) \(#line) \nFound RX Characteristics")
                            rxCharacteristic = characteristic
                            peripheral.setNotifyValue(true, for: rxCharacteristic!)
                        } else if compareID(characteristic.uuid, toID: UARTPeripheral.txCharacteristicsUUID()) {
                            log("\(#file) \(#line) \nFound TX Characteristics")
                            txCharacteristic = characteristic
                        } else if compareID(characteristic.uuid, toID: UARTPeripheral.hardwareRevisionStringUUID()) {
                            log("\(#file) \(#line) \nFound Hardware Revision String characteristic")
                            peripheral.readValue(for: characteristic)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func log(_ logMessage: String) {
        if (verbose) {
            print("UARTPeripheral: \(logMessage)")
        }
    }

    fileprivate func didConnect()
    {
        log("\(#file) \(#line) \nDid connect")
        
        if peripheral.services != nil {
            log("\(#file) \(#line) \nSkipping service discovery for: \(peripheral.name)")
            peripheral(peripheral, didDiscoverServices: nil)
            return
        }
        
        log("\(#file) \(#line) \nStart service discovery: \(peripheral.name)")
        peripheral.discoverServices([UARTPeripheral.uartServiceUUID(), UARTPeripheral.deviceInformationServiceUUID()])
    }
    
    fileprivate func writeString(_ string:String)
    {
        log("\(#file) \(#line) \nWrite string: \(string)")
        let data = Data(bytes: UnsafePointer<UInt8>(string), count: string.characters.count)
        writeRawData(data)
    }
    
    fileprivate func writeRawData(_ data:Data)
    {
        log("\(#file) \(#line) \nWrite data: \(data)")
        
        if let txCharacteristic = self.txCharacteristic {
            
            if txCharacteristic.properties.intersection(.writeWithoutResponse) != [] {
                peripheral.writeValue(data, for: txCharacteristic, type: .withoutResponse)
            } else if txCharacteristic.properties.intersection(.write) != [] {
                peripheral.writeValue(data, for: txCharacteristic, type: .withResponse)
            } else {
                log("\(#file) \(#line) \nNo write property on TX characteristics: \(txCharacteristic.properties)")
            }
            
        }
    }
}

// MARK: CBPeripheral Delegate methods
extension UARTPeripheral {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error:Error?) {
        
        if error == nil {
            if let services = peripheral.services {
                for service:CBService in services {
                    if service.characteristics != nil {
                        //var e = NSError()
                        //peripheral(peripheral, didDiscoverCharacteristicsForService: s, error: e)
                    } else if compareID(service.uuid, toID: UARTPeripheral.uartServiceUUID()) {
                        log("\(#file) \(#line) \nFound correct service")
                        uartService = service
                        peripheral.discoverCharacteristics([UARTPeripheral.txCharacteristicsUUID(),UARTPeripheral.rxCharacteristicsUUID()], for: uartService!)
                    } else if compareID(service.uuid, toID: UARTPeripheral.deviceInformationServiceUUID()) {
                        peripheral.discoverCharacteristics([UARTPeripheral.hardwareRevisionStringUUID()], for: service)
                    }
                }
            }
        } else {
            log("\(#file) \(#line) \nError discovering characteristics: \(error)")
            delegate.uartDidEncounterError("Error discovering services")
            return
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        if error  == nil {
            log("\(#file) \(#line) \nDid Discover Characteristics For Service: \(service.description)")
            if let services = peripheral.services {
                let s = services[services.count - 1]
                if compareID(service.uuid, toID: s.uuid) {
                    setupPeripheralForUse(peripheral)
                }
            }
        } else {
            log("\(#file) \(#line) \nError discovering characteristics: \(error)")
            delegate.uartDidEncounterError("Error discovering characteristics")
            return
        }
    }
    
   public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        log("\(#file) \(#line) \nDid Update Value For Characteristic")
        if error == nil {
            if characteristic == rxCharacteristic {
                if let value = characteristic.value {
                    log("\(#file) \(#line) \nRecieved: \(value)")
                    delegate.didReceiveData(value)
                }
            } else if compareID(characteristic.uuid, toID: UARTPeripheral.hardwareRevisionStringUUID()){
                log("\(#file) \(#line) \nDid read hardware revision string")
                // FIX ME: This is not how the original thing worked.
                delegate.didReadHardwareRevisionString(NSString(cString:characteristic.description, encoding: String.Encoding.utf8.rawValue)! as String)

            }
        } else {
            log("\(#file) \(#line) \nError receiving notification for characteristic: \(error)")
            delegate.uartDidEncounterError("Error receiving notification for characteristic")
            return
        }
    }
}

// MARK: Class Methods
extension UARTPeripheral {
    class func uartServiceUUID() -> CBUUID {
        return CBUUID(string:"6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    }
    
    class func txCharacteristicsUUID() -> CBUUID {
        return CBUUID(string:"6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    }
    
    class func rxCharacteristicsUUID() -> CBUUID {
        return CBUUID(string:"6e400003-b5a3-f393-e0a9-e50e24dcca9e")
    }
    
    class func deviceInformationServiceUUID() -> CBUUID{
        return CBUUID(string:"180A")
    }
    
    class func hardwareRevisionStringUUID() -> CBUUID{
        return CBUUID(string:"2A27")
    }
}

// MARK: UARTPeripheralDelegate Definition
private protocol UARTPeripheralDelegate {
    func didReceiveData(_ newData:Data)
    func didReadHardwareRevisionString(_ string:String)
    func uartDidEncounterError(_ error:String)
}



