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

public extension GraphViewDataSource {

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
    var gridLineColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
    var xAxisLabelTextColor: UIColor = .gray
    var padding: UIEdgeInsets = UIEdgeInsets.init(top: 20, left: 38, bottom: 30, right: 20)

    private let line = CAShapeLayer()
    private let gridLines = CAShapeLayer()
    private var labels = [UIView]()
    private var xAxisLabels = [UIView]()
    private var yAxisLabels = [UIView]()
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
        gridLines.lineWidth = 1
        gridLines.strokeColor = gridLineColor.cgColor
        gridLines.lineDashPattern = [1, 1]
        layer.addSublayer(gridLines)

        line.lineCap = CAShapeLayerLineCap.round
        line.lineWidth = lineWidth
        layer.addSublayer(line)
    }

    public func reloadData() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    public func clearPlot() {
        line.path = nil
        gridLines.path = nil
        reloadData()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dataSource = dataSource else { return }

        labels.forEach { $0.removeFromSuperview() }
        labels.removeAll(keepingCapacity: true)

        line.strokeColor = tintColor.cgColor
        line.fillColor = UIColor.clear.cgColor

        let points = pointsForPlot(from: dataSource)
        plotLine(using: points)
        addGridLines(from: dataSource)
        addXAxisLabels(for: points, from: dataSource)
        addYAxisLabels(from: dataSource)
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsLayout()
        layoutIfNeeded()
    }

    private var plotFrame: CGRect {
        return CGRect(x: padding.left,
                      y: padding.top,
                      width: bounds.width - (padding.left + padding.right),
                      height: bounds.height - (padding.top + padding.bottom))
    }

    private func pointsForPlot(from dataSource: GraphViewDataSource) -> [CGPoint] {
        let count = dataSource.numberOfPoints(in: self)

        let xSpacing = plotFrame.width / CGFloat(count - 1)
        let yDelta = plotFrame.height

        var points = [CGPoint]()

        for index in 0..<count {
            let point = CGPoint(x: CGFloat(index) * xSpacing + plotFrame.minX,
                                y: plotFrame.maxY - dataSource.graphView(self, valueAt: index) * yDelta)
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

    private func addXAxisLabels(for points: [CGPoint], from dataSource: GraphViewDataSource) {
        xAxisLabels.forEach { $0.removeFromSuperview() }
        xAxisLabels.removeAll(keepingCapacity: true)

        for (index, point) in points.enumerated() {
            let text = dataSource.graphView(self, xAxisLabelForPointAt: index)
            let label = UILabel(frame: .zero)
            label.font = UIFont.preferredFont(forTextStyle: .caption2)
            label.adjustsFontForContentSizeCategory = true
            label.textColor = xAxisLabelTextColor
            label.backgroundColor = backgroundColor
            label.text = text
            label.sizeToFit()
            label.center = CGPoint(x: point.x, y: bounds.maxY - label.bounds.height / 2 - 4)
            addSubview(label)
            xAxisLabels.append(label)
        }
    }

    private func addGridLines(from dataSource: GraphViewDataSource) {
        let numberOfGridLines = dataSource.numberOfHorizontalGridLines(in: self)
        let gridLinePath = CGMutablePath()
        let ySpacing = plotFrame.height / CGFloat(numberOfGridLines - 1)

        for index in 0..<numberOfGridLines {
            gridLinePath.move(to: CGPoint(x: plotFrame.minX, y: ySpacing * CGFloat(index) + plotFrame.minY))
            gridLinePath.addLine(to: CGPoint(x: plotFrame.maxX, y: ySpacing * CGFloat(index) + plotFrame.minY))
        }

        gridLines.path = gridLinePath
    }

    private func addYAxisLabels(from dataSource: GraphViewDataSource) {
        yAxisLabels.forEach { $0.removeFromSuperview() }
        yAxisLabels.removeAll(keepingCapacity: true)

        let numberOfLabels = dataSource.numberOfHorizontalGridLines(in: self)
        let ySpacing = plotFrame.height / CGFloat(numberOfLabels - 1)

        for index in 0..<numberOfLabels {
            let text = dataSource.graphView(self, labelForHorizontalGridLineAt: index)
            let label = UILabel(frame: .zero)
            label.font = UIFont.preferredFont(forTextStyle: .caption2)
            label.adjustsFontForContentSizeCategory = true
            label.textColor = xAxisLabelTextColor
            label.backgroundColor = backgroundColor
            label.text = text
            label.sizeToFit()
            label.center = CGPoint(x: 20, y: plotFrame.maxY - ySpacing * CGFloat(index))
            addSubview(label)
            yAxisLabels.append(label)
        }
    }
}
