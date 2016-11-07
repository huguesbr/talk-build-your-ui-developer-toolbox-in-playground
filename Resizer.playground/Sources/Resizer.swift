import UIKit

/**
 Resizer
 Add any view as the `contentView` and it will be automatically resize to the resizer frame
 */
public class Resizer: UIControl {
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
    
    public var contentView: UIView? {
        didSet {
            guard let contentView = contentView else { return }
            addSubview(contentView)
            resizeContentView()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        clipsToBounds = false
        backgroundColor = UIColor.clear
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // draw handle
        let topRight = Handle.bottomRight.point(frame: bounds)
        drawCorner(origin: topRight, radius: handleRadius)
    }
    
    func resizeContentView() {
        // reajust contenView's frame
        contentView?.frame = bounds.insetBy(dx: 20, dy: 20)
    }
    
    /**
     Draw handle at point with radius
     
     - Parameter origin: center of the point
     - Parameter radius: radius of the circle around
     */
    func drawCorner(origin: CGPoint, radius: CGFloat) {
        guard let c = UIGraphicsGetCurrentContext() else {
            return
        }
        
        c.setFillColor(UIColor.white.cgColor)
        c.beginPath()
        c.move(to: CGPoint(x: origin.x - radius, y: origin.y))
        c.addLine(to: CGPoint(x: origin.x, y: origin.y - radius))
        c.addLine(to: CGPoint(x: origin.x, y: origin.y))
        c.fillPath()
    }
    
    // MARK: handles dragging
    
    /**
     Internal enum to identify each control point handle
     TODO: replace by extension on CGRect...
     */
    enum Handle {
        case topLeft, topRight, bottomRight, bottomLeft
        func point(frame: CGRect) -> CGPoint {
            // CoreGraphics inverted ordinate coordinate
            switch self {
            case .bottomLeft:
                return CGPoint(x: frame.minX, y: frame.maxY)
            case .bottomRight:
                return CGPoint(x: frame.maxX, y: frame.maxY)
            case .topRight:
                return CGPoint(x: frame.maxX, y: frame.minY)
            case .topLeft:
                return CGPoint(x: frame.minX, y: frame.maxY)
            }
        }
    }
    var selectedHandle: Handle?
    
    /**
     Determine which handle (or none) is selected
     */
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let handles: [Handle] = [.topLeft, .topRight, .bottomRight, .bottomLeft]
        selectedHandle = nil
        // check if touche happen next to a handle
        for handle in handles {
            if distanceBetweenPoints(a: location, b: handle.point(frame: bounds)) < dragRadius {
                selectedHandle = handle
                break
            }
        }
    }
    
    /**
     Curve control points changed, update internal timing function and propagate actions
     */
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedHandle = selectedHandle else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        var newFrame = frame
        // Only handle bottom right for now
        // TODO: add other handle
        switch selectedHandle {
        case .bottomRight:
            // resize frame based on current location
            newFrame.size.height = location.y
            newFrame.size.width = location.x
        default:
            break
        }
        frame = newFrame
        resizeContentView()
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

public extension CGPoint {
    /**
     Cap a point to a max rectangle.
     Ex.:
     - (15, 10).capped((5, 5), (10, 10)) -> (10, 10)
     - (1, 10).capped((5, 5), (10, 10)) -> (5, 10)
     - (5, 20).capped((5, 5), (10, 10)) -> (5, 10)
     - (5, 1).capped((5, 5), (10, 10)) -> (5, 5)
     
     - Parameter frame: max rectangle
     
     - Returns: capped (new value) point
     */
    func capped(frame: CGRect) -> CGPoint {
        let x = min(max(self.x, frame.minX), frame.maxX)
        let y = min(max(self.y, frame.minY), frame.maxY)
        return CGPoint(x: x, y: y)
    }
    
    /**
     Mutable version of capped.
     
     - SeeAlso: `capped(frame: CGRect)`
     */
    mutating func cap(frame: CGRect) {
        self = capped(frame: frame)
    }
}

