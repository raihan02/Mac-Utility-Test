import Foundation
import IOKit

class Backlight {
    private var isOn = false
    private var isFlashing = false
    private var numberOfToggles = 0
    private var isFlashingOnce = false
    private var connect: mach_port_t = 0
    private var str = "hello"
    private var timer: Timer = Timer()
    
    //static var sharedBacklight =  Backlight()
    static let FastFlashingInterval = 0.02
    static let MediumFlashingInterval = 0.06
    static let SlowFlashingInterval = 0.2
    static let MinBrightness:UInt64 = 0x0
    static var MaxBrightness:UInt64 = 0xfff
    
    private var  flag = false
    
    init() throws {
        
        // Get the AppleLMUController (thing that accesses the light hardware)
        let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("AppleLMUController"))
        
        //print("Service Object: ", serviceObject)
        //if service == 0 { throw SMCError.driverNotFound }
        
        //assert(serviceObject != 0, "Failed to get service object")
        
        if serviceObject == 0 {
            flag = true
            print("Failed")
        }
        // Open the AppleLMUController
        let status = IOServiceOpen(serviceObject, mach_task_self_, 0, &connect)
        
        if(flag == false){
        assert(status == KERN_SUCCESS , "Failed to open IO service")
        }
        // Start with the backlight off
        do{
        try on()
        }
        catch{
            print(error)
        }
    }
    
    
    
    func startFlashing(target: AnyObject, interval: Float64, selector: Selector) {
        self.timer = Timer.scheduledTimer(
            timeInterval: interval, target: target, selector: selector, userInfo: nil, repeats: true)
        
        // We need to add the timer to the mainRunLoop so it doesn't stop flashing when the menu is accessed
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        self.isFlashing = true
    }
    
    func stopFlashing() {
        self.isFlashing = false
        self.timer.invalidate()
    }
    
    func toggle() throws{
        if self.isOn {
            
            do{
                try self.off()
                
            }
            catch{
                print(error)
            }
            
        } else {
            do{
              try self.on()
            }
            catch{
                print(error)
            }
        }
        
        self.numberOfToggles += 1
        if self.numberOfToggles >= 3 && isFlashingOnce {
            self.timer.invalidate()
            isFlashingOnce = false
        }
    }
    
    func on() throws{
        set(brightness: Backlight.MaxBrightness)
        isOn = true
    }
    
    func off() throws {
        set(brightness: Backlight.MinBrightness)
        isOn = false
    }
    
    func set(brightness: UInt64) {
        var output: UInt64 = 0
        var outputCount: UInt32 = 1
        let setBrightnessMethodId:UInt32 = 2
        let input: [UInt64] = [0, brightness]
        
        let status = IOConnectCallMethod(connect, setBrightnessMethodId, input, UInt32(input.count),
                                         nil, 0, &output, &outputCount, nil, nil)
        
        if(flag == false){
        assert(status == KERN_SUCCESS, "Failed to set brightness; status: \(status)")
        }
    }
   
    func printe(vale: Int32) {
        Backlight.MaxBrightness = UInt64(vale * 16)
    }
    
    func getBool() -> Bool{
        return self.flag
    }
    
}




