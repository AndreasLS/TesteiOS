//
//  TIRoundedView.swift
//  TesteiOSFramework
//
//  Created by André Salla on 02/07/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import UIKit

public class TIRoundedView: UIView {

    public var roundedCorners: UIRectCorner?
    public var radiusCorner: CGFloat?

    private func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let roundedCorners = roundedCorners, let radiusCorner = radiusCorner else { return }
        self.roundCorners(roundedCorners, radius: radiusCorner)
    }

}
