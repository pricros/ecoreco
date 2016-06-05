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
    case None
    case PinIO
    case UART
}

public enum ConnectionStatus {
    case Disconnected
    case Scanning
    case Connected
}



/*!
*  @class NRFManager
*
*  @discussion The manager for nRF8001 connections.
*
*/

// Mark: NRFManager Initialization
public class NRFManager:NSObject, CBCentralManagerDelegate, UARTPeripheralDelegate {
    

    //Private Properties
    private var bluetoothManager:CBCentralManager!
    private var currentPeripheral: UARTPeripheral? {
        didSet {
            if let p = currentPeripheral {
                p.verbose = self.verbose
            }
        }
    }
    
    //Public Properties
    public var verbose = false
    public var autoConnect = true
    public var delegate:NRFManagerDelegate?

    //callbacks
    public var connectionCallback:(()->())?
    public var disconnectionCallback:(()->())?
    public var dataCallback:((data:NSData?, string:String?)->())?
    
    public private(set) var connectionMode = ConnectionMode.None
    public private(set) var connectionStatus:ConnectionStatus = ConnectionStatus.Disconnected {
        didSet {
            if connectionStatus != oldValue {
                switch connectionStatus {
                    case .Connected:
                        
                        connectionCallback?()
                        delegate?.nrfDidConnect?(self)
                    
                    default:

                        disconnectionCallback?()
                        delegate?.nrfDidDisconnect?(self)
                }
            }
        }
    }


    

    

    public class var sharedInstance : NRFManager {
        struct Static {
            static let instance : NRFManager = NRFManager()
        }
        return Static.instance
    }
 
    public init(delegate:NRFManagerDelegate? = nil, onConnect connectionCallback:(()->())? = nil, onDisconnect disconnectionCallback:(()->())? = nil, onData dataCallback:((data:NSData?, string:String?)->())? = nil, autoConnect:Bool = true)
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
    
    private func scanForPeripheral()
    {
        let connectedPeripherals = bluetoothManager.retrieveConnectedPeripheralsWithServices([UARTPeripheral.uartServiceUUID()])

        if connectedPeripherals.count > 0 {
            log("\(__FILE__) \(__LINE__) \nAlready connected ...")
            connectPeripheral(connectedPeripherals[0] as CBPeripheral)
        } else {
            log("\(__FILE__) \(__LINE__) \nScan for Peripherials")
            bluetoothManager.scanForPeripheralsWithServices([UARTPeripheral.uartServiceUUID()], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
    }
    
    private func connectPeripheral(peripheral:CBPeripheral) {
        log("\(__FILE__) \(__LINE__) \nConnect to Peripheral: \(peripheral)")
        
        bluetoothManager.cancelPeripheralConnection(peripheral)
        
        currentPeripheral = UARTPeripheral(peripheral: peripheral, delegate: self)
        
        bluetoothManager.connectPeripheral(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey:false])
    }
    
    private func alertBluetoothPowerOff() {
        log("\(__FILE__) \(__LINE__) \nBluetooth disabled");
        disconnect()
    }
    
    private func alertFailedConnection() {
        log("\(__FILE__) \(__LINE__) \nUnable to connect");
    }

    private func log(logMessage: String) {
        if (verbose) {
            print("NRFManager: \(logMessage)")
        }
    }
}

// MARK: - Public Methods
extension NRFManager {
    
    public func connect() {
        if currentPeripheral != nil && connectionStatus == .Connected {
            log("\(__FILE__) \(__LINE__) \nAsked to connect, but already connected!")
            return
        }
        
        scanForPeripheral()
    }
    
    public func disconnect()
    {
        if currentPeripheral == nil {
            log("\(__FILE__) \(__LINE__) \nAsked to disconnect, but no current connection!")
            return
        }
        
        log("\(__FILE__) \(__LINE__) \nDisconnect ...")
        bluetoothManager.cancelPeripheralConnection((currentPeripheral?.peripheral)!)
    }
    
    public func writeString(string:String) -> Bool
    {
        if let currentPeripheral = self.currentPeripheral {
            if connectionStatus == .Connected {
                currentPeripheral.writeString(string)
                return true
            }
        }
        log("\(__FILE__) \(__LINE__) \nCan't send string. No connection!")
        return false
    }
    
    public func writeData(data:NSData) -> Bool
    {
        if let currentPeripheral = self.currentPeripheral {
            if connectionStatus == .Connected {
                currentPeripheral.writeRawData(data)
                return true
            }
        }
        log("\(__FILE__) \(__LINE__) \nCan't send data. No connection!")
        return false
    }

}

// MARK: - CBCentralManagerDelegate Methods
extension NRFManager {

        public func centralManagerDidUpdateState(central: CBCentralManager)
        {
            log("\(__FILE__) \(__LINE__) \nCentral Manager Did UpdateState")
            if central.state == .PoweredOn {
                //respond to powered on
                log("\(__FILE__) \(__LINE__) \nPowered on!")
                if (autoConnect) {
                    log("\(__FILE__) \(__LINE__) \n AutoConnect!")
                    connect()
                }
                
            } else if central.state == .PoweredOff {
                log("\(__FILE__) \(__LINE__) \nPowered off!")
                connectionStatus = ConnectionStatus.Disconnected
                connectionMode = ConnectionMode.None
            }
        }
    
        public func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber)
        {
            log("\(__FILE__) \(__LINE__) \nDid discover peripheral: \(peripheral.name)")
            bluetoothManager.stopScan()
            connectPeripheral(peripheral)
        }
    
        public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
        {
            log("\(__FILE__) \(__LINE__) \nDid Connect Peripheral")
            if currentPeripheral?.peripheral == peripheral {
                if (peripheral.services) != nil {
                    log("\(__FILE__) \(__LINE__) \nDid connect to existing peripheral: \(peripheral.name)")
                    currentPeripheral?.peripheral(peripheral, didDiscoverServices: nil)
                } else {
                    log("\(__FILE__) \(__LINE__) \nDid connect peripheral: \(peripheral.name)")
                    currentPeripheral?.didConnect()
                }
            }
            connectionStatus = .Connected
        }
    
        public func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?)
        {
            log("\(__FILE__) \(__LINE__) \nPeripheral Disconnected: \(peripheral.name)")
            
            if currentPeripheral?.peripheral == peripheral {
                connectionStatus = ConnectionStatus.Disconnected
                connectionMode = ConnectionMode.None
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
    
    public func didReceiveData(newData:NSData)
    {
       // if connectionStatus == .Connected || connectionStatus == .Scanning {
            log("\(__FILE__) \(__LINE__) \n\(__FILE__) \(__LINE__)Data: \(newData)");
            
            let string = NSString(data: newData, encoding:NSUTF8StringEncoding)
            log("\(__FILE__) \(__LINE__) \nString: \(string)")
            
            dataCallback?(data: newData, string: string! as String)
            delegate?.nrfReceivedData?(self, data:newData, string: string! as String)
            
        //}
    }
    
    public func didReadHardwareRevisionString(string:String)
    {
        log("\(__FILE__) \(__LINE__) \nHW Revision: \(string)")
        connectionStatus = .Connected
    }
    
    public func uartDidEncounterError(error:String)
    {
        log("\(__FILE__) \(__LINE__) \nError: error")
    }
    
}


// MARK: NRFManagerDelegate Definition
@objc public protocol NRFManagerDelegate {
    optional func nrfDidConnect(nrfManager:NRFManager)
    optional func nrfDidDisconnect(nrfManager:NRFManager)
    optional func nrfReceivedData(nrfManager:NRFManager, data:NSData?, string:String?)
}


/*!
*  @class UARTPeripheral
*
*  @discussion The peripheral object used by NRFManager.
*
*/

// MARK: UARTPeripheral Initialization
public class UARTPeripheral:NSObject, CBPeripheralDelegate {
    
    private var peripheral:CBPeripheral
    private var uartService:CBService?
    private var rxCharacteristic:CBCharacteristic?
    private var txCharacteristic:CBCharacteristic?
    
    private var delegate:UARTPeripheralDelegate
    private var verbose = false
    
    private init(peripheral:CBPeripheral, delegate:UARTPeripheralDelegate)
    {
        
        self.peripheral = peripheral
        self.delegate = delegate
        
        super.init()
        
        self.peripheral.delegate = self
    }
}

// MARK: Private Methods
extension UARTPeripheral {
    
    private func compareID(firstID:CBUUID, toID secondID:CBUUID)->Bool {
        return firstID.UUIDString == secondID.UUIDString
        
    }
    
    private func setupPeripheralForUse(peripheral:CBPeripheral)
    {
        log("\(__FILE__) \(__LINE__) \nSet up peripheral for use");
        if let services = peripheral.services {
            for service:CBService in services {
                if let characteristics = service.characteristics {
                    for characteristic:CBCharacteristic in characteristics {
                        if compareID(characteristic.UUID, toID: UARTPeripheral.rxCharacteristicsUUID()) {
                            log("\(__FILE__) \(__LINE__) \nFound RX Characteristics")
                            rxCharacteristic = characteristic
                            peripheral.setNotifyValue(true, forCharacteristic: rxCharacteristic!)
                        } else if compareID(characteristic.UUID, toID: UARTPeripheral.txCharacteristicsUUID()) {
                            log("\(__FILE__) \(__LINE__) \nFound TX Characteristics")
                            txCharacteristic = characteristic
                        } else if compareID(characteristic.UUID, toID: UARTPeripheral.hardwareRevisionStringUUID()) {
                            log("\(__FILE__) \(__LINE__) \nFound Hardware Revision String characteristic")
                            peripheral.readValueForCharacteristic(characteristic)
                        }
                    }
                }
            }
        }
    }
    
    private func log(logMessage: String) {
        if (verbose) {
            print("UARTPeripheral: \(logMessage)")
        }
    }

    private func didConnect()
    {
        log("\(__FILE__) \(__LINE__) \nDid connect")
        
        if peripheral.services != nil {
            log("\(__FILE__) \(__LINE__) \nSkipping service discovery for: \(peripheral.name)")
            peripheral(peripheral, didDiscoverServices: nil)
            return
        }
        
        log("\(__FILE__) \(__LINE__) \nStart service discovery: \(peripheral.name)")
        peripheral.discoverServices([UARTPeripheral.uartServiceUUID(), UARTPeripheral.deviceInformationServiceUUID()])
    }
    
    private func writeString(string:String)
    {
        log("\(__FILE__) \(__LINE__) \nWrite string: \(string)")
        let data = NSData(bytes: string, length: string.characters.count)
        writeRawData(data)
    }
    
    private func writeRawData(data:NSData)
    {
        log("\(__FILE__) \(__LINE__) \nWrite data: \(data)")
        
        if let txCharacteristic = self.txCharacteristic {
            
            if txCharacteristic.properties.intersect(.WriteWithoutResponse) != [] {
                peripheral.writeValue(data, forCharacteristic: txCharacteristic, type: .WithoutResponse)
            } else if txCharacteristic.properties.intersect(.Write) != [] {
                peripheral.writeValue(data, forCharacteristic: txCharacteristic, type: .WithResponse)
            } else {
                log("\(__FILE__) \(__LINE__) \nNo write property on TX characteristics: \(txCharacteristic.properties)")
            }
            
        }
    }
}

// MARK: CBPeripheral Delegate methods
extension UARTPeripheral {
    public func peripheral(peripheral: CBPeripheral, didDiscoverServices error:NSError?) {
        
        if error == nil {
            if let services = peripheral.services {
                for service:CBService in services {
                    if service.characteristics != nil {
                        //var e = NSError()
                        //peripheral(peripheral, didDiscoverCharacteristicsForService: s, error: e)
                    } else if compareID(service.UUID, toID: UARTPeripheral.uartServiceUUID()) {
                        log("\(__FILE__) \(__LINE__) \nFound correct service")
                        uartService = service
                        peripheral.discoverCharacteristics([UARTPeripheral.txCharacteristicsUUID(),UARTPeripheral.rxCharacteristicsUUID()], forService: uartService!)
                    } else if compareID(service.UUID, toID: UARTPeripheral.deviceInformationServiceUUID()) {
                        peripheral.discoverCharacteristics([UARTPeripheral.hardwareRevisionStringUUID()], forService: service)
                    }
                }
            }
        } else {
            log("\(__FILE__) \(__LINE__) \nError discovering characteristics: \(error)")
            delegate.uartDidEncounterError("Error discovering services")
            return
        }
    }
    
    public func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?)
    {
        if error  == nil {
            log("\(__FILE__) \(__LINE__) \nDid Discover Characteristics For Service: \(service.description)")
            if let services = peripheral.services {
                let s = services[services.count - 1]
                if compareID(service.UUID, toID: s.UUID) {
                    setupPeripheralForUse(peripheral)
                }
            }
        } else {
            log("\(__FILE__) \(__LINE__) \nError discovering characteristics: \(error)")
            delegate.uartDidEncounterError("Error discovering characteristics")
            return
        }
    }
    
   public func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        log("\(__FILE__) \(__LINE__) \nDid Update Value For Characteristic")
        if error == nil {
            if characteristic == rxCharacteristic {
                if let value = characteristic.value {
                    log("\(__FILE__) \(__LINE__) \nRecieved: \(value)")
                    delegate.didReceiveData(value)
                }
            } else if compareID(characteristic.UUID, toID: UARTPeripheral.hardwareRevisionStringUUID()){
                log("\(__FILE__) \(__LINE__) \nDid read hardware revision string")
                // FIX ME: This is not how the original thing worked.
                delegate.didReadHardwareRevisionString(NSString(CString:characteristic.description, encoding: NSUTF8StringEncoding)! as String)

            }
        } else {
            log("\(__FILE__) \(__LINE__) \nError receiving notification for characteristic: \(error)")
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
    func didReceiveData(newData:NSData)
    func didReadHardwareRevisionString(string:String)
    func uartDidEncounterError(error:String)
}



