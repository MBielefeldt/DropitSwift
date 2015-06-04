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
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true /* use lazy to allow configuration (could apparently have been done without lazy as well) */
        return lazilyCreatedCollider
    }()
    
    override init()
    {
        super.init()
        
        self.addChildBehavior(gravity)
        self.addChildBehavior(collider)
    }
    
    func addDrop(drop: UIView)
    {
        dynamicAnimator?.referenceView?.addSubview(drop)
        
        gravity.addItem(drop)
        collider.addItem(drop)
    }
    
    func removeDrop(drop: UIView)
    {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        
        drop.removeFromSuperview()
    }
}
