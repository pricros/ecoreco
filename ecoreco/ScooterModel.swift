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
    case connected
    case standby
    case fall
    case none
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) { UnsafeRawPointer($0).load(as: T.self) }
        i = i+1
        return next.hashValue == i ? next : nil
    }
}

protocol ScooterModelRunProtocol:class{
    func onSpeedReceived(_ speed:Int)
    func onFallDetected()
}

protocol ScooterModelLockProtocol:class{
    func onScooterMoved()
}

protocol ScooterModelProfileProtocol:class{
    func onTripDataReceived(_ type:OdoTripType,value:Int)
    func onEstimateDistanceReceived(_ value:Int)
}

class ScooterModel:NSObject, NRFManagerDelegate{
    static let sharedInstance = ScooterModel()
    weak var runDelegate: ScooterModelRunProtocol!
    weak var lockDelegate: ScooterModelLockProtocol!
    fileprivate var nrfManager:NRFManager!
    static fileprivate var status:ScooterStatus?
    let userDefaults = UserDefaults.standard
    
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
    
    //VER007 command
    let NAM:String = "NAM" //NAMxxxxxxxx , xxxxxxxx is the personalized name
    let FACTORY:String = "FAC" //FAC0 = From Factory, FAC1 = Used
    let ODOTIME:String = "ODT" //return ODTddddhhmmss, dddd= Days, hh=hours,mm=minutes, ss= seconds
    let ODORESET:String = "ODR"
    let CRUISE:String = "CRS"
    let SAFESTART:String = "SAS"
    let CELLVOLTS:String = "CEL" //return CELvvd, vv= voltage in decimal, 
    //d=decimal portion of voltage
    let SENSORSTATUS:String = "SEN" //return SENaeb, 0 = NG, 1=Sensor OK,
    //a(0,1) = Accel, e(0,1) = EEPROM, b(0,1) = battery
    let CHARGINGCYCLES:String = "CHA" // return CHAxxx, xxx = number of charging cycles
    
    let RETRYTIME:Int = 5
    
    let ONE_SECOND:UInt32 = 1000000 //micro second
    
    override init(){
        super.init()
        
        loadDashboardDatafromUserDefault()
        
        nrfManager = NRFManager(
            onConnect: {
                self.log("\(#file) \(#line) \nC: ★ Connected")
                self.getDashboardInfo()
            },
            onDisconnect: {
                self.log("\(#file) \(#line) \nC: ★ Disconnected")
                ScooterModel.status = ScooterStatus.none
            },
            onData: {
                (data:Data?, string:String?)->() in
                self.log("\(#file) \(#line) \nC: ⬇ Received data - String: \(string) - Data: \(data)")
                // parsing data and call relative delegate method
                if let rtnString = string {
                    let rtnCmd = (rtnString as NSString).substring(to: 3)
                    
                    switch rtnCmd {
           
                    case self.MODE :
                        let mode:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,1)))!
                        self.mode.set(mode)
                        self.userDefaults.set(mode, forKey: self.MODE)
                        self.mode.setNeedAck(false)
                        break
                    case self.MPH:
                        let speed:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,3)))!
                        self.speed.set(speed)
                        break
//                    case KMPH:
                    case self.ODO+UnitType.KM.rawValue:
                        let odoType:String = (rtnString as NSString).substring(with: NSMakeRange(3,1))
                        let odoDistance:Int = Int((rtnString as NSString).substring(with: NSMakeRange(4,6)))!

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
                        
                        self.userDefaults.set(odoDistance, forKey: self.ODO+UnitType.KM.rawValue+odoType)
                        
                        break
                   // case ODO+UnitType.Miles:
//                    case ODORES:
//                    case ESTIMATE+UnitType.Miles:
                    case self.ESTIMATE+UnitType.KM.rawValue:
                        let rmm:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,3)))!
                        self.rmm.set(rmm)
                        self.userDefaults.set(rmm, forKey: self.ESTIMATE+UnitType.KM.rawValue)
                        break
                    case self.ARR:
                        self.alrStatus.set(0)
                        self.alrStatus.setNeedAck(false)
                        break
                    case self.FALLRST:
                        self.falStatus.set(0)
                        self.falStatus.setNeedAck(false)
                        break
                    case self.FALL:
                        let fallStatus:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,1)))!
                        self.falStatus.set(fallStatus)
                        break
                    case self.LOCK:
                        let lockStatus:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,1)))!
                        self.lockStatus.set(lockStatus)
                        self.lockStatus.setNeedAck(false)
                        self.userDefaults.set(lockStatus, forKey: self.LOCK)

                        break
                    case self.BATT:
                        let batt:Int = Int((rtnString as NSString).substring(with: NSMakeRange(3,3)))!
                        self.bat.set(batt)
                        self.bat.setNeedAck(false)
                        self.userDefaults.set(batt, forKey: self.BATT)

                        break
//                    case VER:
                    default:
                        break
                    }
                    
                    self.userDefaults.synchronize()
                    
                }
            },
            autoConnect: false
        )
        
        nrfManager.verbose = true
        nrfManager.delegate = self
    }
    
    func log(_ string:String)
    {
        print(string)
    }
    
    
    
    func loadDefaultConfiguration(deviceId:String, userAccount:String?){
        
        let email = userDefaults.string(forKey: Constants.kUserDefaultAccount)
        userDefaults.set(deviceId, forKey: Constants.kUserDefaultAccount)

        //===============setting sample
        userDefaults.set(deviceId, forKey: Constants.kUserDefaultDeviceId)
        //===============end setting sample
        print("##### GET User Device Setting CORE DATA ")
        
        let dcUserDevice = UserDeviceSettingDC()
        let dcDeviceInfo = DeviceInfoDC()

        
        //for testing , delete database first
        #if DEBUG
        dcUserDevice.delete(deviceId: deviceId)
        dcDeviceInfo.delete(deviceId: deviceId)
        #endif
        
        
        if  dcUserDevice.find(
            deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String) == nil
        {
            dcUserDevice.save(deviceId: deviceId, email: nil,
                              emergencycall: Constants.kDefaultSettingEmergencyCall,
                              emergencysms: Constants.kDefaultSettingEmergencyCall,
                              sound: Constants.kDefaultSettingSound,
                              speedLimit: (Constants.kDefaultSpeedLimit) as NSNumber,
                              vibrate: Constants.kDefaultSettingVibrate)
            NSLog("create UserDeviceSettingDC core data : \(deviceId)")
        }
        
        let entity = dcUserDevice.find(
            deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String)
        
            NSLog("found UserDeviceSettingDC core data : \(deviceId)")
            //get db data to user default
            userDefaults.setValue(entity?.emergencycall, forKey: Constants.kUserDefaultEmergencyCall)
            userDefaults.setValue(entity?.emergencysms, forKey: Constants.kUserDefaultEmergencySMSNo)
            userDefaults.set(entity?.vibrate, forKey: Constants.kUserDefaultVibrate)
            userDefaults.set(entity?.sound, forKey: Constants.kUserDefaultSound)
            userDefaults.set(entity?.speedLimit, forKey:Constants.kUserDefaultSpeedLimit)
        
        
        print("##### GET Device Info CORE DATA ")

        if  (dcDeviceInfo.find(
            deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String) == nil)
        {
            dcDeviceInfo.save(deviceId: deviceId,
                              deviceName: "",
                              batteryAmount: 0,
                              estimateRange: 0,
                              mode: 0,
                              odometer: 0)
            NSLog("create DeviceInfoDC core data : \(deviceId)")
        }
        
        let entityDeviceInfo = dcDeviceInfo.find(
            deviceId: userDefaults.object(forKey: Constants.kUserDefaultDeviceId) as! String)
            
            
            print("battery amount\(entityDeviceInfo?.batteryAmount)")
            userDefaults.set(entityDeviceInfo?.deviceName, forKey:Constants.kUserDefaultDeviceName)
            self.bat.set(entityDeviceInfo?.batteryAmount as! Int)
            self.rmm.set(entityDeviceInfo?.estimateRange as! Int)
            self.mode.set(entityDeviceInfo?.mode as! Int)
            self.odkTotal.set(entityDeviceInfo?.odometer as! Int)
            
            NSLog("found DeviceInfoDC core data : \(deviceId)")
    }
    
    func loadDashboardDatafromUserDefault()
    {
        
        let mode:Int = self.userDefaults.integer(forKey: self.MODE)
        self.mode.set(mode)
        
        for tripType in iterateEnum(OdoTripType) {
            let odoDistance:Int = self.userDefaults.integer(forKey: self.ODO+UnitType.KM.rawValue+tripType.rawValue)
      
            switch tripType.rawValue {
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

        }
        

        // case ODO+UnitType.Miles:
        //                    case ODORES:
        //                    case ESTIMATE+UnitType.Miles:
        
        let rmm:Int = self.userDefaults.integer(forKey: self.ESTIMATE+UnitType.KM.rawValue)
        self.rmm.set(rmm)
        
        let lock:Int = self.userDefaults.integer(forKey: self.LOCK)
        self.lockStatus.set(lock)
        
        let batt:Int = self.userDefaults.integer(forKey: self.BATT)
        self.bat.set(batt)
        
    }
    
    func sendData(_ string:String)
    {
        let result = self.nrfManager.writeString(string)
        log("\(#file) \(#line) \n⬆ Sent string: \(string) - Result: \(result)")
    }
    
    func isActived(){
        
    }
    
    func setMode(_ scooterMode:ScooterRunMode)->Bool
    {
        return sendCommandInBackgroundThread(self.MODE+scooterMode.rawValue, observerValue: self.mode)
    }
    
    func connect(){
        self.nrfManager.connect()
    }
    
    func disconnect(){
        self.nrfManager.disconnect()
    }
    
    func getTrip(_ tripType:OdoTripType, unitType:UnitType)->Bool{
        sendData(ODO+unitType.rawValue+tripType.rawValue+ASK)
        return true
    }
    
    func resetTrip(_ odoType:OdoTripType)->Bool{
        sendData(ODORES+odoType.rawValue)
        return true
    }
    
    func lock()->Bool{
        //send command to lock scooter
        return sendCommandInBackgroundThread(self.LOCK+"1", observerValue: self.lockStatus)
        
    }
    
    func unlock()->Bool{
        return sendCommandInBackgroundThread(self.LOCK+"0", observerValue: self.lockStatus)
    }
    
    func getEstimateDistance(_ unitType:UnitType)->Bool{
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
        return sendCommandInBackgroundThread(BATT+ASK, observerValue: self.bat)
    }
    
    func getSpeed()->Bool{
        sendData(MPH+ASK)
        return true
    }
    
    func getFallStatus()->Bool{
        sendData(FALL+ASK)
        return true
    }
    
    func getLockStatus()->Bool{
        sendData(LOCK+ASK)
        return true
    }
    
    func resetFallStatus()->Bool{
        backgroundThread(background:{
            for _ in 1...self.RETRYTIME {
                self.sendData(self.FALLRST)
                self.falStatus.setNeedAck(true)
                usleep(self.ONE_SECOND*3)
                if (!self.falStatus.isNeedAck()){
                    self.enterStandby()
                    break
                }
            }
            },
                         completion:{
        })
        return true
    }
    
    func getAlarmStatus()->Bool{
        sendData(ALR+ASK)
        return true
    }
    
    func resetAlarmStatus()->Bool{
        return sendCommandInBackgroundThread(self.ARR, observerValue: self.alrStatus)
    }
    
    func getStatus()->ScooterStatus?{
        return ScooterModel.status
    }
    
    func setStatus(_ aStatus:ScooterStatus)->Bool{
        ScooterModel.status = aStatus
        return true
    }
    
    func getDashboardInfo()->Bool{
        
        backgroundThread(background:{
            
                self.getBatteryInfo()
                usleep(self.ONE_SECOND*1)
                self.getTrip(OdoTripType.TotalDistanceTraveled,unitType:UnitType.KM)
                usleep(self.ONE_SECOND*1)
                self.getTrip(OdoTripType.TripMeterADistance,unitType:UnitType.KM)
                usleep(self.ONE_SECOND*1)
                self.getEstimateDistance(UnitType.KM)
                usleep(self.ONE_SECOND*1)
            },
                         completion:{
                            
        })
        
        return true
    }

    
    func enterStandby()->Bool{
        if(ScooterModel.status == .standby){
            return false
        }else {
            ScooterModel.status = .standby
            // start a thread to get/monitor all the dashboard data including speedmeter, battery,trip, odo, est meter
            backgroundThread(background:{

                while(ScooterModel.status == .standby){
                    self.getSpeed()
                    usleep(self.ONE_SECOND/2)

                }
                },
                             completion:{
                                
            })
            
            backgroundThread(background:{
                while(ScooterModel.status == .standby){
                    self.getBatteryInfo()
                    usleep(self.ONE_SECOND*10)
                    self.getTrip(OdoTripType.TotalDistanceTraveled,unitType:UnitType.KM)
                    usleep(self.ONE_SECOND*10)
                    self.getTrip(OdoTripType.TripMeterADistance,unitType:UnitType.KM)
                    usleep(self.ONE_SECOND*10)
                    self.getEstimateDistance(UnitType.KM)
                    usleep(self.ONE_SECOND*10)
                }
                },
                             completion:{
                                
            })
            
            backgroundThread(background:{
                while(ScooterModel.status == .standby){
                    self.getFallStatus()
                    usleep(self.ONE_SECOND*3)
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
        ScooterModel.status = .connected
        return true
    }
    
    fileprivate func sendCommandInBackgroundThread(_ command:String, observerValue:Observable<Int> )->Bool{
        backgroundThread(background:{
            for _ in 1...self.RETRYTIME {
                self.sendData(command)
                observerValue.setNeedAck(true)
                usleep(self.ONE_SECOND*3)
                if (!observerValue.isNeedAck()){
                    break
                }
            }
        },
                         completion:{
        })
        return true
        
    }
    
    fileprivate func sendCommandInBackgroundThread(){
        
    }
    
    fileprivate func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion:(() -> Void)?){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async{
            if(background != nil){ background!()}
            
            let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                if (completion != nil){completion!()}
            }
        }
    }
}
