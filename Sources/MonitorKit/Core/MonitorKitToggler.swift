//
//  MonitorKitToggler.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

/// A protocol that defines a toggle behavior for presenting or dismissing the network monitor UI.
public protocol MonitorKitTogglerProtocol {
    /// Toggles the visibility of the MonitorKit network monitor.
    @MainActor func toggle()
}

/// Handles the presentation and dismissal of the MonitorKit network monitor.
/// If the monitor is already visible, it dismisses it. Otherwise, it presents it over the current view.
final class MonitorKitToggler: MonitorKitTogglerProtocol {

    func toggle() {
        guard let topViewController = UIApplication.shared.topViewController else { return }

        switch topViewController {
        case is MonitorKitListViewController:
            topViewController.dismiss(animated: true) {
                print("MonitorKit: Network monitor dismissed")
            }
        case is MonitorKitDetailViewController:
            break
        default:
            let viewController = MonitorKitListViewController()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            topViewController.present(viewController, animated: true) {
                print("MonitorKit: Network monitor presented")
            }
        }
    }
}
