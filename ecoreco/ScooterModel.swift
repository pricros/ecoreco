//
//  ScooterModel.swift
//  ecoreco
//
//  Created by apple on 2016/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

public enum ScooterRunMode {
    case Boost
    case Ride
    case Ekick_extend
    case Ekick_amplified
    case ECO
    
    func describe(value: ScooterRunMode) -> String {
        switch value {
        case .Boost:
            return "0"
        case Ride:
            return "1"
        case Ekick_extend:
            return "2"
        case Ekick_amplified:
            return "3"
        case ECO:
            return "4"
        }
    }
}

public enum ScooterStatus {
    case Standby
    case Fall
    case None
}



protocol ScooterModelRunProtocol:class{
    func onSpeedReceived(speed:Int)
    func onFallDetected()
    
}

protocol ScooterModelLockProtocol:class{
    func onScooterMoved()
    
}

class ScooterModel:NSObject, NRFManagerDelegate{
    weak var delegate: ScooterModelRunProtocol!
    private var nrfManager:NRFManager!
    private var status:ScooterStatus?
    
    static let sharedInstance = ScooterModel()
    
    override init(){
        super.init()
        nrfManager = NRFManager(
            onConnect: {
                self.log("\(__FILE__) \(__LINE__) \nC: ★ Connected")
            },
            onDisconnect: {
                self.log("\(__FILE__) \(__LINE__) \nC: ★ Disconnected")
            },
            onData: {
                (data:NSData?, string:String?)->() in
                self.log("\(__FILE__) \(__LINE__) \nC: ⬇ Received data - String: \(string) - Data: \(data)")
            },
            autoConnect: false
        )
        
        nrfManager.verbose = true
        nrfManager.delegate = self
    }
    
    func log(string:String)
    {
        print(string)
    }
    
    func sendData(string:String)
    {
        let result = self.nrfManager.writeString(string)
        log("\(__FILE__) \(__LINE__) \n⬆ Sent string: \(string) - Result: \(result)")
    }
    
    func setMode(scooterMode:ScooterRunMode)
    {
        var commandString:String = "MODE"
        commandString+=scooterMode.describe(scooterMode)
        sendData(commandString)
    }
    
    func connect(){
        self.nrfManager.connect()
    }
    
    
    func disconnect(){
        self.nrfManager.disconnect()
    }
    
    func getTrip()->Int{
        return 0
    }
    
    func lock()->Bool{
        //send command to lock scooter
        //start a thread to detect thief
        return true
    }
    
    func unlock()->Bool{
        return true
    }
    
    func getEstimateDistance()->Int{
        return 0
    }
    
    func enableCruise()->Bool{
        return true
    }
    
    func disableCruise()->Bool{
        return true
    }
    
    func setSettings()->Bool{
        return true
    }
    
    func getSettings()->NSObject?{
        return nil
    }
    
    func getVersion()->String?{
        return nil
    }
    
    func getBatteryInfo()->Int{
        return 0
    }
    
    func enterStandby()->Bool{
        self.status = .Standby
        // start a thread to get/monitor all the dashboard data including speedmeter, battery,trip, odo, est meter
        
        // start a thread to get fall status
        return true
    }
    
    func exitStandby()->Bool{
        self.status = nil
        return true
    }
}