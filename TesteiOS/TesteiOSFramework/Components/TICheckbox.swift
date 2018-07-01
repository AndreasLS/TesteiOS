//
//  TITabBar.swift
//  TesteiOSFramework
//
//  Created by André Salla on 27/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import Foundation

@IBDesignable
public class TICheckbox: UIView {

    @IBInspectable var isChecked: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    private var box: UIView?
    private var check: UIView?
    private var label: UILabel?

    @IBInspectable var checkedColor: UIColor = DefaultStyle.instance.checkedCheckBoxColor
    @IBInspectable var checkBoxColor: UIColor = DefaultStyle.instance.checkBoxColor

    @IBInspectable var text: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {

        if box == nil || check == nil || label == nil {
            createBox()
            createCheck()
            createLabel()
            NSLayoutConstraint.activate(self.constraints + (self.box?.constraints ?? []))

            let tap = UITapGestureRecognizer(target: self, action: #selector(checkChange))
            self.addGestureRecognizer(tap)
        }
        UIView.animate(withDuration: 0.1) {
            self.check?.alpha = self.isChecked ? 1 : 0
        }
        label?.text = text

    }

    private func createBox() {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 3.0
        view.layer.borderColor = self.checkBoxColor.cgColor
        view.layer.borderWidth = 1.0

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        self.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self,
                               attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0)
            ])

        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 19),
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 19)
            ])

        self.box = view

    }

    private func createCheck() {
        guard let box = box else { return }

        let view = UIView()
        view.backgroundColor = self.checkedColor
        view.layer.cornerRadius = 2.0
        view.clipsToBounds = true

        view.translatesAutoresizingMaskIntoConstraints = false

        box.addSubview(view)

        box.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: box,
                               attribute: .top, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: box,
                               attribute: .leading, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: box, attribute: .trailing, relatedBy: .equal, toItem: view,
                               attribute: .trailing, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: box, attribute: .bottom, relatedBy: .equal, toItem: view,
                               attribute: .bottom, multiplier: 1, constant: 2)
            ])

        self.check = view

    }

    private func createLabel() {

        guard let box = box else { return }

        let label = UILabel()
        label.font = DefaultStyle.instance.checkBoxFont
        label.textColor = self.checkBoxColor

        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)

        self.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self,
                               attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: self,
                               attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label,
                               attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: box,
                               attribute: .trailing, multiplier: 1, constant: 8)
            ])

        self.label = label

    }

    @objc func checkChange() {
        isChecked = !isChecked
    }

}
