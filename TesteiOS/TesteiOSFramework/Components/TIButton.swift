//
//  TIButton.swift
//  TesteiOSFramework
//
//  Created by André Salla on 25/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import UIKit

@IBDesignable
public class TIButton: UIButton {

    private enum State {
        case normal
        case pressed
    }

    @IBInspectable var defaultColor: UIColor = DefaultStyle.instance.defaultButtonColor
    @IBInspectable var pressedColor: UIColor = DefaultStyle.instance.pressedButtonColor

    private var buttonState: State = .normal

    public override func draw(_ rect: CGRect) {

        if self.buttonState == .normal {
            self.backgroundColor = defaultColor
            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.height / 2
        }

    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonState = .pressed
        UIView.animate(withDuration: 0.1) {[weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.backgroundColor = self?.pressedColor
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonState = .normal
        UIView.animate(withDuration: 0.1) {[weak self] in
            self?.transform = CGAffineTransform.identity
            self?.backgroundColor = self?.defaultColor
        }
    }

}
