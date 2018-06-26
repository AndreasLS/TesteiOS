//
//  TIStateValidableTextField.swift
//  TesteiOSFramework
//
//  Created by André Salla on 26/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import UIKit

public class TIStateValidableTextField: TIStateTextField {

    @objc public enum ValidationType: NSInteger {
        case email
        case none

        var regexString: String {
            switch self {
            case .email:
                return
                    "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
                        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
                        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
                        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
                        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
                        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
                "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            case .none:
                return ""
            }
        }
    }

    @IBInspectable public var errorStateColor: UIColor = DefaultStyle.instance.fieldErrorColor
    @IBInspectable public var successStateColor: UIColor = DefaultStyle.instance.fieldSuccessColor

    public var validationType: ValidationType = .none

    enum ValidationStatus {
        case success
        case error
        case notValidated
    }

    private var validationStatus: ValidationStatus = .notValidated {
        didSet {
            componentBehaviour(state: state, validation: validationStatus)
        }
    }

    override func stateChanged(newState: TIStateTextField.State) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            switch newState {
            case .active:
                if self?.validationStatus == .notValidated {
                    self?.statusLine?.backgroundColor = self?.activeStateColor
                }
                if self?.textField?.text?.isEmpty ?? true {
                    self?.clearButton?.isHidden = false
                    self?.shrinkLabel()
                }
            case .inactive:
                if self?.validationStatus == .notValidated {
                    self?.statusLine?.backgroundColor = self?.inactiveColor
                }
                if self?.textField?.text?.isEmpty ?? true {
                    self?.label?.transform = .identity
                    self?.clearButton?.isHidden = true
                }
            }
        }
    }

    func componentBehaviour(state: TIStateTextField.State, validation: ValidationStatus) {
        UIView.animate(withDuration: 0.3) {[weak self] in
            switch validation {
            case .error: self?.statusLine?.backgroundColor = self?.errorStateColor
            case .success: self?.statusLine?.backgroundColor = self?.successStateColor
            case .notValidated: self?.statusLine?.backgroundColor =
                state == .active ? self?.activeStateColor : self?.inactiveColor
            }
        }

    }

    private func validate(text: String) {
        switch validationType {
        case .email:
            let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", validationType.regexString)
            validationStatus = emailTest.evaluate(with: text) ? .success : .error
        case .none: validationStatus = .notValidated
        }
    }

    public override func textField(_ textField: UITextField,
                                   shouldChangeCharactersIn range: NSRange,
                                   replacementString string: String) -> Bool {
        validate(text: NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string))
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }

}
