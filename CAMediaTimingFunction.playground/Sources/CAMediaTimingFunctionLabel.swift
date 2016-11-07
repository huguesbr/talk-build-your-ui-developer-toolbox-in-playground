import UIKit

/**
 Simple label displaying the control points of a CAMediaTimingFunction
 */
public class CAMediaTimingFunctionLabel: UITextField {
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) {
        didSet {
            text = "\(timingFunction.controlPoints)"
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        textAlignment = .center
    }
}
