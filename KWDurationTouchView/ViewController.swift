//
//  ViewController.swift
//  KWDurationTouchView
//
//  Created by Konrad Winkowski on 8/9/16.
//  Copyright © 2016 KonradWinkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KWDurationTouchViewDelegate {
    
    @IBOutlet var durationViews: [KWDurationTouchView]!
    
    
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in durationViews {
            view.delegate = self;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didCompleteTouch(_ sender: KWDurationTouchView) {
        self.progressLabel.text = "Complete!"
    }
    
    func didCancelTouch(_ sender: KWDurationTouchView, atPercentage: CGFloat) {
        self.progressLabel.text = "Canceled!"
    }
    
    func percentageOfProgress(_ sender: KWDurationTouchView, progress: CGFloat) {
        
        self.progressLabel.text = String(format: "%.2f",progress * 100) + " %"
    }
    
}

