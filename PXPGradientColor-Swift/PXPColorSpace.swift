//
//  PXPColorSpace.swift
//  GradientColorSample
//
//  Created by Louka Desroziers on 10/06/2014.
//  Copyright (c) 2014 PixiApps. All rights reserved.
//

import Foundation
import QuartzCore


class PXPColorSpace
{
    internal let colorSpaceRef: CGColorSpace
    var numberOfComponents: Int { return Int(CGColorSpaceGetNumberOfComponents(self.colorSpaceRef)) }
    
    init(colorSpaceRef: CGColorSpace) {
        self.colorSpaceRef = colorSpaceRef
    }
    
    /** Convenience init with a RGB color space */
    convenience init() {
        self.init(colorSpaceRef: CGColorSpaceCreateDeviceRGB()!)
    }
    
    class func deviceRGBColorSpace() -> PXPColorSpace {
        return PXPColorSpace(colorSpaceRef: CGColorSpaceCreateDeviceRGB()!)
    }
    class func deviceCMYKColorSpace() -> PXPColorSpace {
        return PXPColorSpace(colorSpaceRef: CGColorSpaceCreateDeviceCMYK()!)
    }
    class func deviceGrayColorSpace() -> PXPColorSpace {
        return PXPColorSpace(colorSpaceRef: CGColorSpaceCreateDeviceGray()!)
    }
}