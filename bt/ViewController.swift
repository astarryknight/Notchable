//
//  ViewController.swift
//  bt
//
//  Created by Me on 7/2/24.
//

import Cocoa
import IOBluetooth
import DynamicNotchKit
import EventKit

class ViewController: NSViewController {

    var bt = BluetoothDevices()
    var nm = NotchManager()
    var cm = CalendarManager()
    //var dn = DynamicNotch(content: CalendarView())
    var store = EKEventStore()
    var timer = Timer()
    var oldList = [String]()
    var newList = [String]()
    //public var oldDevices=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init calendar permissions
        store.requestFullAccessToEvents { granted, error in
            // Reload the event store and request events after permission is granted
            self.store = EKEventStore()
        }
        
        //init bluetooth variables
        oldList = bt.getConnectedDevices()
        newList = bt.getConnectedDevices()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.25, repeats: true, block: { _ in
            self.checkDevices()
        })
        //show test event
        //self.nm.showEvent(event: self.cm.getNextEvent())
    }

    func checkDevices(){
        
        if DynamicNotch.checkIfMouseIsInNotch(){
            nm.showCalendar(currentEvents: cm.getCurrentEvents())
        }
        
        newList=bt.getConnectedDevices()
        if(!(newList==oldList)){
            /*new device connected*/
            if(newList.count>oldList.count){
                for i in 0...newList.count{
                    if(!oldList.contains(newList[i])){
                        //print("\(newList[i]) connected!")
                        nm.showBT(name: newList[i], description: "CONNECTED")
                        break
                    }
                }
            }
            //device disconnected
            else{
                for i in 0...oldList.count{
                    if(!newList.contains(oldList[i])){
                        //print("\(oldList[i]) disconnected!")
                        nm.showBT(name: oldList[i], description: "DISCONNECTED")
                        break
                    }
                }
            }
        } else{
            //print(bt.getConnectedDevices())
        }
        oldList=newList
    }
}
