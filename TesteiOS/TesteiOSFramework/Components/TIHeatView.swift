//
//  TIHeatView.swift
//  TesteiOSFramework
//
//  Created by André Salla on 27/06/18.
//  Copyright © 2018 Andre Salla. All rights reserved.
//

import Foundation

public class TIHeatView: UIView {

    public enum Status: Int {
        case lowest
        case low
        case medium
        case high
        case highest
    }

    var status: Status = .medium {
        didSet {
            setNeedsLayout()
        }
    }

    var indicatorConstraints: [NSLayoutConstraint] = []

    weak var indicatorView: UIImageView?
    weak var lowestView: UIView?
    weak var lowView: UIView?
    weak var mediumView: UIView?
    weak var highView: UIView?
    weak var highestView: UIView?

    public override func draw(_ rect: CGRect) {

        if lowestView == nil || lowView == nil || mediumView == nil || highView == nil ||
            highestView == nil || indicatorView == nil {
            createView(status: .lowest)
            createView(status: .low)
            createView(status: .medium)
            createView(status: .high)
            createView(status: .highest)
            createIndicator()
            NSLayoutConstraint.activate(self.constraints)
        }
        lowestView?.transform = .identity
        lowView?.transform = .identity
        mediumView?.transform = .identity
        highView?.transform = .identity
        highestView?.transform = .identity
        switch status {
        case .lowest: lowestView?.transform = CGAffineTransform.init(scaleX: 1, y: 1.6)
        case .low: lowView?.transform = CGAffineTransform.init(scaleX: 1, y: 1.6)
        case .medium: mediumView?.transform = CGAffineTransform.init(scaleX: 1, y: 1.6)
        case .high: highView?.transform = CGAffineTransform.init(scaleX: 1, y: 1.6)
        case .highest: highestView?.transform = CGAffineTransform.init(scaleX: 1, y: 1.6)
        }
        positionIndicator()

    }

    private func positionIndicator() {
        guard let indicator = indicatorView else { return }
        NSLayoutConstraint.deactivate(indicatorConstraints)
        self.removeConstraints(indicatorConstraints)
        let centerView: UIView?
        switch status {
        case .lowest: centerView = lowestView
        case .low: centerView = lowView
        case .medium: centerView = mediumView
        case .high: centerView = highView
        case .highest: centerView = highestView
        }
        indicatorConstraints = [
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal,
                               toItem: centerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal,
                               toItem: centerView, attribute: .top, multiplier: 1, constant: -8)
        ]
        self.addConstraints(indicatorConstraints)
        NSLayoutConstraint.activate(indicatorConstraints)
    }

    private func createIndicator() {
        let imageView = UIImageView(image: UIImage.init(named: "indicator", in:
            Bundle.init(for: TIStateTextField.self), compatibleWith: nil))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.indicatorView = imageView
    }

    private func createView(status: Status) {

        let view = TIRoundedView()
        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        switch status {
        case .lowest: createLowest(view: view)
        case .low: createLow(view: view)
        case .medium: createMedium(view: view)
        case .high: createHigh(view: view)
        case .highest: createHighest(view: view)

        }

        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 1, constant: 6)
            ])

        self.addConstraint(
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self,
                               attribute: .centerY, multiplier: 1, constant: 0)
            )

        NSLayoutConstraint.activate(view.constraints)
    }

    private func createLowest(view: TIRoundedView) {
        view.backgroundColor = UIColor.Heat.lowest
        view.radiusCorner = 3.0
        view.roundedCorners = [.topLeft, .bottomLeft]
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                              toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        lowestView = view
    }

    private func createLow(view: TIRoundedView) {
        view.backgroundColor = UIColor.Heat.low
        self.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                toItem: lowestView, attribute: .trailing, multiplier: 1, constant: 1),
                             NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                                toItem: lowestView, attribute: .width, multiplier: 1, constant: 0)])
        lowView = view
    }

    private func createMedium(view: TIRoundedView) {
        view.backgroundColor = UIColor.Heat.medium
        self.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                toItem: lowView, attribute: .trailing, multiplier: 1, constant: 1),
                             NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                                toItem: lowView, attribute: .width, multiplier: 1, constant: 0)])
        mediumView = view
    }

    private func createHigh(view: TIRoundedView) {
        view.backgroundColor = UIColor.Heat.high
        self.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                toItem: mediumView, attribute: .trailing, multiplier: 1, constant: 1),
                             NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                                toItem: mediumView, attribute: .width, multiplier: 1, constant: 0)])
        highView = view
    }

    private func createHighest(view: TIRoundedView) {
        view.backgroundColor = UIColor.Heat.highest
        view.radiusCorner = 3.0
        view.roundedCorners = [.topRight, .bottomRight]
        self.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                toItem: highView, attribute: .trailing, multiplier: 1, constant: 1),
                             NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                                toItem: highView, attribute: .width, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal,
                                                toItem: self, attribute: .trailing, multiplier: 1, constant: 0)])
        highestView = view
    }

}
