//
//  GraphView.swift
//  GraphViewExample
//
//  Created by Christopher J Moore on 2/14/18.
//  Copyright © 2018 Roving Mobile. All rights reserved.
//

import UIKit

public struct GraphPoint {
    let key: String
    let value: CGFloat
}

@IBDesignable
open class GraphView: UIView {

    var minY: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var maxY: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var data: [GraphPoint]? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var lineWidth: CGFloat = 7.0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var padding: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private let line = CAShapeLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }

    private func initializeView() {
        layer.addSublayer(line)
        line.lineCap = kCALineCapRound
        line.lineWidth = lineWidth
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        plotLine()
    }

    private func plotLine() {
        guard let data = data else {
            line.path = nil
            return
        }

        let contentFrame = CGRect(x: padding.left,
                                  y: padding.top,
                                  width: bounds.width - padding.left - padding.right,
                                  height: bounds.height - padding.top - padding.bottom)

        let xScale = contentFrame.width / CGFloat(data.count - 1)
        let yScale = contentFrame.height / (maxY - minY)

        let linePath = CGMutablePath()

        for (index, graphPoint) in data.enumerated() {
            if index == 0 {
                linePath.move(to: CGPoint(x: contentFrame.minX, y: contentFrame.maxY - graphPoint.value * yScale))
            } else {
                linePath.addLine(to: CGPoint(x: CGFloat(index) * xScale + contentFrame.minX, y: contentFrame.maxY - graphPoint.value * yScale))
            }
        }

        line.path = linePath
        line.strokeColor = tintColor.cgColor
        line.fillColor = backgroundColor?.cgColor
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        data = [GraphPoint(key: "Zero", value: 0),
                GraphPoint(key: "One", value: 0.2),
                GraphPoint(key: "Two", value: 0.6),
                GraphPoint(key: "Three", value: 0.3),
                GraphPoint(key: "Four", value: 1.0)]
    }
}
