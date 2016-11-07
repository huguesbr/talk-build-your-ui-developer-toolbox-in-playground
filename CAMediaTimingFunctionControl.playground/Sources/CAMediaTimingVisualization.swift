import UIKit

/**
 Simple animation displaying the speed of a CAMediaTimingFunction
 */
public class CAMediaTimingVisualizationView: UIView {
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) {
        didSet {
            animate()
        }
    }

    public var animationDuration: CFTimeInterval = 3.0
    public var color: UIColor = .red

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var width: CGFloat {
        return bounds.size.width
    }

    var height: CGFloat {
        return bounds.size.height
    }

    var circleRadius: CGFloat {
        return height / 2
    }

    lazy var circleLayer: CAShapeLayer = { [weak self] in
        let layer = CAShapeLayer()
        layer.fillColor = self?.color.cgColor
        return layer
    }()

    func setup() {
        layer.addSublayer(circleLayer)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: circleRadius, y: circleRadius), radius: circleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).cgPath
    }

    public var animation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 0
        animation.toValue = width - circleRadius * 2
        animation.duration = animationDuration
        animation.timingFunction = timingFunction
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        return animation
    }

    func animate() {
        circleLayer.removeAllAnimations()
        circleLayer.add(animation, forKey: "animation")
    }
}
