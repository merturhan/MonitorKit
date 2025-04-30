//
//  Date+Extension.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

extension Date {
    
    var toTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
