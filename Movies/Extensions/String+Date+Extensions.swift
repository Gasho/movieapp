//
//  Date+Extensions.swift
//  EventsApp
//
//  Created by Gasho on 11.03.2021..
//

import Foundation

extension Date{
    
    func toString() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let string = dateFormatter.string(from: self)
        return string
    }
}

extension String{
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else{
            return Date()
        }
        return date
    }
}
