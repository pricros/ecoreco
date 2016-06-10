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
    case TotalDistanceTraveled = "1"
    case TurnOnDistance		= "2"
    case TripMeterADistance	= "3"
    case TripMeterBDistance	= "4"
}

public enum UnitType:String {
    case KM = "K"
    case Miles = "M"
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

protocol ScooterModelProfileProtocol:class{
    func onTripDataReceived(type:OdoTripType,value:Int)
    func onEstimateDistanceReceived(value:Int)
}

class ScooterModel:NSObject, NRFManagerDelegate{
    weak var runDelegate: ScooterModelRunProtocol!
    weak var lockDelegate: ScooterModelLockProtocol!
    private var nrfManager:NRFManager!
    private var status:ScooterStatus?
    
    static let sharedInstance = ScooterModel()
    
    let speed = Observable<Int>(0)
    let mode = Observable<Int>(0)
    let odkTotal = Observable<Int>(0)
    let odkTurnOn = Observable<Int>(0)
    let odkA = Observable<Int>(0)
    let odkB = Observable<Int>(0)
    let odk5 = Observable<Int>(0)
    let rmm = Observable<Int>(0)
    let lockStatus = Observable<Int>(0)
    let falStatus = Observable<Int>(0)
    let bat = Observable<Int>(0)
    
    
    let MODE:String = "MOD"
    let MPH:String = "MPH"
    let KMPH:String = "KMP"
    let ODO:String = "OD"
    let ODORES:String = "ODR"
    let ESTIMATE:String = "RM"
    let FALL:String = "FAL"
    let LOCK:String = "LCK"
    let BATT:String = "BAT"
    let VER:String = "VER"
    let ASK:String = "?"
    
    let SLEEPINTERVAL:UInt32 = 50000 //micro second
    
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
                // parsing data and call relative delegate method
                if let rtnString = string {
                    let rtnCmd = (rtnString as NSString).substringToIndex(3)
                    
                    switch rtnCmd {
           
                    case self.MODE :
                        let mode:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,1)))!
                        self.mode.set(mode)
                        break
                    case self.MPH:
                        let speed:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,3)))!
                        self.speed.set(speed)
                        break
//                    case KMPH:
                    case self.ODO+UnitType.KM.rawValue:
                        let odoType:String = (rtnString as NSString).substringWithRange(NSMakeRange(3,1))
                        let odoDistance:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(4,5)))!

                        switch odoType {
                        case OdoTripType.TotalDistanceTraveled.rawValue:
                            self.odkTotal.set(odoDistance)
                            break
                        case OdoTripType.TripMeterADistance.rawValue:
                            self.odkA.set(odoDistance)
                            break
                        case OdoTripType.TripMeterBDistance.rawValue:
                            self.odkB.set(odoDistance)
                            break
                        case OdoTripType.TurnOnDistance.rawValue:
                            self.odkTurnOn.set(odoDistance)
                            break
                        default:
                            break
                            
                        }
                        
                        break
                   // case ODO+UnitType.Miles:
//                    case ODORES:
//                    case ESTIMATE+UnitType.Miles:
                    case self.ESTIMATE+UnitType.KM.rawValue:
                        let rmm:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,3)))!
                        self.rmm.set(rmm)
                        break
                    case self.FALL:
                        let fallStatus:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,1)))!
                        self.falStatus.set(fallStatus)
                        break
                    case self.LOCK:
                        let lockStatus:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,1)))!
                        self.lockStatus.set(lockStatus)
                        break
                    case self.BATT:
                        var batt:Int = Int((rtnString as NSString).substringWithRange(NSMakeRange(3,3)))!
                        self.bat.set(batt)
                        break
//                    case VER:
                    default:
                        break
                    }
                    
                }
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
    
    func setMode(scooterMode:ScooterRunMode)->Bool
    {
        sendData(MODE+scooterMode.rawValue)
        return true
    }
    
    func connect(){
        self.nrfManager.connect()
    }
    
    
    func disconnect(){
        self.nrfManager.disconnect()
    }
    
    func getTrip(tripType:OdoTripType, unitType:UnitType)->Bool{
        sendData(ODO+unitType.rawValue+tripType.rawValue+ASK)
        return true
    }
    
    func resetTrip(odoType:OdoTripType)->Bool{
        sendData(ODORES+odoType.rawValue)
        return true
    }
    
    func lock()->Bool{
        //send command to lock scooter
        sendData(LOCK+"1")
        //start a thread to detect thief
        return true
    }
    
    func unlock()->Bool{
        sendData(LOCK+"0")
        return true
    }
    
    func getEstimateDistance(unitType:UnitType)->Int{
        sendData(ESTIMATE+unitType.rawValue+ASK)
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
        sendData(VER+ASK)
        return nil
    }
    
    func getBatteryInfo()->Bool{
        return true
    }
    
    func getSpeed()->Bool{
        sendData(MPH+ASK)
        return true
    }
    
    func getFallStatus()->Bool{
        sendData(FALL+ASK)
        return true
    }
    
    func enterStandby()->Bool{
        if(self.status == .Standby){
            return false
        }else{
            self.status = .Standby
            // start a thread to get/monitor all the dashboard data including speedmeter, battery,trip, odo, est meter
            backgroundThread(background:{

                while(self.status == .Standby){
                    self.getSpeed()
                    usleep(self.SLEEPINTERVAL)

                    self.getBatteryInfo()
                    usleep(self.SLEEPINTERVAL)
                    
                    self.getTrip(OdoTripType.TotalDistanceTraveled,unitType:UnitType.KM)
                    usleep(self.SLEEPINTERVAL)
                    
                    self.getTrip(OdoTripType.TripMeterADistance,unitType:UnitType.KM)
                    usleep(self.SLEEPINTERVAL)
                    
                    self.getEstimateDistance(UnitType.KM)
                    usleep(self.SLEEPINTERVAL)
                    
                    self.getFallStatus()
                    usleep(self.SLEEPINTERVAL)

                }
                },
                             completion:{
                                
            })
            // start a thread to get fall status
            return true
        }
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