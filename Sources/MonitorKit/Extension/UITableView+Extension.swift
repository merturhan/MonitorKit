//
//  UITableView+Extension.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import UIKit

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(for type: T.Type, at indexPath: IndexPath) -> T {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
}
