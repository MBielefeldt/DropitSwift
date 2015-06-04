//
//  DropitViewController.swift
//  DropitSwift
//
//  Created by Mads Bielefeldt on 03/06/15.
//  Copyright (c) 2015 Mads Bielefeldt. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController
{
    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {
       return UIDynamicAnimator(referenceView: self.gameView) /* use lazy here to be allowed to reference gameView */
    }()
    
    let gravity = UIGravityBehavior()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true /* use lazy to allow configuration (could apparently have been done without lazy as well) */
        return lazilyCreatedCollider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(gravity)
        animator.addBehavior(collider)
    }
    
    var dropsPerRow = 10
    
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer)
    {
        drop()
    }
    
    private func drop()
    {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        gameView.addSubview(dropView)
        
        gravity.addItem(dropView)
        collider.addItem(dropView)
    }
}

private extension CGFloat
{
    static func random(max: Int) -> CGFloat
    {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor
{
    class var random: UIColor {
        switch arc4random() % 5 {
            case 0:  return UIColor.greenColor()
            case 1:  return UIColor.blueColor()
            case 2:  return UIColor.orangeColor()
            case 3:  return UIColor.redColor()
            case 4:  return UIColor.purpleColor()
            default: return UIColor.blackColor()
        }
    }
}