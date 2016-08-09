//
//  KWDurationTouchView.swift
//  KWDurationTouchView
//
//  Created by Konrad Winkowski on 8/9/16.
//  Copyright © 2016 KonradWinkowski. All rights reserved.
//

import UIKit

protocol KWDurationTouchViewDelegate : class {
    func didCompleteTouch(sender: KWDurationTouchView)
    func didCancelTouch(sender: KWDurationTouchView, atPercentage: CGFloat)
    func percentageOfProgress(sender: KWDurationTouchView, progress: CGFloat)
}

class KWDurationTouchView: UIView {
    
    var touchTimer: NSTimer!
    var durationOfCurrentTouch: CGFloat = 0.0
    var percent: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
            print(self.percent)
            
            if let touchDelegate = self.delegate{
                touchDelegate.percentageOfProgress(self, progress: self.percent)
            }
        }
    }
    
    weak var delegate : KWDurationTouchViewDelegate?
    
    @IBInspectable var touchDuration : CGFloat = 10.0
    @IBInspectable var strokeWidth : CGFloat = 2.0
    @IBInspectable var strokeColor : UIColor = UIColor.redColor()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setupTimer()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.cancelTouch()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.cancelTouch()
    }
    
    override func drawRect(rect: CGRect) {
        
        let startAngle: CGFloat = CGFloat(M_PI * 1.5)
        let endAngle: CGFloat = startAngle + CGFloat(M_PI * 2)
        
        let radius = CGFloat((CGFloat(self.frame.size.width) - CGFloat(self.strokeWidth)) / 2)
        
        let context = UIGraphicsGetCurrentContext()
        let center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
        
        CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextSetLineWidth(context, CGFloat(self.strokeWidth))
        CGContextSetLineCap(context, CGLineCap.Round)
        
        
        // Draw the arc around the circle
        CGContextAddArc(context, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat((endAngle - startAngle) * (self.percent / 1.0) + startAngle), 0)
        
        // Draw the arc
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
        
    }
    
    func cancelTouch(){
        
        let temp_percentage = self.percent
        
        self.durationOfCurrentTouch = 0.0
        self.percent = 0.0;
        
        if touchTimer != nil {
            touchTimer.invalidate()
            touchTimer = nil
        }
        
        if let touchDelegate = self.delegate{
            touchDelegate.didCancelTouch(self, atPercentage: temp_percentage)
        }
    }
    
    func setupTimer(){
        if touchTimer != nil {
            touchTimer.invalidate()
            touchTimer = nil
        }
        
        touchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: #selector(updateTouchView), userInfo: nil, repeats: true)
        
    }
    
    func endTimer(){
        if touchTimer != nil {
            touchTimer.invalidate()
            touchTimer = nil
        }
        
        if let touchDelegate = self.delegate {
            touchDelegate.didCompleteTouch(self)
        }
    }
    
    func updateTouchView() {
        self.durationOfCurrentTouch += 1.0/60.0
        
        self.percent = self.durationOfCurrentTouch / self.touchDuration
        
        if self.percent > 1.0 {
            self.percent = 1.0
            self.endTimer()
        }
    }
}
