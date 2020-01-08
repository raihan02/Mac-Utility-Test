//
//  MotionSensorDebug.swift
//  SampleTestProject
//
//  Created by uxd on 20/11/19.
//  Copyright © 2019 uxd. All rights reserved.
//

import Foundation
import Cocoa

func motionSensorDebug()
{
    let debugAlert: NSAlert
    debugAlert = NSAlert()

    debugAlert.messageText = "Motion sensor data can not be read"
    debugAlert.runModal()
}

func overFlow()
{
    let debugAlert: NSAlert
    debugAlert = NSAlert()

    debugAlert.messageText = "Maximum Brightness"
    debugAlert.runModal()
}

func underFlow()
{
    let debugAlert: NSAlert
    debugAlert = NSAlert()

    debugAlert.messageText = "Minimum Brightness"
    debugAlert.runModal()
}

func fanNotification()
{
    let debugAlert: NSAlert
    debugAlert = NSAlert()

    debugAlert.messageText = "System turn off the fan because of low temperature"
    debugAlert.runModal()
    
}
