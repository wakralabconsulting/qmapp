//
//  CulturePassCardViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class CulturePassCardViewController: UIViewController {
    var membershipNumber : String? = nil
    @IBOutlet weak var membershipLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI ()
        
    }
    func setUI() {
        membershipLabel.text = "Membership number: " + membershipNumber!
        membershipLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        membershipLabel.font = UIFont.homeTitleFont
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    

}
