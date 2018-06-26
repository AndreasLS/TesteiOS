//
//  Style.swift
//  TesteiOSFrameworkTests
//
//  Created by André Salla on 25/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import Foundation
import UIKit

public protocol Style {

    var fieldTextColor: UIColor { get }
    var fieldLabelColor: UIColor { get }
    var clearButtonBackgroundColor: UIColor { get }
    var clearButtonTintColor: UIColor { get }
    var fieldSuccessColor: UIColor { get }
    var fieldErrorColor: UIColor { get }
    var fieldActiveColor: UIColor { get }
    var fieldInactiveColor: UIColor { get }

    var fieldFont: UIFont { get }

    var defaultButtonColor: UIColor { get }
    var pressedButtonColor: UIColor { get }

}

public struct DefaultStyle: Style {

    public static var instance: DefaultStyle = DefaultStyle()

    public var fieldTextColor: UIColor = UIColor.mineShaft

    public var fieldLabelColor: UIColor = UIColor.silverChalice

    public var clearButtonBackgroundColor: UIColor = UIColor.whiteSmoke

    public var clearButtonTintColor: UIColor = UIColor.cloudy

    public var fieldSuccessColor: UIColor = UIColor.apple

    public var fieldErrorColor: UIColor = UIColor.deepCarmim

    public var fieldActiveColor: UIColor = UIColor.silverChalice

    public var fieldInactiveColor: UIColor = UIColor.darkerWhite

    public var fieldFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .light)

    public var defaultButtonColor: UIColor = UIColor.lava

    public var pressedButtonColor: UIColor = UIColor.geraldine

}
