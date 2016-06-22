//
//  FajrWake.swift
//  Fajr Wake
//
//  Created by Abidi on 5/13/16.
//  Copyright © 2016 FajrWake. All rights reserved.
//

import Foundation

// MARK: - Protocols

// MARK: - Error Types


// MARK: - Helper Methods

// local GMT
class LocalGMT {
    class func getLocalGMT() -> Double {
        let localTimeZone = NSTimeZone.localTimeZone().abbreviation!
        let notCorrectedGMTFormat = localTimeZone.componentsSeparatedByString("GMT")
        let correctedGMTFormat: String = notCorrectedGMTFormat[1]
        let gmtArr = correctedGMTFormat.characters.split { $0 == ":" } .map {
            (x) -> Int in return Int(String(x))!
        }
        var gmt: Double = Double(gmtArr[0])
        
        if gmtArr[0] > 0 && gmtArr[1] == 30 {
            gmt += 0.5
        }
        if gmtArr[0] < 0 && gmtArr[1] == 30 {
            gmt -= 0.5
        }
        return gmt
    }
}

class DaysToRepeatLabel {
    class func getTextToRepeatDaysLabel(days: [Days]) -> String {
        var daysInString: [String] = []
        var daysForLabel: String = ""
        
        let weekends = [Days.Saturday, Days.Sunday]
        let weekdays = [Days.Monday, Days.Tuesday, Days.Wednesday, Days.Thursday, Days.Friday]
        
        let daysSet = Set(days)
        let findWeekendsListSet = Set(weekends)
        let findWeekdaysListSet = Set(weekdays)
        
        let containsWeekends = findWeekendsListSet.isSubsetOf(daysSet)
        let containsWeekdays = findWeekdaysListSet.isSubsetOf(daysSet)
        
        if days.count == 7 {
            daysForLabel += "Everyday"
            return daysForLabel
        }
        
        if days.count == 1 {
            daysForLabel += "\(days[0].rawValue)"
            return daysForLabel
        }
        
        // storing enum raw values in array to check if array contains (for array.contains method)
        for day in days {
            daysInString.append(day.rawValue)
        }
        
        if days.count == 2 {
            if containsWeekends {
                daysForLabel += "Weekends"
                return daysForLabel
            }
        }
        
        if days.count == 5 {
            if containsWeekdays {
                daysForLabel += "Weekdays"
                return daysForLabel
            }
        }
        
        for day in days {
            let str = day.rawValue
            daysForLabel += str[str.startIndex.advancedBy(0)...str.startIndex.advancedBy(2)] + " "
        }
        
        return daysForLabel
    }
}

// MARK: - Concrete Types

enum SalatsAndQadhas: Int {
    case Fajr
    case Sunrise
    case Dhuhr
    case Asr
    case Sunset
    case Maghrib
    case Isha
    
    var getString: String {
        switch self {
        case Fajr: return "Fajr"
        case Sunrise: return "Sunrise"
        case Dhuhr: return "Dhuhr"
        case Asr: return "Asr"
        case Sunset: return "Sunset"
        case Maghrib: return "Maghrib"
        case Isha: return "Isha"
        }
    }
}

enum WakeOptions: String {
    case OnTime = "On time"
    case Before = "Before"
    case After = "After"
}

enum Days: String  {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

class FajrWakeAlarm {
    var whenToAlarm: WakeOptions
    var whatSalatToAlarm: SalatsAndQadhas
    var minsToChange: Int
    var daysToRepeat: [Days]
    var snooze: Bool
    var alarmOn: Bool
    var alarmLabel: String
    var daysToRepeatLabel: String
    
    init(whenToAlarm: WakeOptions = .OnTime, whatSalatToAlarm: SalatsAndQadhas = .Fajr, minsToChange: Int = 0, daysToRepeat: [Days] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday], snooze: Bool = true, alarmOn: Bool = true, alarmLabelLabel: String = "Alarm") {
        self.whenToAlarm = whenToAlarm
        self.minsToChange = minsToChange
        self.daysToRepeat = daysToRepeat
        self.snooze = snooze
        self.alarmOn = alarmOn
        self.alarmLabel = alarmLabelLabel
        daysToRepeatLabel = DaysToRepeatLabel.getTextToRepeatDaysLabel(daysToRepeat)
        self.whatSalatToAlarm = whatSalatToAlarm
    }
}


/*
 Reference from PrayerTimes.swift
 CalculationMethods:
 case Jafari = 0  // Ithna Ashari
 case Karachi // University of Islamic Sciences, Karachi
 case Isna  // Islamic Society of North America (ISNA)
 case Mwl // Muslim World League (MWL)
 case Makkah // Umm al-Qura, Makkah
 case Egypt // Egyptian General Authority of Survey
 case Custom  // Custom Setting
 case Tehran  // Institute of Geophysics, University of Tehran

 AsrJuristicMethods:
 case Shafii // Shafii (standard)
 case Hanafi // Hanafi

AdjustingMethods:
    case None // No adjustment
    case MidNight  // middle of night
    case OneSeventh // 1/7th of night
    case AngleBased // floating point number

 TimeForamts:
 case Time24 // 24-hour format
 case Time12 // 12-hour format
 case Time12NS // 12-hour format with no suffix
 case Floating // angle/60th of night
 */

enum PrayerTimeSettingsReference: String {
    case CalculationMethod, AsrJuristic, AdjustHighLats, TimeFormat
}

enum CalculationMethods: Int {
    
    case Jafari = 0
    case Karachi
    case Isna
    case Mwl
    case Makkah
    case Egypt
//    case Custom
    case Tehran = 7
    
    func getString() -> String {
        switch self {
        case .Jafari: return "Shia Ithna Ashari, Leva Research Institute, Qum"
        case .Karachi: return "University of Islamic Sciences, Karachi"
        case .Isna: return "Islamic Society of North America"
        case .Mwl: return "Muslim World League"
        case .Makkah: return "Umm al-Qura University, Makkah"
        case .Egypt: return "Egyptian General Authority of Survey"
//        case .Custom: return "Custom Setting"
        case .Tehran: return "Institute of Geophysics, Tehran University"
        }
    }
}

class UserSettingsPrayertimes {
    let calculationMethod: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.CalculationMethod.rawValue)
    let asrJuristic: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.AsrJuristic.rawValue)
    let adjustHighLats: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.AdjustHighLats.rawValue)
    let timeFormat: Int = NSUserDefaults.standardUserDefaults().integerForKey(PrayerTimeSettingsReference.TimeFormat.rawValue)
    
    func getUserSettings() -> PrayerTimes {
        let userSettings = PrayerTimes(caculationmethod: PrayerTimes.CalculationMethods(rawValue: self.calculationMethod)!, asrJuristic: PrayerTimes.AsrJuristicMethods(rawValue: self.asrJuristic)!, adjustHighLats: PrayerTimes.AdjustingMethods(rawValue: self.adjustHighLats)!, timeFormat: PrayerTimes.TimeForamts(rawValue: self.timeFormat)!)
        return userSettings
    }
    
}







