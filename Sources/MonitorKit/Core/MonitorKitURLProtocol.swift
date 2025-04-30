//
//  MonitorKitURLProtocol.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

/// A custom URLProtocol subclass used to intercept and log network requests and responses for MonitorKit.
final class MonitorKitURLProtocol: URLProtocol, @unchecked Sendable {

    /// Determines whether this protocol can handle the given request.
    /// Prevents re-processing requests by checking a custom property.
    override class func canInit(with request: URLRequest) -> Bool {
        return URLProtocol.property(forKey: "MonitorKit-Handled", in: request) == nil
    }

    /// Returns the canonical version of the request. No modifications needed in this case.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Starts loading the request, intercepts the response, and forwards it to the client.
    /// Also logs the request and response via MonitorKitManager.
    override func startLoading() {
        guard let newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        
        URLProtocol.setProperty(true, forKey: "MonitorKit-Handled", in: newRequest)

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)

        session.dataTask(with: newRequest as URLRequest) { [weak self] data, response, error in
            guard let self else { return }

            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }
            
            MonitorKitManager.shared.insert(request: self.request, response: response, data: data)

        }.resume()
    }
    
    override func stopLoading() { }
}
