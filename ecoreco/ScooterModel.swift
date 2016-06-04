//
//  ScooterModel.swift
//  ecoreco
//
//  Created by apple on 2016/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

import Foundation

public enum ScooterRunMode:String {
    case Ride_1_1 = "1"
    case Ride = "2"
    case Ekick_extend = "3"
    case Ekick_amplified = "4"
}

public enum OdoTripType:String {
    case TotalDistanceTraveledinMiles = "ODO1M"
    case TotalDistanceTraveledinKM	= "ODO1K"
    case TurnOnDistanceinMiles 		= "ODO2M"
    case TurnOnDistanceinKM 		= "ODO2K"
    case TripmeterADistanceinMiles	= "ODO3M"
    case TripmeterADistanceinKM	= "ODO3K"
    case TripmeterBDistanceinMiles	= "ODO4M"
    case TripmeterBDistanceinKM	= "ODO4K"
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
    
    let MODE:String = "MODE"
    let MPH:String = "MPH"
    let KMPH:String = "KMPH"
    let ODO:String = "ODO"
    let ODORES:String = "ODORES"
    let REMM:String = "REMM"
    let FALL:String = "FALL"
    let LOCK:String = "LOCK1"
    let UNLOCK:String = "LOCK0"
    let BATT:String = "BATT"
    
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
        sendData(MODE+scooterMode.rawValue)
    }
    
    func connect(){
        self.nrfManager.connect()
    }
    
    
    func disconnect(){
        self.nrfManager.disconnect()
    }
    
    func getTrip(odoType:OdoTripType)->Int{
        
        return 0
    }
    
    func resetTrip(odoType:OdoTripType)->Bool{
        return true
    }
    
    func lock()->Bool{
        //send command to lock scooter
        sendData(LOCK)
        //start a thread to detect thief
        return true
    }
    
    func unlock()->Bool{
        sendData(UNLOCK)
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
    
    func getSpeed()->Int{
        sendData(MPH)
        return 0
    }
    
    func enterStandby()->Bool{
        self.status = .Standby
        // start a thread to get/monitor all the dashboard data including speedmeter, battery,trip, odo, est meter
        backgroundThread(background:{
            
        },
                         completion:{
                            
        })
        // start a thread to get fall status
        return true
    }
    
    func exitStandby()->Bool{
        self.status = nil
        return true
    }
    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion:(() -> Void)?){
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue),0)){
            if(background != nil){ background!()}
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()){
                if (completion != nil){completion!()}
            }
        }
    }
}