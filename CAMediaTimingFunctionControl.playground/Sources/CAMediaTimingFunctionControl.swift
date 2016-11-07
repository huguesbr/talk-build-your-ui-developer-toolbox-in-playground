import UIKit

/**
 CAMediaTimingFunctionControl, agreggator of the different bezier curve controls (graph, slider, label)
 - SeeAlso: `CAMediaTimingFunctionGraphControl`, `CAMediaTimingFunctionSliderControl`, `CAMediaTimingFunctionLabel`
 */
public class CAMediaTimingFunctionControl: UIControl {
    var graph: CAMediaTimingFunctionGraphControl!
    var slider: CAMediaTimingFunctionSliderControl!
    var label: CAMediaTimingFunctionLabel!
    var visualization: CAMediaTimingVisualizationView!

    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction() {
        didSet {
            updateValue()
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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setupControls()
        setupActions()
    }

    func setupControls() {
        graph = CAMediaTimingFunctionGraphControl(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addSubview(graph)
        slider = CAMediaTimingFunctionSliderControl(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addSubview(slider)
        label = CAMediaTimingFunctionLabel()
        addSubview(label)
        visualization = CAMediaTimingVisualizationView()
        addSubview(visualization)
    }

    func setupActions() {
        // Curve control points changed, update internal timing function and propagate actions
        let updateAndDispatch: (CAMediaTimingFunction) -> Void = { [weak self] in
            self?.timingFunction = $0
            self?.dispatchValueChange(timingFunction: $0)
        }
        graph.onValueDidChange = updateAndDispatch
        slider.onValueDidChange = updateAndDispatch
    }

    var controlSize: CGSize {
        return CGSize(width: bounds.width / 2, height: bounds.size.height - 40)
    }

    var labelSize: CGSize {
        return CGSize(width: bounds.width / 2, height: 20)
    }

    var visualizationSize: CGSize {
        return CGSize(width: bounds.width / 2, height: 20)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        graph?.frame = CGRect(origin: CGPoint.zero, size: controlSize)
        slider?.frame = CGRect(origin: CGPoint(x: controlSize.width, y: 0), size: controlSize)
        label?.frame = CGRect(origin: CGPoint(x: 0, y: controlSize.height), size: labelSize)
        visualization?.frame =  CGRect(origin: CGPoint(x: controlSize.width, y: controlSize.height), size: visualizationSize)
    }

    /**
     New timing function, proxy value to all the controls
     */
    func updateValue() {
        graph.timingFunction = timingFunction
        slider.timingFunction = timingFunction
        label.timingFunction = timingFunction
        visualization.timingFunction = timingFunction
    }
}
