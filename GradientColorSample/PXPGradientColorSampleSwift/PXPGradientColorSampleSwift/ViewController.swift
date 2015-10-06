//
//  ViewController.swift
//  PXPGradientColorSampleSwift
//
//  Created by Louka Desroziers on 10/06/2014.
//  Copyright (c) 2014 PixiApps. All rights reserved.
//

import UIKit

enum PXPGeometryType: Int {
    case Rectangle, Oval, Circle
}

class PXPGradientGeometryView : UIView {
    
    var geometryType: PXPGeometryType = .Rectangle
    var gradient: PXPGradientColor? { didSet { self.setNeedsDisplay() } }
    var angle: Double! = 90.0 { didSet { self.setNeedsDisplay() } }
    
    var bezierPath: UIBezierPath {
    get {
        switch self.geometryType {
        case .Oval:
            return UIBezierPath(ovalInRect: self.bounds)
        case .Circle:
            let diameter: CGFloat = min(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
            return UIBezierPath(ovalInRect: CGRect(x: CGRectGetWidth(self.bounds)/2.0 - diameter/2.0, y: CGRectGetHeight(self.bounds)/2.0 - diameter/2.0, width: diameter, height: diameter))
        default:
            return UIBezierPath(rect: self.bounds)
        }
    }
    }
    
    init(frame: CGRect, geometryType: PXPGeometryType) {
        self.geometryType = geometryType
        super.init(frame: frame)
    }
    override convenience init(frame: CGRect)  {
        self.init(frame: frame, geometryType: .Rectangle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.geometryType = PXPGeometryType(rawValue: aDecoder.decodeIntegerForKey("rawGeometryType"))!
        self.angle = aDecoder.decodeDoubleForKey("angle")
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeDouble(self.angle, forKey: "angle")
        aCoder.encodeInteger(self.geometryType.rawValue, forKey: "rawGeometryType")
    }
    
    override func drawRect(rect: CGRect) {
        if self.gradient != nil {
            self.gradient!.draw(inBezierPath: self.bezierPath, angle: self.angle)
        } else {
            let ctx: CGContextRef = UIGraphicsGetCurrentContext()
            
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor)
            CGContextAddPath(ctx, self.bezierPath.CGPath)
            CGContextFillPath(ctx)
            CGContextRestoreGState(ctx);
        }
    }
    
}

class ViewController: UIViewController {
    
    let testView: PXPGradientGeometryView = PXPGradientGeometryView(frame: CGRectZero, geometryType: .Rectangle)
    let angleSlider: UISlider = UISlider(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.testView)
        self.testView.gradient = PXPGradientColor(colors: [UIColor.whiteColor(), UIColor.blackColor(), UIColor.blueColor()], locations: nil, colorSpace: nil)
        
        self.view.addSubview(self.angleSlider)
        self.angleSlider.minimumValue = 0.0
        self.angleSlider.maximumValue = 360.0
        self.angleSlider.addTarget(self, action: "updateAngleValue:", forControlEvents: UIControlEvents.ValueChanged)
        self.angleSlider.value = Float(self.testView.angle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.testView.frame = self.view.bounds
        self.angleSlider.sizeToFit()
        self.angleSlider.frame.origin = CGPoint(x: 10, y: CGRectGetHeight(self.view.bounds) - (CGRectGetHeight(self.angleSlider.frame) + 10))
        self.angleSlider.frame.size.width = CGRectGetWidth(self.view.bounds) - CGRectGetMinX(self.angleSlider.frame)*2
    }
    
    // MARK: UI Interaction
    func updateAngleValue(sender: AnyObject) {
        self.testView.angle = Double(self.angleSlider.value)
    }

}

