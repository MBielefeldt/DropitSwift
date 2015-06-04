//
//  DropitViewController.swift
//  DropitSwift
//
//  Created by Mads Bielefeldt on 03/06/15.
//  Copyright (c) 2015 Mads Bielefeldt. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate
{
    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView) /* use lazy here to be allowed to reference gameView */
        lazilyCreatedAnimator.delegate = self
        return lazilyCreatedAnimator
    }()
    
    let dropitBehavior = DropitBehavior()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        animator.addBehavior(dropitBehavior)
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator)
    {
        removeCompletedRow()
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
        
        dropitBehavior.addDrop(dropView)
    }
    
    private func removeCompletedRow()
    {
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        do {
            dropFrame.origin.x = 0
            dropFrame.origin.y -= dropSize.height

            var dropsFound = [UIView]()
            var rowIsComplete = true
            
            for _ in 0 ..< dropsPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil) {
                    if hitView.superview == gameView {
                        dropsFound.append(hitView)
                    } else {
                        rowIsComplete = false
                        break;
                    }
                }
                dropFrame.origin.x += dropFrame.width
            }
            
            if rowIsComplete {
                dropsToRemove += dropsFound
            }
        
        } while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove {
            dropitBehavior.removeDrop(drop)
        }
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