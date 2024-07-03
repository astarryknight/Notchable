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
    var store = EKEventStore()
    
    func getCurrentDay(){
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print("today is: \(day), \(hour), \(minutes)")
    }
    func getUpcomingEvents(){
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
        for item in events!{
            if !upcomingEvents.contains(item){
                upcomingEvents.append(item)
            }
        }
        print(upcomingEvents)
    }
}
