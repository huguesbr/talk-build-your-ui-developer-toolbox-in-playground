# Talk at FrenchKit - Building your UI Developer Toolbox in Playground

Video available on FrenchKit website, or directly on YouTube: https://www.youtube.com/watch?v=JgzFkpLgblY

Slides in Keynote (Presenter's note included) or PDF here: https://github.com/huguesbr/talk-build-your-ui-developer-toolbox-in-playground/releases/tag/v1.0

Also available on Speaker Deck: https://speakerdeck.com/huguesbr/build-your-ui-developer-toolbox-using-playgrounds


## CAMediaTimingFunctionControl

**CAMediaTimingFunctionControl** is included in a `Swift Playground` (Swift 3.0) but classes could be use in any type of project (MacOS, iOS) with no or some minors adaptation.

It allow you to tweak in real time the timing (CAMediaTimingFunction) of any custom animation (CABasicAnimation, ...).

The animated view need to be copy/paste in the Playground and needs to support a way to update it's CAMediaTimingFunction (see SampleView for an exemple).

The idea is to embed the Playground in your project and then copy/paste any view from your project (hoping that Apple will allow to access view from your project in a future XCode update) in order to live tweak it's timing.

### Demo
![CAMediaTimingFunctionControl Demo](https://raw.githubusercontent.com/huguesbr/talk-build-your-ui-developer-toolbox-in-playground/master/resources/camediatimingfunctioncontrol-demo.gif)


### Usage

```
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
view.backgroundColor = UIColor.white

PlaygroundPage.current.liveView = view

// default timing function
let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

// add the sampleView
let centeredFrame = CGRect(x: 0, y: 0, width: 800, height: 300)
let sampleView = SampleView(frame: centeredFrame)
view.addSubview(sampleView)
// set default timing of the animation
sampleView.timingFunction = timingFunction
y += size

// add the CAMediaTimingFunctionControl below
let mediaTimingControl = CAMediaTimingFunctionControl(frame: CGRect(x: 0, y: 300, width: 800, height: 300))
// set default timing
mediaTimingControl.timingFunction = timingFunction
view.addSubview(mediaTimingControl)

// update the timing function of the sample view on each change 
mediaTimingControl.onValueDidChange = {
    sampleView.timingFunction = $0
}
```

## Resizer

**Resizer** is included in a `Swift Playground` (Swift 3.0) but classes could be use in any type of project (MacOS, iOS) with no or some minors adaptation.

It allow you to tweak in the size of any view to control how it behave based on this adjustement, cool be usefull when view is dynamically sized based on device orientation, gesture, animation, ...

The animated view need to be copy/paste in the Playground.

The idea is to embed the Playground in your project and then copy/paste any view from your project (hoping that Apple will allow to access view from your project in a future XCode update) in order to live tweak it's size.

### Demo
![CAMediaTimingFunctionControl Demo](https://raw.githubusercontent.com/huguesbr/talk-build-your-ui-developer-toolbox-in-playground/master/resources/resizer-demo.gif)


### Usage

```
import UIKit
import PlaygroundSupport

// setup liveView
let frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
let view = UIView(frame: frame)
view.backgroundColor = .lightGray
PlaygroundPage.current.liveView = view

// add resizer control
let resizer = Resizer(frame: view.frame)
view.addSubview(resizer)

// add custom view
// adding your own view to make it funnier :)
let sampleView = SampleView()
sampleView.backgroundColor = UIColor.purple
resizer.contentView = sampleView
```
