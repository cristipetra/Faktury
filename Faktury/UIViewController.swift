////  UIViewController.swift
//  Faktury
//
//  Created by Pawel Stachurski on 6/2/20.
//  Copyright © 2020 DKSH . All rights reserved.
//

import UIKit


extension UIViewController {
    class func instantiateController<T: UIViewController>(from: UIStoryboard.type) -> T? {
        if let controller = UIStoryboard(name: from.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return controller
        }
        return nil
    }
}
