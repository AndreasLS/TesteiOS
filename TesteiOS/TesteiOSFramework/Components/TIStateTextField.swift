//
//  TIStateTextField.swift
//  TesteiOSFramework
//
//  Created by André Salla on 25/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import UIKit

@IBDesignable
public class TIStateTextField: UIView {

    enum State {
        case active
        case inactive
    }

    @IBInspectable public var activeStateColor: UIColor = DefaultStyle.instance.fieldActiveColor
    @IBInspectable public var inactiveColor: UIColor = DefaultStyle.instance.fieldInactiveColor

    @IBInspectable public var textColor: UIColor = DefaultStyle.instance.fieldTextColor
    @IBInspectable var labelColor: UIColor = DefaultStyle.instance.fieldLabelColor

    public var textFont: UIFont = DefaultStyle.instance.fieldFont
    public var labelFont: UIFont = DefaultStyle.instance.fieldFont.withSize(16)

    @IBInspectable var labelText: String = "Label" {
        didSet {
            label?.text = labelText
        }
    }
    @IBInspectable var text: String = "Text" {
        didSet {
            textField?.text = text
        }
    }

    var label: UILabel?
    var textField: UITextField?
    var clearButton: UIButton?
    var statusLine: UIView?

    private(set) var state: State = .inactive {
        didSet {
            stateChanged(newState: state)
        }
    }

    public override func draw(_ rect: CGRect) {

        if label == nil || textField == nil || clearButton == nil || statusLine == nil {
            label = UILabel()
            label?.textColor = labelColor
            label?.font = labelFont
            label?.textAlignment = .left

            textField = UITextField()
            textField?.textColor = textColor
            textField?.font = textFont
            textField?.delegate = self

            clearButton = UIButton()
            clearButton?.backgroundColor = DefaultStyle.instance.clearButtonBackgroundColor
            clearButton?.tintColor = DefaultStyle.instance.clearButtonTintColor
            clearButton?.setImage(UIImage.init(named: "empty_text", in:
                Bundle.init(for: TIStateTextField.self), compatibleWith: nil), for: .normal)
            clearButton?.layer.cornerRadius = 10
            clearButton?.clipsToBounds = true
            clearButton?.addTarget(self, action: #selector(clear), for: .touchUpInside)
            clearButton?.isHidden = true

            statusLine = UIView()
            statusLine?.backgroundColor = inactiveColor

            self.translatesAutoresizingMaskIntoConstraints = false
            label?.translatesAutoresizingMaskIntoConstraints = false
            textField?.translatesAutoresizingMaskIntoConstraints = false
            clearButton?.translatesAutoresizingMaskIntoConstraints = false
            statusLine?.translatesAutoresizingMaskIntoConstraints = false

            setupConstraints()

        }

        label?.text = labelText
    }

    private func setupConstraints() {

        setupTextBoxConstraints()
        setupLabelConstraints()
        setupClearButtomConstraints()
        setupLineConstraints()

        guard let clearButton = clearButton, let statusLine = statusLine else { return }

        let constraints = self.constraints + statusLine.constraints + clearButton.constraints
        NSLayoutConstraint.activate(constraints)
    }

    func setupTextBoxConstraints() {
        guard let textField = textField, let clearButton = clearButton else { return }

        self.addSubview(textField)

        self.addConstraints([
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self,
                               attribute: .top, multiplier: 1, constant: 4),
            NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self,
                               attribute: .bottom, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: clearButton,
                               attribute: .trailing, multiplier: 1, constant: 2)
            ])
    }

    func setupClearButtomConstraints() {
        guard let clearButton = clearButton else { return }

        self.addSubview(clearButton)

        clearButton.addConstraints([
            NSLayoutConstraint(item: clearButton, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: clearButton, attribute: .width, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])

        self.addConstraints([
            NSLayoutConstraint(item: clearButton, attribute: .centerY, relatedBy: .equal,
                               toItem: textField, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: clearButton, attribute: .trailing, relatedBy: .equal, toItem: self,
                               attribute: .trailing, multiplier: 1, constant: 0)
            ])
    }

    func setupLabelConstraints() {
        guard let label = label else { return }

        self.addSubview(label)

        self.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self,
                               attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .greaterThanOrEqual,
                               toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            ])
    }

    func setupLineConstraints() {
        guard let statusLine = statusLine else { return }

        self.addSubview(statusLine)

        statusLine.addConstraint(
            NSLayoutConstraint(item: statusLine, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 1))

        self.addConstraints([
            NSLayoutConstraint(item: statusLine, attribute: .leading, relatedBy: .equal, toItem: self,
                               attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: statusLine, attribute: .trailing, relatedBy: .equal, toItem: self,
                               attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: statusLine, attribute: .bottom, relatedBy: .equal, toItem: self,
                               attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }

    @objc func clear() {
        textField?.text = ""
        textField?.endEditing(true)
        state = .inactive
    }

    func stateChanged(newState: State) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            switch newState {
            case .active:
                self?.statusLine?.backgroundColor = self?.activeStateColor
                if self?.textField?.text?.isEmpty ?? true {
                    self?.clearButton?.isHidden = false
                    self?.shrinkLabel()
                }
            case .inactive:
                if self?.textField?.text?.isEmpty ?? true {
                    self?.statusLine?.backgroundColor = self?.inactiveColor
                    self?.label?.transform = .identity
                    self?.clearButton?.isHidden = true
                }
            }
        }
    }

    final func shrinkLabel() {
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.label?.transform = CGAffineTransform.translatedBy(transform)(x:
            (self.label?.frame.width ?? 0.0) * -0.325, y: (self.label?.frame.height ?? 0.0) * -0.3)
    }

}

extension TIStateTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        state = .inactive
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        clearButton?.isHidden = newString.isEmpty
        return true
    }

}
