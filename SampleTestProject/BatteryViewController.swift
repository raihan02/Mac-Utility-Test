//
//  BatteryViewController.swift
//  SampleTestProject
//
//  Created by uxd on 8/1/20.
//  Copyright © 2020 uxd. All rights reserved.
//

import Cocoa

class BatteryViewController: NSViewController {
 
    @IBOutlet weak var showTextField: NSTextField!
    
    var getInfoStr  = ""
    var isCharging = false
    var clickCount = 0
    
    
     override func viewDidLoad() {
          super.viewDidLoad()
          
          showTextField.isEnabled = false
      }

      override var representedObject: Any? {
          didSet {
          }
      }
      
      func timeRemaining()
      {
          do{
              let battery = try BatteryService()
            
              let timeRemain = battery.timeRemainingFormatted
              isCharging = battery.isCharging ?? false
              
              if isCharging == false{
                   getInfoStr += "Time Remaining: " + timeRemain + "\n"
              }
              else{
                  getInfoStr += "Need time for full charge: " + timeRemain + "\n"
              }
              
          }
          catch{
              print("Time remaining error")
          }
          
      }
      
      func Percentage()
      {
          do{
              let battery = try BatteryService()
            
              
              getInfoStr = getInfoStr + "Percentage: " + String(battery.percentage!) + "%\n"
              
              
          }
          catch
          {
              print("Percentage error")
          }
      }
      func powerUsage()
      {
          do{
              let battery = try BatteryService()
              
              getInfoStr += "Power Usage: " + String(battery.powerUsage!) + " Watts" + " "
              
              getInfoStr += "( " + String(battery.amperage!) + "mA )\n"
              
              
          }
          
          catch{
              print("Power usage error")
          }
      }
      func Condition()
      {
          do{
              let battery = try BatteryService()
              getInfoStr += "Condition: " + battery.health! + "\n"
              showTextField.stringValue = getInfoStr
          }
          
          catch{
              print("Battery condition error")
          }
      }
      
      func chargeInfo()
      {
          do{
              let battery = try BatteryService()
             
              getInfoStr +=  "Charge: " + String(battery.charge!) + "/" + String(battery.capacity!)
              
              getInfoStr += "mAh\n"
              
           
          }
          catch{
              print("Charge info error")
          }
      }
      
      func cycleCount()
      {
          do{
              let battery = try BatteryService()
              getInfoStr += "Cycle Count: " + String(battery.cycleCount!) + "\n"
          }
          catch{
              print("Cycle count error")
          }
      }
      
      func powerSourceInfo()
      {
          do{
              let battery = try BatteryService()
              getInfoStr += "Power Source: " + battery.powerSource + "\n"
          }
          catch{
              print("Power source error")
          }
      }
      
      func temperatureInfo()
      {
          do{
              let battery = try BatteryService()

              let temp = battery.temperature!
                      
              getInfoStr += "Temperature: " + String(temp) + "°C/ "

              let far = temp * 1.8 + 32
              getInfoStr += String(far) + "°F\n"
              
              
          }
          catch{
              print("Temperature error")
          }
      }
      
      func getInfoFromString()
      {
          showTextField.stringValue = getInfoStr
      }
      @IBAction func showButton(_ sender: NSButton) {
          
          clickCount = clickCount + 1
          
          if(clickCount == 1){
          //print(clickCount)
          showTextField.isEnabled = true
          timeRemaining()
          Percentage()
          Condition()
          powerUsage()
          chargeInfo()
          cycleCount()
          powerSourceInfo()
          temperatureInfo()
          getInfoFromString()
          }
      }
    
 
}
