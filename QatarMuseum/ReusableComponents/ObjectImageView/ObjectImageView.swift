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

class ObjectImageView: UIView, UIScrollViewDelegate  {
    @IBOutlet var imageViewPopup: UIView!
    @IBOutlet weak var objectImagePopUpInnerView: UIView!
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        self.scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        imageViewPopup.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        imageViewPopup.addGestureRecognizer(tapGesture1)
        
        objectImageView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(zoomToScreenSize))
        objectImageView.addGestureRecognizer(tapGesture2)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return objectImageView
    }
    
    func loadPopup(image : String) {
        objectImageView.image = UIImage(named: image)
    }
    
    @objc func zoomToScreenSize() {
        let heightOfSuperview = self.imageViewPopup.bounds.height
        imageViewHeight.constant = heightOfSuperview * 0.65
        objectImageView.isUserInteractionEnabled = false
    }
    
    @objc func dismissView() {
        objectImageViewDelegate?.dismissImagePopUpView()
    }
    
}

