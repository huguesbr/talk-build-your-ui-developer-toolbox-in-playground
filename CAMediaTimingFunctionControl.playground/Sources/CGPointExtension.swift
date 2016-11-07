import CoreGraphics

public extension CGPoint {
    init(x: Float, y: Float) {
        self.init(x: Double(x), y: Double(y))
    }

    init(_ x: Float, _ y: Float) {
        self.init(x: x, y: y)
    }

    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
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
