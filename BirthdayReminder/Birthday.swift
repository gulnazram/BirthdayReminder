//
//  Birthday.swift
//  BirthdayReminder
//
//  Created by Gulnaz on 24.10.2022.
//

import Foundation

class Birthday {
    
    var date: Date
    var nextBirthDay: Date
    var dayNumber: Int
    var monthName: String
    var nextBirthDayWeekDayName: String
    var age: Int
    var daysToNextBirthday: Int
    
    init(dateOfBirth: Date) {
        self.date = dateOfBirth
        self.nextBirthDay = dateOfBirth.nextDateFromToday()
        self.dayNumber = Calendar.current.component(.day, from: nextBirthDay)
        self.monthName = self.date.monthName()
        self.nextBirthDayWeekDayName = self.nextBirthDay.weekdayName() 
        self.age = self.date.currentAge()
        self.daysToNextBirthday = self.date.daysTo()
    }
}
