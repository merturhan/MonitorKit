//
//  MonitorKitConfiguratorTests.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import XCTest
@testable import MonitorKit

final class MonitorKitConfiguratorTests: XCTestCase {
    
    func testMakeConfiguration_InsertsMonitorKitURLProtocolFirst() {
        let baseConfig = URLSessionConfiguration.default
        baseConfig.protocolClasses = [URLProtocol.self]
        
        let modifiedConfig = MonitorKitConfigurator.makeConfiguration(from: baseConfig)
        
        let classes = modifiedConfig.protocolClasses ?? []
        
        XCTAssertTrue(classes.contains(where: { $0 == MonitorKitURLProtocol.self }), "MonitorKitURLProtocol should be in the list")
        
        XCTAssertTrue(classes.contains(where: { $0 == URLProtocol.self }), "Deafult URLProtocol should be preserved")
    }
    func testMakeConfiguration_DoesNotMutateOriginal() {
        let baseConfig = URLSessionConfiguration.default
        let originalClasses = baseConfig.protocolClasses
        
        _ = MonitorKitConfigurator.makeConfiguration(from: baseConfig)
        
        let original = (originalClasses ?? []).map(ObjectIdentifier.init)
        let current = (baseConfig.protocolClasses ?? []).map(ObjectIdentifier.init)
        XCTAssertEqual(current, original, "Original config should remain unchanged")
    }
}
