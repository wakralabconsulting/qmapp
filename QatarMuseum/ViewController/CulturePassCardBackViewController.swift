//
//  CulturePassCardBackViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 04/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class CulturePassCardBackViewController: UIViewController {

    @IBOutlet weak var tapToFlipButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
//        var label = UILabel(frame: CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
//        label.center = CGPointMake(160, 284)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = "I'am a test label"
//        self.view.addSubview(label)
        nameLabel.isHidden = true
       nameLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    func setUI() {
        tapToFlipButton.layer.cornerRadius = 25
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapTapToFlip(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.9
        transition.type = "flip"
        transition.subtype = kCATransitionFromRight
      //  transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapClose(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        
    }
    
    

}
