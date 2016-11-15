//
//  KWDurationTouchView.swift
//  KWDurationTouchView
//
//  Created by Konrad Winkowski on 8/9/16.
//  Copyright © 2016 KonradWinkowski. All rights reserved.
//

import UIKit

protocol KWDurationTouchViewDelegate : class {
    func didCompleteTouch(_ sender: KWDurationTouchView)
    func didCancelTouch(_ sender: KWDurationTouchView, atPercentage: CGFloat)
    func percentageOfProgress(_ sender: KWDurationTouchView, progress: CGFloat)
}

class KWDurationTouchView: UIView {
    
    var touchTimer: Timer!
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
    @IBInspectable var strokeColor : UIColor = UIColor.red
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setupTimer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelTouch()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelTouch()
    }
    
    override func draw(_ rect: CGRect) {
        
        let startAngle: CGFloat = CGFloat(M_PI * 1.5)
        let endAngle: CGFloat = startAngle + CGFloat(M_PI * 2)
        
        let radius = CGFloat((CGFloat(self.frame.size.width) - CGFloat(self.strokeWidth)) / 2)
        
        let context = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        context?.setStrokeColor(self.strokeColor.cgColor)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.setLineWidth(CGFloat(self.strokeWidth))
        context?.setLineCap(CGLineCap.round)
        
        
        // Draw the arc around the circle
        context?.addArc(center: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat((endAngle - startAngle) * (self.percent / 1.0) + startAngle), clockwise: false)
        
        // Draw the arc
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
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
        
        touchTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(updateTouchView), userInfo: nil, repeats: true)
        
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
