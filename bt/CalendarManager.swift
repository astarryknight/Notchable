//
//  CalendarHandler.swift
//  bt
//
//  Created by Me on 7/3/24.
//

import Foundation
import DynamicNotchKit
import EventKit
import SwiftUI

class CalendarManager{
    
    var upcomingEvents = [EKEvent]()
    var alertedEvents = [EKEvent]()
    //var store = EKEventStore()
    var nm = NotchManager()
    
    func getUpcomingEvents(){
        
    }

    func checkEventAlert(){
        self.getUpcomingEvents()
        let date = Date()
        let calendar = Calendar.current
        if (calendar.component(.day, from: date)==calendar.component(.day, from:upcomingEvents[0].startDate)) &&
            (calendar.component(.month, from: date)==calendar.component(.month, from:upcomingEvents[0].startDate)){
            if !(alertedEvents.contains(upcomingEvents[0])){
                //alertEvent()
            }
        }
    }
    
    func getCurrentEvents() -> [EKEvent?] {
        var currentEvents = [EKEvent?]()
        let calendar = Calendar.current
        let date = Date()
        self.getUpcomingEvents()
        
        //refresh the STOREE
        var store = EKEventStore()

        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)

        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.day = 2
        var oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)

        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }


        // Fetch all events that match the predicate.
        store.refreshSourcesIfNecessary()
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = store.events(matching: aPredicate)
        }
        
        for item in events!{
            if !currentEvents.contains(item){
                if (calendar.component(.day, from: date)==calendar.component(.day, from:item.startDate)) &&
                    (calendar.component(.month, from: date)==calendar.component(.month, from:item.startDate)) && (calendar.component(.year, from: date)==calendar.component(.year, from:item.startDate)){
                    if(calendar.component(.hour, from: date)<calendar.component(.hour, from:item.startDate)){
                        var duplicate = false
                        for i in currentEvents{
                            if (item.eventIdentifier == i?.eventIdentifier){
                                currentEvents[currentEvents.firstIndex(of: i)!] = item
                                duplicate = true
                            }
                        }
                        if !duplicate{
                            currentEvents.append(item)
                        }
                    } else if(calendar.component(.hour, from: date)==calendar.component(.hour, from:item.startDate)){
                        if(calendar.component(.minute, from: date)<calendar.component(.minute, from:item.startDate)){
                            var duplicate = false
                            for i in currentEvents{
                                if (item.eventIdentifier == i?.eventIdentifier){
                                    currentEvents[currentEvents.firstIndex(of: i)!] = item
                                    duplicate = true
                                }
                            }
                            if !duplicate{
                                currentEvents.append(item)
                            }
                        }
                    }
                }
            }
        }
        return currentEvents
    }
}
