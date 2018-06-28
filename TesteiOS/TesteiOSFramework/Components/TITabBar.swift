//
//  TITabBar.swift
//  TesteiOSFramework
//
//  Created by André Salla on 27/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import Foundation

@IBDesignable
public class TITabBar: UIView {
    
    @IBInspectable var height: CGFloat = 55.0
    @IBInspectable var selectedColor: UIColor = .white
    @IBInspectable var backgroundTabColor: UIColor = .white

    var selectedIndex: Int = 0 {
        didSet {
            moveLine()
        }
    }

    public var buttons: [UIButton] = [] {
        didSet {
            putButtons()
            setNeedsLayout()
        }
    }

    private var stackView: UIStackView?
    private var line: UIView?
    private var lineWidth: NSLayoutConstraint?

    public override func draw(_ rect: CGRect) {

        if buttons.count > 0 {
            if stackView == nil || line == nil {
                crateStackView()
                createLine()
                putButtons()
                let constraints = self.constraints + (line?.constraints ?? [])
                NSLayoutConstraint.activate(constraints)
            }
            if selectedIndex < buttons.count {
                buttons[selectedIndex].backgroundColor = selectedColor
            }

        }

    }

    private func createLine() {
        let view = UIView()
        view.backgroundColor = self.backgroundTabColor

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        self.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self,
                               attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0)
            ])

        self.lineWidth =
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1,
                               constant: self.frame.width / CGFloat(buttons.count))

        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 2), self.lineWidth!
            ])

        self.line = view

    }

    private func crateStackView() {

        let view = UIStackView.init(arrangedSubviews: buttons)
        view.distribution = .fillEqually
        view.spacing = 0
        view.axis = .horizontal
        view.backgroundColor = self.backgroundTabColor

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        self.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self,
                               attribute: .top, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self,
                               attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self,
                               attribute: .trailing, multiplier: 1, constant: 0)
            ])

        self.stackView = view

    }

    private func moveLine() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.6, options: [], animations: {
            self.line?.transform =
                CGAffineTransform(translationX: (self.lineWidth?.constant ?? 0.0) * CGFloat(self.selectedIndex),
                                  y: 0.0)
            self.buttons.forEach {
                $0.backgroundColor = self.backgroundTabColor
            }
            if self.selectedIndex < self.buttons.count {
                self.buttons[self.selectedIndex].backgroundColor = self.selectedColor
            }
        }, completion: nil)
    }

    @objc func selectOption(sender: UIControl) {
        self.selectedIndex = sender.tag
    }

    private func putButtons() {
        if buttons.count == 0 {
            lineWidth?.constant = 0
            while stackView?.arrangedSubviews.first != nil {
                stackView?.removeArrangedSubview((stackView?.arrangedSubviews.first)!)
            }
        }
        for index in 0...buttons.count - 1 {
            buttons[index].tag = index
            buttons[index].addTarget(self, action: #selector(selectOption(sender:)), for: .touchUpInside)
            buttons[index].backgroundColor = self.backgroundTabColor
            buttons[index].tintColor = self.tintColor
            stackView?.addArrangedSubview(buttons[index])
            lineWidth?.constant = self.frame.width / CGFloat(buttons.count)
        }
    }
}
