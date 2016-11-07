import QuartzCore

public extension CAMediaTimingFunction {
    /**
     - Returns: Bezier curve controls points of the timing function
     */
    var controlPoints: [Float] {
        var points: [[Float]] = []
        for i in 1...2 {
            var point = [Float](repeating: 0, count: 2)
            getControlPoint(at: i, values: &point)
            points.append(point)
        }
        return Array(points.flatMap { $0 })
    }

    /**
     (Failable) convenience initializer to create CATimingFunction from an array of 4 value.
     End points of the Bezier curve are set automatically to 0,0 and 1,1.

     - Parameter controlPoints: Array of 4 float, x1, y1, x2, y2 of the control points

     - Failable: failed if array dont contains 4 points
     */
    convenience init?(controlPoints: [Float]) {
        if controlPoints.count != 4 {
            return nil
        }
        self.init(controlPoints: controlPoints[0], controlPoints[1], controlPoints[2], controlPoints[3])
    }
}
