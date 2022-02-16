//
//  DateExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation

extension Date {
    func getDynamicDateStringFormat() -> String {
        if Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: Date()) {
            return "HH:mm"
        } else if Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: Date()) {
            return "dd-MM"
        }
        return "MM-yy"
    }
}
