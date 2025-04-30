import XCTest
@testable import MonitorKit

final class MonitorKitURLProtocolTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMonitorKitURLProtocol_InterceptsRequest() {
        let expectation = XCTestExpectation(description: "MonitorKitURLProtocol intercepts and logs the request")

        // Create a configuration that uses MonitorKitURLProtocol
        let config = MonitorKitConfigurator.makeConfiguration(from: .default)

        let session = URLSession(configuration: config)
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
        
            MonitorKitManager.shared.insert(request: request, response: response, data: data)
            let records = MonitorKitManager.shared.records
            
            XCTAssertFalse(records.isEmpty, "MonitorKitManager should have at least one record")
            XCTAssertEqual(records.first?.url, url.absoluteString)
            expectation.fulfill()
        }
        
        task.resume()
        wait(for: [expectation], timeout: 5.0)
    }
}
