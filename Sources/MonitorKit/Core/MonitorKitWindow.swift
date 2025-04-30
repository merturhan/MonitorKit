//
//  MonitorKitWindow.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

/// A custom UIWindow subclass that enables toggling the MonitorKit UI when the device is shaken.
final public class MonitorKitWindow: UIWindow {

    public var toggler: MonitorKitTogglerProtocol? = MonitorKitToggler()

    /// Handles the shake motion gesture to toggle the MonitorKit UI.
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        guard motion == .motionShake else { return }
        toggler?.toggle()
    }
}
