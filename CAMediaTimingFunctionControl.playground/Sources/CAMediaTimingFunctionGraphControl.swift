import UIKit

/**
 CAMediaTimingFunctionControl, allow to visualize and tweak the control points (except end points, as automatically set by CAMediaTimingFunction) of a bezier curve
 Heavily inspired by [http://cubic-bezier.com/](http://cubic-bezier.com/) and [https://github.com/simonwhitaker/tween-o-matic](https://github.com/simonwhitaker/tween-o-matic)
 */
public class CAMediaTimingFunctionGraphControl: UIControl {
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) {
        didSet {
            setNeedsDisplay()
        }
    }

    public var onValueDidChange: ((_ timingFunction: CAMediaTimingFunction) -> Void)?

    func dispatchValueChange(timingFunction: CAMediaTimingFunction) {
        onValueDidChange?(timingFunction)
        sendActions(for: .valueChanged)
    }

    public var border: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var handleRadius: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var dragRadius: Float = 20

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // XXX: CG vs UKit
        layer.transform = CATransform3DMakeScale(1, -1, 1)
    }

    var gridFrame: CGRect {
        return CGRect(x: border, y: border, width: w, height: h)
    }

    var w: CGFloat {
        return self.frame.width - border * 2
    }

    var h: CGFloat {
        return self.frame.height - border * 2
    }

    /**
     Normalize a point.
     Convert it from local coordinate (gridFrame) to [(0.0, 1.0), (0.0, 1.0)] coordinate space

     - Parameter point: point to be normalize

     - Returns: **normalized** point

     */
    func normalizedPoint(point: CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - border) / w, y: (point.y - border) / h)
    }

    /**
     Denormalize a point.
     Convert it from [(0.0, 1.0), (0.0, 1.0)] coordinate space to local coordinate (gridFrame)

     - Parameter point: point to be denormalize

     - Returns: **denormalized** point

     */
    func denormalizedPoint(point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * w + border, y: point.y * h + border)
    }

    var controlPoints: [CGFloat] {
        return timingFunction.controlPoints.map { CGFloat($0) }
    }

    /**
     - Returns: **Normalized** bezier control point 1
     */
    var controlPoint1: CGPoint {
        get {
            return CGPoint(x: controlPoints[0], y: controlPoints[1])
        }
        set {
            var p = timingFunction.controlPoints
            p[0] = Float(newValue.x)
            p[1] = Float(newValue.y)
            timingFunction = CAMediaTimingFunction(controlPoints: p)!
        }
    }

    /**
     - Returns: **Normalized** bezier control point 2
     */
    var controlPoint2: CGPoint {
        get {
            return CGPoint(x: controlPoints[2], y: controlPoints[3])
        }
        set {
            var p = timingFunction.controlPoints
            p[2] = Float(newValue.x)
            p[3] = Float(newValue.y)
            timingFunction = CAMediaTimingFunction(controlPoints: p)!
        }
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        // background
        UIColor.white.setFill()
        UIRectFill(rect)

        // curve end points
        let origin = CGPoint(x: border, y: border)
        let dest = CGPoint(x: w + border, y: h + border)

        // curve control points
        let normalizedControlPoint1 = denormalizedPoint(point: controlPoint1)
        let normalizedControlPoint2 = denormalizedPoint(point: controlPoint2)

        // draw grid
        UIColor.gray.set()
        let gridFrame = CGRect(x: border, y: border, width: w, height: h)
        drawGrid(inRect: gridFrame, lineCount: 10, lineWidth: 1)

        // draw the bezier curve
        UIColor.black.set()
        drawCurve(origin: origin, dest: dest, controlPoint1: normalizedControlPoint1, controlPoint2: normalizedControlPoint2, width: 3)

        // draw control lines and control point's handles (circle)
        UIColor.red.set()
        UIColor.white.setFill()
        drawLine(origin: origin, dest: normalizedControlPoint1, width: 3)
        drawCircle(origin: normalizedControlPoint1, radius: handleRadius)
        drawLine(origin: dest, dest: normalizedControlPoint2, width: 3)
        drawCircle(origin: normalizedControlPoint2, radius: handleRadius)
    }

    // MARK: draw helpers methods

    /**
     Draw a grid

     - Parameter a: first point
     - Parameter b: second point
     - Parameter width: width of the line
     */
    func drawGrid(inRect: CGRect, lineCount: UInt, lineWidth: CGFloat) {
        for i in 0...lineCount {
            let x = inRect.width / CGFloat(lineCount) * CGFloat(i) + inRect.origin.x
            let y = inRect.height / CGFloat(lineCount) * CGFloat(i) + inRect.origin.y
            drawLine(origin: CGPoint(x: inRect.origin.x, y: y), dest: CGPoint(x: w + inRect.origin.x, y: y), width: lineWidth)
            drawLine(origin: CGPoint(x: x, y: inRect.origin.y), dest: CGPoint(x: x, y: h + inRect.origin.y), width: lineWidth)
        }
    }

    /**
     Draw a line between two points with specific width

     - Parameter origin: first point
     - Parameter dest: second point
     - Parameter width: width of the line
     */
    func drawLine(origin: CGPoint, dest: CGPoint, width: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: origin.x, y: origin.y))
        path.addLine(to: CGPoint(x: dest.x, y: dest.y))
        path.lineWidth = width
        path.stroke()
    }

    /**
     Draw curve at point
     [BezierPaths](https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html)
     */
    func drawCurve(origin: CGPoint, dest: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, width: CGFloat) {
        // https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html
        let path = UIBezierPath()
        path.move(to: origin)
        path.addCurve(to: dest, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        path.lineWidth = width
        path.stroke()
    }


    /**
     Draw circle (handle) at point with radius

     - Parameter origin: center of the point
     - Parameter radius: radius of the circle around
     */
    func drawCircle(origin: CGPoint, radius: CGFloat) {
        let path = UIBezierPath(arcCenter: origin, radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
        path.fill()
        path.stroke()
    }

    // MARK: bezier curve handles dragging

    /**
     Internal enum to identify each control point handle
     */
    enum Handle {
        case a, b
    }
    var controlPointHandle: Handle?

    /**
     Determine which handle (or none) is selected
     */
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        if distanceBetweenPoints(a: location, b: denormalizedPoint(point: controlPoint1)) < dragRadius {
            controlPointHandle = .a
        } else if distanceBetweenPoints(a: location, b: denormalizedPoint(point: controlPoint2)) < dragRadius {
            controlPointHandle = .b
        } else {
            controlPointHandle = nil
        }
    }

    /**
     Curve control points changed, update internal timing function and propagate actions
     */
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let controlPointHandle = controlPointHandle else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self).capped(frame: gridFrame)
        let normalize = normalizedPoint(point: location)
        switch controlPointHandle {
        case .a:
            controlPoint1 = normalize
        case .b:
            controlPoint2 = normalize
        }
        dispatchValueChange(timingFunction: timingFunction)
    }

    /**
     Calculate distance between to point
     (used by handle pickup margin)

     - Parameter a: first point
     - Parameter a: second point

     - Returns: Distance between point
     */
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> Float {
        let x: Float = Float(a.x) - Float(b.x);
        let y: Float = Float(a.y) - Float(b.y);
        return sqrtf(x * x + y * y);
    }
}
