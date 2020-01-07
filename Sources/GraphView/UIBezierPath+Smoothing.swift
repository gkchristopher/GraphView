import Foundation
import UIKit

extension UIBezierPath {

    static func hermiteInterpolation(for points: [CGPoint]) -> UIBezierPath? {
        guard points.count > 2 else { return nil }

        let path = UIBezierPath()
        let numberOfCurves = points.count - 1

        (0..<numberOfCurves).forEach { index in
            var currentPoint = points[index]
            if index == 0 {
                path.move(to: currentPoint)
            }

            var nextIndex = (index + 1) % points.count
            var prevIndex = index - 1 < 0 ? points.count - 1 : index - 1
            var nextPoint = points[nextIndex]
            var prevPoint = points[prevIndex]
            let endPoint = nextPoint

            var mX: CGFloat
            var mY: CGFloat
            if index > 0 {
                mX = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - prevPoint.x) * 0.5
                mY = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - prevPoint.y) * 0.5
            } else {
                mX = (nextPoint.x - currentPoint.x) * 0.5
                mY = (nextPoint.y - currentPoint.y) * 0.5
            }

            var cntrlPoint1 = CGPoint.zero
            cntrlPoint1.x = currentPoint.x + mX / 3.0
            cntrlPoint1.y = currentPoint.y + mY / 3.0

            currentPoint = points[nextIndex]
            nextIndex = (nextIndex + 1) % points.count
            prevIndex = index
            nextPoint = points[nextIndex]
            prevPoint = points[prevIndex]

            if index < numberOfCurves - 1 {
                mX = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - prevPoint.x) * 0.5
                mY = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - prevPoint.y) * 0.5
            } else {
                mX = (currentPoint.x - prevPoint.x) * 0.5
                mY = (currentPoint.y - prevPoint.y) * 0.5
            }

            var cntrlPoint2 = CGPoint.zero
            cntrlPoint2.x = currentPoint.x - mX / 3.0
            cntrlPoint2.y = currentPoint.y - mY / 3.0

            path.addCurve(to: endPoint, controlPoint1: cntrlPoint1, controlPoint2: cntrlPoint2)
        }

        return path
    }
}
