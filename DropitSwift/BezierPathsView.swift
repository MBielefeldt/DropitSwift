//
//  BezierPathsView.swift
//  DropitSwift
//
//  Created by Mads Bielefeldt on 04/06/15.
//  Copyright (c) 2015 Mads Bielefeldt. All rights reserved.
//

import UIKit

class BezierPathsView: UIView
{
    var bezierPaths = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String)
    {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect)
    {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
