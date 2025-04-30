//
//  MonitorKitConfigurator.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//
import Foundation

/// A protocol that defines a method for producing a new `URLSessionConfiguration`
/// with `MonitorKitURLProtocol` injected as the first protocol class.
public protocol MonitorKitConfiguratorProtocol {
    /// Returns a copy of the given configuration with `MonitorKitURLProtocol` added.
    /// - Parameter base: The base configuration to copy and modify.
    /// - Returns: A new configuration with `MonitorKitURLProtocol` inserted.
    static func makeConfiguration(from base: URLSessionConfiguration) -> URLSessionConfiguration
}

/// A utility that injects `MonitorKitURLProtocol` into a `URLSessionConfiguration`.
public final class MonitorKitConfigurator: MonitorKitConfiguratorProtocol {
    
    public static func makeConfiguration(from base: URLSessionConfiguration) -> URLSessionConfiguration {
        let copy = base.copy() as? URLSessionConfiguration ?? base
        copy.protocolClasses = [MonitorKitURLProtocol.self] + (copy.protocolClasses ?? [])
        return copy
    }
}
