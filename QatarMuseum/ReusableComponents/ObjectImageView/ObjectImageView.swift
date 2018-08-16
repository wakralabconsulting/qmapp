//
//  ObjectImageView.swift
//  QatarMuseums
//
//  Created by Developer on 17/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

protocol ObjectImageViewProtocol {
    func dismissImagePopUpView()
}

class ObjectImageView: UIView {
    @IBOutlet var imageViewPopup: UIView!
    @IBOutlet weak var objectImagePopUpInnerView: UIView!
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var objectImageViewDelegate : ObjectImageViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ObjectImageXib", owner: self, options: nil)
        addSubview(imageViewPopup)
        imageViewPopup.frame = self.bounds
        imageViewPopup.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpUI()
    }
    
    func setUpUI() {
        self.backgroundColor = UIColor.popupBackgroundWhite
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        imageViewPopup.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        imageViewPopup.addGestureRecognizer(tapGesture1)
        
        objectImageView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(zoomToScreenSize))
        objectImageView.addGestureRecognizer(tapGesture2)
    }
    
    func loadPopup(image : String) {
        objectImageView.image = UIImage(named: image)
    }
    
    @objc func zoomToScreenSize() {
        let heightOfSuperview = self.imageViewPopup.bounds.height
        imageViewHeight.constant = heightOfSuperview * 0.65
//        objectImageView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 60)
        objectImageView.isUserInteractionEnabled = false
    }
    
    @objc func dismissView() {
        objectImageViewDelegate?.dismissImagePopUpView()
    }
    
}

