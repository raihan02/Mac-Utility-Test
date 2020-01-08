//
//  ViewController.swift
//  SampleTestProject
//
//  Created by uxd on 18/11/19.
//  Copyright © 2019 uxd. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
@available(OSX 10.12, *)
class ViewController: NSViewController {

    
    @IBOutlet weak var auto1: NSButton!
    @IBOutlet weak var manual1: NSButton!
    @IBOutlet weak var backlightLevel: NSLevelIndicator!
    
    @IBOutlet weak var toggleLabel: NSTextField!
    @IBOutlet weak var auto2: NSButton!
    @IBOutlet weak var manual2: NSButton!
    
    @IBOutlet weak var dManual1: NSButton!
    
    
    
    @IBOutlet weak var dAuto2: NSButton!
    @IBOutlet weak var dManual2: NSButton!
    @IBOutlet weak var dAuto1: NSButton!
    
    @IBOutlet weak var displayLavel: NSLevelIndicator!
    
    
    var cnt1 : Int = 0
    var cnt2 : Int = 0
    

    var step1 : Double = 0.0
    var step2 : Double = 0.0
    var flag : Int = 0
    var backLightValidity : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        auto1.isHidden = true
        auto2.isHidden = true
        manual1.isHidden = true
        manual2.isHidden = true
        toggleLabel.isHidden = true
        
        dAuto1.isHidden = true
        dAuto2.isHidden = true
        dManual1.isHidden = true
        dManual2.isHidden = true
        smc_init();
        
        do{
            let obj = try Backlight()
            backLightValidity = obj.getBool()
        }
        catch{
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func test1Button(_ sender: NSButton) {
        auto1.isHidden = false
        manual1.isHidden = false
    }
    
    
    @IBAction func funcForAuto1(_ sender: Any) {
        funAuto1()
    }
    
    @IBAction func manualButton1(_ sender: NSButton) {
        
        if(backLightValidity == false){
        toggleLabel.isHidden = false
        func viewDidAppear() {
            flag = 1
         view.window?.makeFirstResponder(self)
         }
        viewDidAppear()
        }
        else
        {
            motionSensorDebug()
        }
    }
    
    @IBAction func funcForAuto2(_ sender: NSButton) {
       funAuto2()
    }
   
    func funAuto1(){
        var cnt : Int = 0
        
        if backLightValidity == false{
            if #available(OSX 10.12, *) {
                _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                    let obj = try! Backlight()
                    if cnt % 2 == 0{
                        try! obj.on()
                    }
                    else{
                        //print(cnt)
                        try! obj.off()
                    }
                    cnt += 1
                    
                    if(cnt >= 11)
                    {
                        timer.invalidate()
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            motionSensorDebug()
        }
        
    }
    
    override func keyDown(with event: NSEvent) {
     
        if flag == 1 && event.keyCode == 123{
            let obj = try! Backlight()
           try!  obj.off()
        }
        
        if flag == 1 && event.keyCode == 124{
            let obj = try! Backlight()
            try! obj.on()
        }
        //print(flag)
        
        if flag == 2 && event.keyCode == 124{
            cnt1 += 1
            step1 += 409.5
            backlightLevel.intValue = Int32(cnt1)
                       
            if(cnt1 == 11){
                let obj = try! Backlight()
                obj.set(brightness: Backlight.MaxBrightness)
                overFlow()
                cnt1 = 10
                step1 -= 409.5
                return
            }
            let obj = try! Backlight()
            if(step1 < 4095 && step1 >= 0){
               
                obj.set(brightness: UInt64(step1))
            
            }
        }
        
        if flag == 2 && event.keyCode == 123{
            cnt1 -= 1
            step1 -= 409.5
            backlightLevel.intValue = Int32(cnt1)
                       
            if(cnt1 == -1){
                let obj = try! Backlight()
                
                obj.set(brightness: Backlight.MinBrightness)
                underFlow()
                cnt1 = 0
                step1 += 409.5
                return
            }
            
            let obj = try! Backlight()
            if(step1 >= 0.0){
            obj.set(brightness: UInt64(step1))
            }
        }
     
        
        
        // For display Auto
        
        if flag == 3 && event.keyCode == 123{
            setDisplayBrightness(0.1)
        }
        
        if flag == 3 && event.keyCode == 124{
            setDisplayBrightness(1.0)
        }
        
        // For display Manual
        if flag == 4 && event.keyCode == 124{
            step2 += 0.0625
            cnt2 += 1
            print(cnt2)
            displayLavel.intValue = Int32(cnt2)
                       
            if(cnt2 == 17){
                overFlow()
                print(cnt2)
                cnt2 = 16
                step2 -= 0.0625
                setDisplayBrightness(1.0)
                return
            }
            
            
            if(step2 < 1.0 && step2 >= 0.0){
                setDisplayBrightness(Float(step2))
            }
        }
        if flag == 4 && event.keyCode == 123{
                 cnt2 -= 1
                step2 -= 0.0625
                print(cnt2)
                print(step2)
                 displayLavel.intValue = Int32(cnt2)
                            
                 if(cnt2 == -1){
                    
                    setDisplayBrightness(0.6)
                    underFlow()
                    cnt2 = 0
                    step2 += 0.0625
                    
                     return
                 }
                 
                 
                 if(step2 >= 0.0){
                     setDisplayBrightness(Float(step2))
                 }
             }
        
        
    }
    
    @IBAction func test2Button(_ sender: NSButton) {
        
        auto2.isHidden = false
        manual2.isHidden = false
    }
    
    
    func funAuto2(){
        var cnt : Int = 0
        var step : Int = 0
        var value : Double = 0.0
        if backLightValidity == false{
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                print(cnt)
                let obj = try! Backlight()
                if(cnt >= 0 && cnt <= 9)
                {
                    step += 1
                    self.backlightLevel.intValue = Int32(step)
                    value += 409.5
                    if(value <= 4095){
                    obj.set(brightness: UInt64(value))
                    }
                }
                else{
                    step -= 1
                    self.backlightLevel.intValue = Int32(step)
                    value -= 409.5
                    if(value >= 0.0){
                        print(value)
                     obj.set(brightness: UInt64(value))
                    }
                }
                if(cnt == 19)
                {
                    timer.invalidate()
                    let obj = try! Backlight()
                    obj.set(brightness: 2247)
                }
            
                cnt += 1
           })
        }
        else
        {
            motionSensorDebug()
        }
       }
    
       
    @IBAction func funcForManual2(_ sender: Any) {
            if backLightValidity == false{
            func viewDidAppear1() {
                        flag = 2
                        view.window?.makeFirstResponder(self)
               }
                viewDidAppear1()
        }
        else
        {
            motionSensorDebug()
        }
    }
    
    // For display
    
    @IBAction func dTest1(_ sender: Any) {
        dAuto1.isHidden = false
        dManual1.isHidden = false
    }
    
    
    @IBAction func dTest(_ sender: NSButton) {
        dAuto2.isHidden = false
        dManual2.isHidden = false
    }
    
    
    @IBAction func funDauto1(_ sender: NSButton) {
        
        funForDisplayAuto1()
    }
    
    func funForDisplayAuto1()
    {
        var cnt : Int = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if cnt % 2 == 0{
                setDisplayBrightness(0.0)
            }
            else{
                setDisplayBrightness(1.0)
            }
            cnt += 1
            
            if(cnt >= 3)
            {
                timer.invalidate()
                setDisplayBrightness(0.65)
            }
        })
        
    }
    
    
    @IBAction func funDauto2(_ sender: NSButton) {
        funForDisplayAuto2()
    }
    
    func funForDisplayAuto2()
    {
        var cnt : Int = 0
        var step : Int = 0
        var value : Double = 0.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                print(cnt)
                if(cnt >= 0 && cnt <= 15)
                {
                    step += 1
                    self.displayLavel.intValue = Int32(step)
                    value += 0.0625
                    setDisplayBrightness(Float(value))
                }
                else{
                    step -= 1
                    self.displayLavel.intValue = Int32(step)
                    value -= 0.0625
                    setDisplayBrightness(Float(value))
                }
                if(cnt == 31)
                {
                    print(value)
                    timer.invalidate()
                    setDisplayBrightness(0.6)
                }
               // print("Hello")
                cnt += 1
           })
        
    }
    
    
    @IBAction func funDmanual1(_ sender: NSButton) {
        toggleLabel.isHidden = false
        func viewDidAppear2() {
            flag = 3
         view.window?.makeFirstResponder(self)
         }
        viewDidAppear2()
    }
    
    
    @IBAction func funDmanual2(_ sender: NSButton) {
        func viewDidAppear3() {
            flag = 4
         view.window?.makeFirstResponder(self)
         }
        viewDidAppear3()
    }
}

/*
 
 _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
     //print("FIRE!!!")
     if (cnt >= 0 && cnt <= 15){
         tempValue += 0.0625
         setDisplayBrightness(Float(tempValue))
     }
     else{
         print(tempValue)
         tempValue -= 0.0625
         setDisplayBrightness(Float(tempValue))
     }
     //tempValue += 0.0625
     print("Count: ", cnt)
     
     if cnt == 31{
         setDisplayBrightness(Float(self.step))
         timer.invalidate()
         underFlow()
         
     }
     cnt += 1
 })
 */
