import UIKit

public class SampleView: UIView {
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) {
        didSet {
            stopAnimating()
            startAnimating()
        }
    }

    public var animating: Bool = true {
        didSet {
            if animating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    @nonobjc static let animationKey = "animation"

    var animationKey: String {
        return type(of: self).animationKey
    }

    var radius: CGFloat {
        return self.bounds.width / 2
    }

    var relativeCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    func circularPath(radius: CGFloat) -> CGPath {
        let angle_360 = CGFloat(M_PI * 2)
        return UIBezierPath(arcCenter: relativeCenter, radius: radius, startAngle: 0, endAngle: angle_360, clockwise: true).cgPath
    }

    func circle(path: CGPath, color: UIColor) -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = path
        backgroundLayer.fillColor = color.cgColor
        return backgroundLayer
    }

    lazy var backgroundLayer: CAShapeLayer = {
        let path = self.circularPath(radius: self.radius)
        return self.circle(path: path, color: UIColor.black)
    }()

    lazy var middleCircleLayer: CAShapeLayer = {
        let path = self.circularPath(radius: self.radius * 2/3)
        return self.circle(path: path, color: UIColor.white)
    }()

    lazy var innerCircleLayer: CAShapeLayer = {
        let path = self.circularPath(radius: self.radius * 1/3)
        return self.circle(path: path, color: UIColor.red)
    }()

    func setup() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(middleCircleLayer)
        layer.addSublayer(innerCircleLayer)
    }

    var animationStartPath: CGPath {
        return self.circularPath(radius: self.radius * 1/12)
    }

    var animationEndPath: CGPath {
        return self.circularPath(radius: self.radius * 2/3)
    }

    var animation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = self.animationStartPath
        animation.toValue = self.animationEndPath
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        animation.timingFunction = self.timingFunction
        animation.autoreverses = true
        return animation
    }

    func startAnimating() {
        if innerCircleLayer.animation(forKey: animationKey) != nil {
            return
        }
        innerCircleLayer.add(animation, forKey: animationKey)
    }

    func stopAnimating() {
        innerCircleLayer.removeAnimation(forKey: animationKey)
    }
}
