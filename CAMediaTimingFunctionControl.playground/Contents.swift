//
//  CAMediaTimingFunction Simulator
//
//  Created by Hugues Bernet-Rollande on 13/4/16.
//  Copyright © 2016 Hugues Bernet-Rollande. All rights reserved.
//

import UIKit
import PlaygroundSupport

let size = CGSize(width: 800, height: 800)
let frame = CGRect(origin: CGPoint.zero, size: size)
let (controlFrame, viewFrame) = frame.divided(atDistance: size.height / 2, from: .maxYEdge)

let view = UIView(frame: frame)
view.backgroundColor = UIColor.white

PlaygroundPage.current.liveView = view

// default timing function
let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

// sampleView
let sampleView = SampleView(frame: viewFrame.insetBy(dx: size.width / 4, dy: 0))
view.addSubview(sampleView)
// set default timing of the animation
sampleView.timingFunction = timingFunction

// add the CAMediaTimingFunctionControl
let control = CAMediaTimingFunctionControl(frame: controlFrame)
control.timingFunction = timingFunction
view.addSubview(control)

control.onValueDidChange = {
    sampleView.timingFunction = $0
}
