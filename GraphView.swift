import UIKit
import Foundation

public struct GraphPoint {
    let key: String
    let value: CGFloat
    let label: String?
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

    var lineWidth: CGFloat = 4.0 {
        didSet {
            line.lineWidth = lineWidth
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var labelFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var lineLabelColor: UIColor = .darkText {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var xAxisLabelColor: UIColor = .gray {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var padding: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 30, bottom: 30, right: 30) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private let line = CAShapeLayer()
    private var labels = [UIView]()
    private var xAxisLabels = [UIView]()
    private let labelMargin: CGFloat = 2

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
        line.lineCap = CAShapeLayerLineCap.round
        line.lineWidth = lineWidth
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)

        xAxisLabels.forEach { $0.removeFromSuperview() }
        xAxisLabels.removeAll(keepingCapacity: true)

        plotLine()
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsLayout()
        layoutIfNeeded()
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
            let point: CGPoint
            if index == 0 {
                point = CGPoint(x: contentFrame.minX, y: contentFrame.maxY - (graphPoint.value - minY) * yScale)
                linePath.move(to: point)
            } else {
                point = CGPoint(x: CGFloat(index) * xScale + contentFrame.minX, y: contentFrame.maxY - (graphPoint.value - minY) * yScale)
                linePath.addLine(to: point)
            }
            addLabel(for: point, with: graphPoint.key)
            addXAxisLabel(for: point, with: graphPoint.label)
        }

        line.path = linePath
        line.strokeColor = tintColor.cgColor
        line.fillColor = backgroundColor?.cgColor
    }

    private func addLabel(for point: CGPoint, with title: String?) {
        let label = UILabel(frame: .zero)
        label.font = labelFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = lineLabelColor
        label.backgroundColor = .clear
        label.text = title
        label.sizeToFit()

        let container = UIView(frame: label.bounds.insetBy(dx: -labelMargin, dy: -labelMargin))
        container.addSubview(label)
        label.center = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        addSubview(container)
        container.center = point

        let circle = CAShapeLayer()
        let path = UIBezierPath(roundedRect: container.bounds, cornerRadius: container.bounds.height / 2)
        circle.path = path.cgPath
        circle.fillColor = backgroundColor?.cgColor
        container.layer.insertSublayer(circle, at: 0)
        labels.append(container)
    }

    private func addXAxisLabel(for point: CGPoint, with title: String?) {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = xAxisLabelColor
        label.text = title
        label.sizeToFit()

        label.center = CGPoint(x: point.x, y: bounds.maxY - label.bounds.height / 2 - 4)
        addSubview(label)

        xAxisLabels.append(label)
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        data = [GraphPoint(key: "Zero", value: 0, label: "Mon"),
                GraphPoint(key: "One", value: 0.2, label: "Tue"),
                GraphPoint(key: "Two", value: 0.6, label: "Wed"),
                GraphPoint(key: "Three", value: 0.3, label: "Thu"),
                GraphPoint(key: "Four", value: 1.0, label: "Fri")]
    }
}
