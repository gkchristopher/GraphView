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

    var padding: UIEdgeInsets = UIEdgeInsetsMake(20, 30, 20, 30) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private let line = CAShapeLayer()
    private var labels = [UIView]()
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
        line.lineCap = kCALineCapRound
        line.lineWidth = lineWidth
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)

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
            if index == 0 {
                let point = CGPoint(x: contentFrame.minX, y: contentFrame.maxY - (graphPoint.value - minY) * yScale)
                linePath.move(to: point)
                addLabel(for: point, with: graphPoint.key)
            } else {
                let point = CGPoint(x: CGFloat(index) * xScale + contentFrame.minX, y: contentFrame.maxY - (graphPoint.value - minY) * yScale)
                linePath.addLine(to: point)
                addLabel(for: point, with: graphPoint.key)
            }
        }

        line.path = linePath
        line.strokeColor = tintColor.cgColor
        line.fillColor = backgroundColor?.cgColor
    }

    private func addLabel(for point: CGPoint, with title: String?) {
        let label = UILabel(frame: .zero)
        label.font = labelFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
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

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        data = [GraphPoint(key: "Zero", value: 0),
                GraphPoint(key: "One", value: 0.2),
                GraphPoint(key: "Two", value: 0.6),
                GraphPoint(key: "Three", value: 0.3),
                GraphPoint(key: "Four", value: 1.0)]
    }
}
