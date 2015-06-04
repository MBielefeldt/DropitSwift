//
//  DropitBehavior.swift
//  DropitSwift
//
//  Created by Mads Bielefeldt on 04/06/15.
//  Copyright (c) 2015 Mads Bielefeldt. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior
{
    let gravity = UIGravityBehavior()
    
    let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    let dropBehavior: UIDynamicItemBehavior = {
        let dropBehavior = UIDynamicItemBehavior()
        dropBehavior.allowsRotation = false
        dropBehavior.elasticity = 0.75
        return dropBehavior
    }()
    
    override init()
    {
        super.init()
        
        self.addChildBehavior(gravity)
        self.addChildBehavior(collider)
        self.addChildBehavior(dropBehavior)
    }
    
    func addDrop(drop: UIView)
    {
        dynamicAnimator?.referenceView?.addSubview(drop)
        
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView)
    {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        
        drop.removeFromSuperview()
    }
}
