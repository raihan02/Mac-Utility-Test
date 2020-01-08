//
//  FanViewController.swift
//  SampleTestProject
//
//  Created by uxd on 21/11/19.
//  Copyright © 2019 uxd. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
class FanViewController: NSViewController {
    
    @IBOutlet weak var fanLabel: NSTextField!
    @IBOutlet weak var fanPush: NSPopUpButton!
    @IBOutlet weak var currentLabel: NSTextField!
    @IBOutlet weak var minLabel: NSTextField!
    @IBOutlet weak var maxLabel: NSTextField!
    
    var key = [String : Int]()
    
    @IBOutlet weak var speedOne: NSTextField!
    @IBOutlet weak var speedThree: NSTextField!
    @IBOutlet weak var speedTwo: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        speedOne.isHidden = true
        speedTwo.isHidden = true
        speedThree.isHidden = true
        minLabel.isHidden = true
        maxLabel.isHidden = true
        currentLabel.isHidden = true
        
        do{
            try SMCKit.open()
            let fanCount = try! SMCKit.fanCount()
            fanLabel.intValue = Int32(fanCount)
            fanPush.removeAllItems()
            for i in 0 ..< fanCount{
                fanPush.addItem(withTitle: "Fan \(i+1)")
                key["Fan \(i + 1)"] = i
            }
        }
        catch{
            fanLabel.stringValue = "No fan"
            print(error)
        }
        currentLabel.isContinuous = true
    }
    
    
    @IBAction func selectFanButton(_ sender: NSButton) {
        let str =  fanPush.titleOfSelectedItem!
        let id = key[str]!
        maxLabel.intValue = Int32(try! SMCKit.fanMaxSpeed(id))
        minLabel.intValue = Int32(try! SMCKit.fanMinSpeed(id))
        currentLabel.intValue = Int32(try! SMCKit.fanCurrentSpeed(id))
        maxLabel.isHidden = false
    
        let fanInfo = Int32(try! SMCKit.fanCurrentSpeed(id))
        
        if fanInfo <= 0
        {
            fanNotification()
        }
        
        minLabel.isHidden = false
        
        currentLabel.isHidden = false
        
        speedOne.isHidden = false
        speedTwo.isHidden = false
        speedThree.isHidden = false
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            self.currentLabel.intValue = Int32(try! SMCKit.fanCurrentSpeed(id))
            })
    }
    
}
