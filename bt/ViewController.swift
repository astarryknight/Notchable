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
    var store = EKEventStore()
    var timer = Timer()
    var oldList = [String]()
    var newList = [String]()
    //public var oldDevices=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init calendar permissions
        store.requestFullAccessToEvents { granted, error in
            // Handle the response to the request.
        }
        
        //init bluetooth variables
        oldList = bt.getConnectedDevices()
        newList = bt.getConnectedDevices()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.checkDevices()
        })
    }

    func checkDevices(){
        newList=bt.getConnectedDevices()
        if(!(newList==oldList)){
            /*new device connected*/
            if(newList.count>oldList.count){
                for i in 0...newList.count{
                    if(!oldList.contains(newList[i])){
                        print("\(newList[i]) connected!")
                        nm.showBT(name: newList[i], description: "CONNECTED")
                        break
                    }
                }
            }
            //device disconnected
            else{
                for i in 0...oldList.count{
                    if(!newList.contains(oldList[i])){
                        print("\(oldList[i]) disconnected!")
                        nm.showBT(name: oldList[i], description: "DISCONNECTED")
                        break
                    }
                }
            }
        } else{
            print(bt.getConnectedDevices())
        }
        oldList=newList
        
        //handle calendar events - if event is around 10 mins lets say - since it runs every second, gotta be careful to not make it run over itself lol
    }
    
    func fetchCalendarEvents() -> [EKEvent]? /*not sure i can acc do this tho*/{
        // Get the appropriate calendar.
        var calendar = Calendar.current

        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)


        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.year = 1
        var oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)


        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }


        // Fetch all events that match the predicate.
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate)
        }
        return events
    }
}

