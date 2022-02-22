//
//  DateExtensions.swift
//  NewsApp
//
//  Created by Vladimir Yanakiev on 16.02.22.
//

import Foundation

extension Date {
    static func formattedDateFromString(dateString: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" + "Z"

        if let date = inputFormatter.date(from: dateString) {

          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "MMM dd, yyyy"

            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func getDynamicDateStringFormat() -> String {
        if Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: Date()) {
            return "HH:mm"
        } else if Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: Date()) {
            return "dd-MM"
        }
        return "MM-yy"
    }
}
