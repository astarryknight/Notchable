//
//  CalendarHandler.swift
//  bt
//
//  Created by Me on 7/3/24.
//

import Foundation
import DynamicNotchKit
import EventKit

class CalendarManager{
    
    var upcomingEvents = [EKEvent]()
    var alertedEvents = [EKEvent]()
    var store = EKEventStore()
    var nm = NotchManager()
    
    func getUpcomingEvents(){
        // Get the appropriate calendar.
        var calendar = Calendar.current

        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = -1
        var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)


        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.day = 7
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
        for item in events!{
            if !upcomingEvents.contains(item){
                upcomingEvents.append(item)
            }
        }
        //print(upcomingEvents)
    }
    func getNextEvent() -> EKEvent{
        self.getUpcomingEvents()
        return upcomingEvents[0]
    }
    func checkEventAlert(){
        self.getUpcomingEvents()
        let date = Date()
        let calendar = Calendar.current
        if (calendar.component(.day, from: date)==calendar.component(.day, from:upcomingEvents[0].startDate)) &&
            (calendar.component(.month, from: date)==calendar.component(.month, from:upcomingEvents[0].startDate)){
            if !(alertedEvents.contains(upcomingEvents[0])){
                alertEvent()
            }
        }
    }
    
    func alertEvent(){
        alertedEvents.append(upcomingEvents[0])
    }
    
    func testEvent(){
        self.getUpcomingEvents()
    }
}
