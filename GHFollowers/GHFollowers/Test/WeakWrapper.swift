//
//  WeakWrapper.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 25.02.26.
//

import Foundation
import UIKit

struct WeakWrapper {
    weak var view: UIViewController?
}

struct ControllersHolder {
    init() {
        var leakView = LeakingViewController()
        var heavyView = HeavyTableViewController()
        var viewArray = [WeakWrapper(view: leakView), WeakWrapper(view: heavyView)]
        
        weak var vc = UIViewController()
    }
}
