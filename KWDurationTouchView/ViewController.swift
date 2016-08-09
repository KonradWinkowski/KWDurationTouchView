//
//  ViewController.swift
//  KWDurationTouchView
//
//  Created by Konrad Winkowski on 8/9/16.
//  Copyright © 2016 KonradWinkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KWDurationTouchViewDelegate {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var durationTouchView: KWDurationTouchView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.durationTouchView.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didCompleteTouch(sender: KWDurationTouchView) {
        self.progressLabel.text = "Complete!"
    }
    
    func didCancelTouch(sender: KWDurationTouchView, atPercentage: CGFloat) {
        self.progressLabel.text = "Canceled!"
    }
    
    func percentageOfProgress(sender: KWDurationTouchView, progress: CGFloat) {
        
        self.progressLabel.text = String(format: "%.2f",progress * 100) + " %"
    }
    
}

