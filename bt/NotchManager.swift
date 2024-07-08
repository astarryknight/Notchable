//
//  NotchManager.swift
//  bt
//
//  Created by Me on 7/2/24.
//

import Foundation
import DynamicNotchKit
import EventKit
import SwiftUI

class NotchManager{
    
    var notch = DynamicNotchInfo(
        systemImage: "speaker.wave.3.fill",
        title: "Figure",
        description: "Looks like a person"
    )
    
    func showBT(name: String, description: String){
        //set default image
        var sysImg = "app.connected.to.app.below.fill"
        //change image based off of device
        if(Array(name.lowercased()).contains("mx")){
            sysImg="computermouse.fill"
        } else if(Array(name.lowercased()).contains("not")||Array(name.lowercased()).contains("airpod")){
            sysImg="airpodspro"
        } else if(Array(name.lowercased()).contains("iphone")){
            sysImg="iphone"
        } else if(Array(name.lowercased()).contains("xbox")){
            sysImg="gamecontroller.fill"
        } else if(Array(name.lowercased()).contains("hd")){
            sysImg="headphones"
        }
        notch.setContent(systemImage: sysImg, title: name, description: description)
        notch.show(for: 2)
    }
    
    func showEvent(event: EKEvent){
        notch.setContent(systemImage: "calendar", title: event.title, description: "IN 10 MINUTES")
        notch.show(for: 2)
    }
    
    func showCalendar(currentEvents: [EKEvent?]){
        var n = DynamicNotch(content: CalendarView(currentEvents: currentEvents))
        n.show(for: 2)
    }
}
