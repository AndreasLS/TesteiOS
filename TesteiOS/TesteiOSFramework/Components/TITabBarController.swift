//
//  TITabBarController.swift
//  TesteiOSFramework
//
//  Created by André Salla on 27/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import Foundation

open class TITabBarController: UIViewController {

    private weak var activeViewController: UIViewController?
    private var activeConstraints: [NSLayoutConstraint] = []
    private var viewControllers: [UIViewController] = []

    private lazy var contentView: UIView = {
        let content = UIView()
        content.clipsToBounds = true
        content.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(content)

        var constraints = [
            NSLayoutConstraint(item: content, attribute: .bottom, relatedBy: .equal, toItem: self.view,
                               attribute: .bottom, multiplier: 1, constant: -58),
            NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: self.view,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: .equal, toItem: self.view,
                               attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: content, attribute: .top, relatedBy: .equal, toItem: self.view,
                               attribute: .top, multiplier: 1, constant: 0)
        ]

        self.view.addConstraints(constraints)

        NSLayoutConstraint.activate(constraints)

        self.view.bringSubview(toFront: tabBar)

        return content
    }()

    private(set) lazy var tabBar: TITabBar = {
        let tab = TITabBar()

        tab.delegate = self
        tab.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tab)

        var constraints = [
            NSLayoutConstraint(item: tab, attribute: .bottom, relatedBy: .equal, toItem: self.view,
                               attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tab, attribute: .leading, relatedBy: .equal, toItem: self.view,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tab, attribute: .trailing, relatedBy: .equal, toItem: self.view,
                               attribute: .trailing, multiplier: 1, constant: 0)
        ]

        self.view.addConstraints(constraints)

        let constraint = NSLayoutConstraint(item: tab, attribute: .height, relatedBy: .equal, toItem: nil,
                                            attribute: .notAnAttribute, multiplier: 1, constant: 60)

        tab.addConstraint(constraint)

        constraints.append(constraint)
        NSLayoutConstraint.activate(constraints)

        return tab
    }()

    public func addViewController(_ controller: UIViewController) {
        viewControllers.append(controller)
        let button = UIButton()
        button.setTitle(controller.title, for: .normal)
        tabBar.add(button: button)
        if viewControllers.count == 1 {
            changeViewController(index: 0)
        }
    }

    private func changeViewController(index: Int) {
        NSLayoutConstraint.deactivate(activeConstraints)
        self.contentView.removeConstraints(activeConstraints)
        activeViewController?.willMove(toParentViewController: nil)
        activeViewController?.removeFromParentViewController()
        activeViewController?.view.removeFromSuperview()

        viewControllers[index].willMove(toParentViewController: self)

        self.addChildViewController(viewControllers[index])

        guard let childView = viewControllers[index].view else {
            return
        }

        self.contentView.addSubview(childView)
        childView.frame = contentView.bounds
        childView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        activeViewController = viewControllers[index]

    }
}

extension TITabBarController: TITabBarDelegate {

    public func didChangeSelected(index: Int) {
        changeViewController(index: index)
    }
}
