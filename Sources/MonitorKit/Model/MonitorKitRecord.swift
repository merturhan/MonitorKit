//
//  MonitorKitRecord.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

public struct MonitorKitRecord {
    var url: String
    var method: String
    var statusCode: Int?
    var requestBody: String?
    var responseBody: String?
    var timestamp: Date
}
