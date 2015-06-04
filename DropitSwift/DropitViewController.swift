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
    @IBOutlet weak var gameView: BezierPathsView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView) /* use lazy here to be allowed to reference gameView */
        lazilyCreatedAnimator.delegate = self
        return lazilyCreatedAnimator
    }()
    
    let dropitBehavior = DropitBehavior()
    
    var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment)
                gameView.setPath(nil, named: PathNames.Attachment)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment)
                attachment!.action = { [unowned self] in
                    let path = UIBezierPath()
                    if let attachedView = self.attachment!.items.first as? UIView {
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        animator.addBehavior(dropitBehavior)
    }
    
    struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width/2, y: gameView.bounds.midY - barrierSize.height/2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        
        dropitBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        gameView.setPath(path, named: PathNames.MiddleBarrier)
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
    
    var lastDroppedView: UIView?
    
    @IBAction func grabDrop(sender: UIPanGestureRecognizer)
    {
        let gesturePoint = sender.locationInView(gameView)
        
        switch sender.state {
            case .Began:
                if let itemToAttachTo = lastDroppedView {
                    attachment = UIAttachmentBehavior(item: lastDroppedView!, attachedToAnchor: gesturePoint)
                    lastDroppedView = nil /* to make sure that you cannot pick up the same drop again and again */
                }
            case .Changed:
                attachment?.anchorPoint = gesturePoint
            case .Ended:
                attachment = nil
            default:
                break
        }
    }
    
    private func drop()
    {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        lastDroppedView = dropView
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