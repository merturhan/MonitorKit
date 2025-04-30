//
//  MonitorKitManager.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

/// Protocol defining the interface for managing MonitorKit's network records and configuration.
public protocol MonitorKitManagerProtocol {
    /// The configuration handler for MonitorKit.
    typealias configurator = MonitorKitConfiguratorProtocol
    /// The list of recorded network requests and responses.
    var records: [MonitorKitRecord] { get }
    /// An optional delegate to receive updates when records change.
    var delegate: MonitorKitManagerDelegate? { get set }
    
    /// Inserts a new network transaction into the records.
    /// - Parameters:
    ///   - request: The original URL request.
    ///   - response: The server's URL response (if any).
    ///   - data: The response data (if any).
    func insert(request: URLRequest, response: URLResponse?, data: Data?)
}

/// Delegate protocol for receiving updates from `MonitorKitManager`.
public protocol MonitorKitManagerDelegate: AnyObject {
    /// Called when MonitorKit's records are updated.
    /// - Parameter records: The updated list of records.
    @MainActor func monitorKitDidUpdate(records: [MonitorKitRecord])
}

final public class MonitorKitManager: MonitorKitManagerProtocol, @unchecked Sendable {
    
    public static let shared = MonitorKitManager()
    
    public weak var delegate: MonitorKitManagerDelegate?
    
    public typealias configurator = MonitorKitConfigurator
    
    private var _records: Synchronized<[MonitorKitRecord]>
    
    public var records: [MonitorKitRecord] {
        get {
            _records.get() ?? []
        } set {
            _records.set(newValue)
        }
    }
    
    private init() {
        let queue = DispatchQueue(label: "MonitorKitQueue", qos: .utility, attributes: .concurrent)
        self._records = Synchronized(queue: queue)
    }
    
    public func insert(request: URLRequest, response: URLResponse?, data: Data?) {
        guard let url = request.url else { return }
        
        let method = request.httpMethod ?? "N/A"
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        var requestBodyString: String?
        if let body = request.httpBody {
            requestBodyString = String(data: body, encoding: .utf8)
        }
        
        let responseBodyString = data.flatMap { String(data: $0, encoding: .utf8) }
        
        let record = MonitorKitRecord(
            url: url.absoluteString,
            method: method,
            statusCode: statusCode,
            requestBody: requestBodyString,
            responseBody: responseBodyString,
            timestamp: Date()
        )
        
        
        if records.count >= 100 {
            records.removeLast()
        }
        
        records.insert(record, at: 0)
        
        DispatchQueue.main.async { [weak delegate] in
            delegate?.monitorKitDidUpdate(records: self.records)
        }
    }
}
