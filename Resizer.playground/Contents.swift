/**
 Resizer Demo
 Resizer control have a handle to resize itself.
 Any view set as the conteView of the resizer will automatically be set to resizer's frame.
 */
import UIKit
import PlaygroundSupport

class SampleView: UILabel {
    override public func layoutSubviews() {
        super.layoutSubviews()
        switch bounds.width {
        case _ where bounds.width < 100:
            backgroundColor = .red
        case _ where bounds.width < 200:
            backgroundColor = .blue
        default:
            backgroundColor = .green
        }
    }
}

let frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
let view = UIView(frame: frame)
view.backgroundColor = .lightGray
PlaygroundPage.current.liveView = view

let resizerView = Resizer(frame: view.frame)
view.addSubview(resizerView)

let sampleView = SampleView()
sampleView.text = "Hello,\nPlease test how this label ajust its content when resized.\nObviously it's more fun with your own view!"
sampleView.numberOfLines = 0
sampleView.backgroundColor = UIColor.purple
resizerView.contentView = sampleView
