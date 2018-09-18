import UIKit
import Foundation

public protocol GraphViewDataSource: AnyObject {
    func numberOfPoints(in graphView: GraphView) -> Int
    func graphView(_ graphView: GraphView, valueAt index: Int) -> CGFloat
    func graphView(_ graphView: GraphView, labelForPointAt index: Int) -> String?
    func graphView(_ graphView: GraphView, xAxisLabelForPointAt index: Int) -> String?
    func numberOfHorizontalGridLines(in graphView: GraphView) -> Int
    func graphView(_ graphView: GraphView, labelForHorizontalGridLineAt index: Int) -> String?
}

extension GraphViewDataSource {

    func graphView(_ graphView: GraphView, labelForPointAt index: Int) -> String? {
        return nil
    }

    func graphView(_ graphView: GraphView, xAxisLabelForPointAt index: Int) -> String? {
        return nil
    }

    func numberOfHorizontalGridLines(in graphView: GraphView) -> Int {
        return 0
    }

    func graphView(_ graphView: GraphView, labelForHorizontalGridLineAt index: Int) -> String? {
        return nil
    }
}

@IBDesignable
open class GraphView: UIView {

    public weak var dataSource: GraphViewDataSource?

    var lineWidth: CGFloat = 4.0 {
        didSet {
            line.lineWidth = lineWidth
        }
    }

    var labelFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var labelTextColor: UIColor = .darkText
    var labelFillColor: UIColor = .clear
    var xAxisLabelTextColor: UIColor = .gray
    var padding: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 30, bottom: 30, right: 30)

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

    public func reloadData() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    public func clearPlot() {
        line.path = nil
        reloadData()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dataSource = dataSource else { return }

        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)

        xAxisLabels.forEach { $0.removeFromSuperview() }
        xAxisLabels.removeAll(keepingCapacity: true)

        line.strokeColor = tintColor.cgColor
        line.fillColor = backgroundColor?.cgColor

        let points = pointsForPlot(from: dataSource)
        plotLine(using: points)
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsLayout()
        layoutIfNeeded()
    }

    private var contentFrame: CGRect {
        return CGRect(x: padding.left,
                      y: padding.top,
                      width: bounds.width - (padding.left + padding.right),
                      height: bounds.height - (padding.top + padding.bottom))
    }

    private func pointsForPlot(from dataSource: GraphViewDataSource) -> [CGPoint] {
        let count = dataSource.numberOfPoints(in: self)

        let xSpacing = contentFrame.width / CGFloat(count - 1)
        let yDelta = contentFrame.height

        var points = [CGPoint]()

        for index in 0..<count {
            let point = CGPoint(x: CGFloat(index) * xSpacing + contentFrame.minX,
                                y: contentFrame.maxY - dataSource.graphView(self, valueAt: index) * yDelta)
            points.append(point)
        }
        return points
    }

    private func plotLine(using points: [CGPoint]) {
        line.path = UIBezierPath.hermiteInterpolation(for: points)?.cgPath
    }

    private func addLabel(for point: CGPoint, with title: String?) {
        let label = UILabel(frame: .zero)
        label.font = labelFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = labelTextColor
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
        circle.fillColor = labelFillColor.cgColor
        container.layer.insertSublayer(circle, at: 0)
        labels.append(container)
    }

    private func addXAxisLabel(for point: CGPoint, with title: NSAttributedString?) {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = xAxisLabelTextColor
        label.backgroundColor = backgroundColor
        label.attributedText = title
        label.sizeToFit()

        label.center = CGPoint(x: point.x, y: bounds.maxY - label.bounds.height / 2 - 4)
        addSubview(label)

        xAxisLabels.append(label)
    }

//    open override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        data = [GraphPoint(label: "0.0", value: 0.0, axisLabel: NSAttributedString(string: "Mon")),
//                GraphPoint(label: "0.2", value: 0.2, axisLabel: NSAttributedString(string: "Tue")),
//                GraphPoint(label: "0.6", value: 0.6, axisLabel: NSAttributedString(string: "Wed")),
//                GraphPoint(label: "0.3", value: 0.3, axisLabel: NSAttributedString(string: "Thu")),
//                GraphPoint(label: "1.0", value: 1.0, axisLabel: NSAttributedString(string: "Fri"))]
//        labelFillColor = .white
//    }
}
