//
//  LoadingView.swift
//  QatarMuseum
//
//  Created by Exalture on 07/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var loadingView: UIView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noDataView: UIView!
    var isNoDataDisplayed : Bool = false
    var noDataFontSize =  CGFloat()
    override func awakeFromNib()
    {
        loadView()
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("LoadingXib", owner: self, options: nil)
        addSubview(loadingView)
        loadingView.frame = self.bounds
       self.backgroundColor = UIColor.loadingViewGray
       // loadingView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.font = UIFont.closeButtonFont
    }
    fileprivate func loadView()
    {
        if loadingView == nil
        {
            loadingView = Bundle.main.loadNibNamed("LoadingXib", owner: self, options: nil)![0] as! UIView
            loadingView.frame = self.bounds
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = UIColor.loadingViewGray
            self.addSubview(loadingView)
            let constrants = wk_getLayouts()
            self.addConstraints(constrants.0)
            self.addConstraints(constrants.1)
        }
        //self.userInteractionEnabled = false
        
    }
    fileprivate func wk_getLayouts()->(Array<NSLayoutConstraint>,Array<NSLayoutConstraint>)
    {
        let hConstaints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view" : loadingView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view" : loadingView])
        return (hConstaints,vConstraints)
    }
    func showLoading()
    {
        // self.isHidden = false
        self.noDataLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        // self.isHidden = false
        
    }
    
    func stopLoading()
    {
        self.isNoDataDisplayed = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        
    }
    
    func showNoDataView(){
        self.isNoDataDisplayed = true
        //self.isHidden = false
        
       
        let noDataText = NSLocalizedString("NO_RESULT_MESSAGE", comment: "No result message")
        self.noDataLabel.text = noDataText
        self.noDataView.isHidden = false
        self.noDataView.backgroundColor = UIColor.noDataViewGray
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.noDataLabel.isHidden = false
    }
    func hideNoDataView(){
        self.isNoDataDisplayed = false
        //self.isHidden = true
        self.noDataView.isHidden = true
        //self.activityIndicatorControl.stopAnimating()
        self.noDataLabel.isHidden = true
    }


}
