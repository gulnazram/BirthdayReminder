//
//  StringExtensions.swift
//  BirthdayReminder
//
//  Created by Gulnaz on 24.10.2022.
//

import Foundation

extension String {
    func preWordForWeekday() -> String {
        if self == "вторник" {
            return "во"
        } else {
            return "в"
        }
    }
}
