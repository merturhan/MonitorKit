//
//  UIApplication+Extension.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

extension UIApplication {
    
    var topViewController: UIViewController? {
        
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }

        var currentVC = rootViewController
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }

        return currentVC
    }
}
