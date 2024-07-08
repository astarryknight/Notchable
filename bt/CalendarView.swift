//
//  CalendarView.swift
//  bt
//
//  Created by Me on 7/3/24.
//

import SwiftUI
import EventKit

var cm = CalendarManager()

struct CalendarView: View {
    
    var currentEvents: [EKEvent?]
    
    init(currentEvents: [EKEvent?]){
        self.currentEvents = currentEvents
    }
    
    var body: some View {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        VStack(spacing: 8){
            HStack(alignment: .top, spacing: 50){
                Text("\(date.month.prefix(3))").font(.system(size:35, weight: .bold))
                VStack(spacing: 2) {
                    Text("\(date.dayOfTheWeek(dayOfWeek: calendar.dateComponents([.weekday], from: date.dayBefore).weekday!))")
                        .foregroundStyle(.gray)
                    //Text("\(calendar.component(.day, from: date.dayBefore))")
                    
                    Text("\(day-1)")
                        .font(.system(size: 20, weight: .bold))
                }
                VStack(spacing: 2) {
                    Text("\(date.dayOfTheWeek(dayOfWeek: calendar.dateComponents([.weekday], from: date).weekday!))")
                        .foregroundStyle(.gray)
                    Text("\(day)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.blue)
                }
                VStack(spacing: 2) {
                    Text("\(date.dayOfTheWeek(dayOfWeek: calendar.dateComponents([.weekday], from: date.dayAfter).weekday!))")
                        .foregroundStyle(.gray)
                    Text("\(day+1)")
                        .font(.system(size: 20, weight: .bold))
                }
                VStack(spacing: 2) {
                    Text("\(date.dayOfTheWeek(dayOfWeek: calendar.dateComponents([.weekday], from: date.dayAfter.dayAfter).weekday!))")
                        .foregroundStyle(.gray)
                    Text("\(day+2)")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            if(currentEvents.count>0){
                NotEmptyEvents()
            } else {
                EmptyEvents()
            }
        }
        
        .padding()
    }
}

struct EmptyEvents: View{
    var body: some View{
        VStack(alignment:.center){
            Image(systemName: "calendar.badge.checkmark")
                .resizable()
                .frame(width:24, height:20)
                .foregroundStyle(.gray)
            Text("All caught up!")
                .foregroundStyle(.gray)
        }.frame(width: 320, height: 75)
            .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
//                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [9]))
                .stroke(Color(.gray), lineWidth: 2)
        )
    }
}

struct NotEmptyEvents: View{
    let currentEvents = cm.getCurrentEvents() //dont like this
    let calendar = Calendar.current
    let date = Date()
    
    var body: some View{
        let minutesUntilEvent = (((calendar.component(.hour, from: currentEvents[0]!.startDate))*60)+(calendar.component(.minute, from: currentEvents[0]!.startDate))) - (((calendar.component(.hour, from: date))*60)+(calendar.component(.minute, from: date)))
        
        HStack(alignment:.center, spacing: 25){
            Image(systemName: "calendar.badge.clock")
                .resizable()
                .frame(width:42, height:35) //6:5?
                .foregroundStyle(.gray)
            VStack(alignment:.leading){
                Text("\(currentEvents[0]!.title)")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                Text("Starting in \(minutesUntilEvent) minutes")
                    .foregroundStyle(.gray)
            }
            VStack(){
                Text("+\(currentEvents.count-1)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text("more")
                    .foregroundStyle(.gray)
            }
        }.frame(width: 320, height: 75)
            .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray), lineWidth: 2)
        )
    }
}
