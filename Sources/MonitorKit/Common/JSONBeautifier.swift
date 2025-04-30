//
//  JSONBeautifier.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

public class JSSONBeautifier {
    
    public static func beatuify(_ string: String?) -> String? {
        guard
            let string = string,
            let data = string.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return string
        }
        
        return prettyString
    }
}
