//
//  CAMediaTimingFunction Simulator
//
//  Created by Hugues Bernet-Rollande on 13/4/16.
//  Copyright © 2016 Hugues Bernet-Rollande. All rights reserved.
//

import UIKit
import PlaygroundSupport

let width = 800
let height = 600

var x = 0
var y = 0
var size = height / 2

let view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
view.backgroundColor = UIColor.white

PlaygroundPage.current.liveView = view

// default timing function
let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

// sampleView
let sampleView = SampleView(frame: CGRect(x: width / 2 - size / 2, y: y, width: size, height: size))
view.addSubview(sampleView)
sampleView.backgroundColor = UIColor.white
sampleView.animating = true
sampleView.timingFunction = timingFunction
y += size

// curve controls
let c = CAMediaTimingFunctionControl(frame: CGRect(x: 0, y: y, width: width, height: size))
c.timingFunction = timingFunction
view.addSubview(c)

c.onValueDidChange = {
    sampleView.timingFunction = $0
}
