//
//  DateExtension.swift
//  bt
//
//  Created by Me on 7/3/24.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    func dayOfTheWeek(dayOfWeek: Int) -> Character {
        switch dayOfWeek{
        case 1:
            return Character("S")
        case 2:
            return Character("M")
        case 3:
            return Character("T")
        case 4:
            return Character("W")
        case 5:
            return Character("T")
        case 6:
            return Character("F")
        case 7:
            return Character("S")
        default:
            return Character("N")
        }
    }
}
