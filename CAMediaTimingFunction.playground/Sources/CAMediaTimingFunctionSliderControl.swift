import UIKit

/**
 Simple set of sliders to control the control points of a CAMediaTimingFunction
 */
public class CAMediaTimingFunctionSliderControl: UIControl, UITextFieldDelegate {
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn) {
        didSet {
            updateValues()
        }
    }

    public var onValueDidChange: ((_ timingFunction: CAMediaTimingFunction) -> Void)?

    func dispatchValueChange(timingFunction: CAMediaTimingFunction) {
        onValueDidChange?(timingFunction)
        sendActions(for: .valueChanged)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var labels: [UILabel] = []

    var textFields: [UITextField] = []

    var sliders: [UISlider] = []

    func setup() {
        let legends = ["x1", "y1", "x2", "y2"]
        for i in 0...3 {
            addLabel(text: legends[i])
            addTextField()
            addSlider()
        }
    }

    func addLabel(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.text = text
        addSubview(label)
        labels.append(label)
    }

    func addTextField() {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.delegate = self
        textField.text = "0"
        addSubview(textField)
        textFields.append(textField)
    }

    func addSlider() {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        slider.addTarget(self, action: #selector(CAMediaTimingFunctionSliderControl.valuesDidChange), for: .valueChanged)
        addSubview(slider)
        sliders.append(slider)
    }

    var padding: CGFloat {
        return 5
    }

    var labelWidth: CGFloat {
        return bounds.width / 2 / 5
    }

    var sliderWidth: CGFloat {
        return bounds.width / 2 * 3/5 - padding * 4
    }

    var controlHeight: CGFloat {
        return bounds.height / 2
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        var y: CGFloat = 0
        let width = bounds.width / 2
        for i in 0...3 {
            if i == 2 {
                y += controlHeight
            }
            let x = (i % 2) == 0 ? 0 : width + padding * 2
            labels[i].frame = CGRect(x: x, y: y, width: labelWidth, height: controlHeight)
            textFields[i].frame = CGRect(x: x + labelWidth + padding, y: y, width: labelWidth, height: controlHeight)
            sliders[i].frame = CGRect(x: x + labelWidth * 2 + padding * 2, y: y, width: sliderWidth, height: controlHeight)
        }
    }

    /**
     Sliders value changed, update internal timing function and propagate actions
    */
    @objc func valuesDidChange() {
        let values = sliders.map { $0.value }
        timingFunction = CAMediaTimingFunction(controlPoints: values)!
        dispatchValueChange(timingFunction: timingFunction)
    }

    /**
     Timing function value changed, update sliders and textfields
    */
    func updateValues() {
        for (i, v) in timingFunction.controlPoints.enumerated() {
            sliders[i].value = v
            let string = NSString(format: "%.2f", v) as String
            textFields[i].text = string
        }
    }

    // MARK: UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
