//
//  MonitorKitManagerTests.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import XCTest
@testable import MonitorKit

final class MonitorKitManagerTests: XCTestCase {
    
    var manager: MonitorKitManager!
    
    override func setUp() {
        super.setUp()
        manager = MonitorKitManager.shared // Initialize the manager for the tests
    }
    
    override func tearDown() {
        manager = nil // Clean up the manager after the test
        super.tearDown()
    }
    
    // Tests if a new record is added correctly
    func testInsert_AddsNewRecord() {
        let url = URL(string: "https://example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "response data".data(using: .utf8)
        
        manager.insert(request: request, response: response, data: data)
        
        XCTAssertEqual(manager.records.count, 1, "There should be 1 record in the manager")
        XCTAssertEqual(manager.records.first?.url, "https://example.com", "The first record should have the correct URL")
        XCTAssertEqual(manager.records.first?.method, "GET", "The first record should have the correct HTTP method")
        XCTAssertEqual(manager.records.first?.statusCode, 200, "The first record should have the correct status code")
    }
    
    // Tests if the record count is limited to 100
    func testInsert_LimitsRecordCount() {
        let url = URL(string: "https://example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "response data".data(using: .utf8)
        
        for _ in 0..<101 {
            manager.insert(request: request, response: response, data: data)
        }
        
        XCTAssertEqual(manager.records.count, 100, "The number of records should not exceed 100")
        XCTAssertEqual(manager.records.first?.url, "https://example.com", "The first record should be the latest one inserted")
    }
    
    // Tests if the delegate is called correctly
    func testInsert_DelegateCalled() {
        class MockDelegate: MonitorKitManagerDelegate {
            let expectation = XCTestExpectation(description: "Delegate called")
            
            func monitorKitDidUpdate(records: [MonitorKitRecord]) {
                let isMainThread = Thread.isMainThread
                XCTAssertTrue(isMainThread, "Delegate should be called on the main thread")
                expectation.fulfill()
            }
        }

        let mockDelegate = MockDelegate()
        manager.delegate = mockDelegate
        
        let url = URL(string: "https://example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "response data".data(using: .utf8)
        
        manager.insert(request: request, response: response, data: data)
        
        wait(for: [mockDelegate.expectation], timeout: 1)
    }
}
