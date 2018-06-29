//
//  ViewController.swift
//  TesteiOS
//
//  Created by André Salla on 25/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import UIKit
import TesteiOSFramework

class ViewController: TITabBarController {

    override func viewDidLoad() {
        addViewController(createViewController(color: .cyan, index: 0))
        addViewController(createViewController(color: .yellow, index: 1))
    }

    func createViewController(color: UIColor, index: Int) -> UIViewController {
        let viewContorller = UIViewController.init()
        viewContorller.view.backgroundColor = color
        viewContorller.title = "Teste \(index)"
        return viewContorller
    }

}
