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
    case ECO = "5"

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
    case Connected
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
    let alrStatus = Observable<Int>(0)

    
    let MODE:String = "MOD"
    let MPH:String = "MPH"
    let KMPH:String = "KMP"
    let ODO:String = "OD"
    let ODORES:String = "ODR"
    let ESTIMATE:String = "RM"
    let FALL:String = "FAL"
    let FALLRST:String = "FAR"
    let LOCK:String = "LCK"
    let ALR:String = "ALR"
    let ARR:String = "ARR"
    let BATT:String = "BAT"
    let VER:String = "VER"
    let ASK:String = "?"
    
    let SLEEPINTERVAL_SECOND:UInt32 = 1000000 //micro second
    
    override init(){
        super.init()
        nrfManager = NRFManager(
            onConnect: {
                self.log("\(__FILE__) \(__LINE__) \nC: ★ Connected")
                self.getDashboardInfo()
            },
            onDisconnect: {
                self.log("\(__FILE__) \(__LINE__) \nC: ★ Disconnected")
                self.status = ScooterStatus.None
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
                    case self.FALLRST:
                        self.falStatus.set(0)
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
    
    func getEstimateDistance(unitType:UnitType)->Bool{
        sendData(ESTIMATE+unitType.rawValue+ASK)
        return true
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
    
    func getSettings()->Bool{
        return true
    }
    
    func getVersion()->Bool{
        sendData(VER+ASK)
        return true
    }
    
    func getBatteryInfo()->Bool{
        sendData(BATT+ASK)
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
    
    func resetFallStatus()->Bool{
        sendData(FALLRST)
        return true
    }
    
    func getAlarmStatus()->Bool{
        sendData(ALR+ASK)
        return true
    }
    
    func resetAlarmStatus()->Bool{
        sendData(ARR)
        return true
    }
    
    func getStatus()->ScooterStatus?{
        return self.status
    }
    
    func getDashboardInfo()->Bool{
        
        backgroundThread(background:{
            
                self.getBatteryInfo()
                usleep(self.SLEEPINTERVAL_SECOND*1)
                self.getTrip(OdoTripType.TotalDistanceTraveled,unitType:UnitType.KM)
                usleep(self.SLEEPINTERVAL_SECOND*1)
                self.getTrip(OdoTripType.TripMeterADistance,unitType:UnitType.KM)
                usleep(self.SLEEPINTERVAL_SECOND*1)
                self.getEstimateDistance(UnitType.KM)
                usleep(self.SLEEPINTERVAL_SECOND*1)
            },
                         completion:{
                            
        })
        
        return true
    }

    
    func enterStandby()->Bool{
        if(self.status == .Standby){
            return false
        }else {
            self.status = .Standby
            // start a thread to get/monitor all the dashboard data including speedmeter, battery,trip, odo, est meter
            backgroundThread(background:{

                while(self.status == .Standby){
                    self.getSpeed()
                    usleep(self.SLEEPINTERVAL_SECOND/2)

                }
                },
                             completion:{
                                
            })
            
            backgroundThread(background:{
                while(self.status == .Standby){
                    self.getBatteryInfo()
                    usleep(self.SLEEPINTERVAL_SECOND*10)
                    self.getTrip(OdoTripType.TotalDistanceTraveled,unitType:UnitType.KM)
                    usleep(self.SLEEPINTERVAL_SECOND*10)
                    self.getTrip(OdoTripType.TripMeterADistance,unitType:UnitType.KM)
                    usleep(self.SLEEPINTERVAL_SECOND*10)
                    self.getEstimateDistance(UnitType.KM)
                    usleep(self.SLEEPINTERVAL_SECOND*10)
                }
                },
                             completion:{
                                
            })
            
            backgroundThread(background:{
                while(self.status == .Standby){
                    self.getFallStatus()
                    usleep(self.SLEEPINTERVAL_SECOND*3)
                }
                },
                             completion:{
                                
            })

            // start a thread to get fall status
            return true
        }
        return false
    }
    
    func exitStandby()->Bool{
        self.status = .Connected
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