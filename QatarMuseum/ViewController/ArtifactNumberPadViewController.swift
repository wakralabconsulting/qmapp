//
//  ArtifactNumberPadViewController.swift
//  QatarMuseums
//
//  Created by Developer on 17/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ArtifactNumberPadViewController: UIViewController, HeaderViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var artifactHeader: CommonHeaderView!
    @IBOutlet weak var numberPadCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectInfoLabel: UILabel!
    @IBOutlet weak var artifactTextField: UITextField!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var qrScannerLabel: UILabel!

    let NUMBER_CELL_WIDTH: CGFloat = 100.0
    var artifactValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()        
        setupUI()
        registerNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNib() {
        let nib = UINib(nibName: "ArtifactNumberPadCell", bundle: nil)
        numberPadCollectionView?.register(nib, forCellWithReuseIdentifier: "artifactNumberPadCellId")
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        artifactHeader.headerViewDelegate = self
        artifactHeader.headerTitle.text = NSLocalizedString("ARTIFACT_NUMBERPAD_TITLE", comment: "ARTIFACT_NUMBERPAD_TITLE  in the Artifact Number Pad page")
        artifactHeader.headerTitle.font = UIFont.headerFont
        artifactHeader.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
        artifactHeader.headerBackButton.contentMode = .scaleAspectFill
        
        objectTitleLabel.text = NSLocalizedString("OBJECT_TITLE", comment: "OBJECT_TITLE  in the Artifact Number Pad page")
        objectInfoLabel.text = NSLocalizedString("OBJECT_INFO", comment: "OBJECT_INFO  in the Artifact Number Pad page")
        orLabel.text = NSLocalizedString("OR_LABEL", comment: "OR_LABEL  in the Artifact Number Pad page")
    }
    
    //MARK: collectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ArtifactNumberPadCell = numberPadCollectionView.dequeueReusableCell(withReuseIdentifier: "artifactNumberPadCellId", for: indexPath) as! ArtifactNumberPadCell
        cell.innerView.layer.cornerRadius = (NUMBER_CELL_WIDTH-10)/2
        if (indexPath.row == 11) {
            cell.imageView.image = UIImage(named: "back_mirrorX1")
            cell.innerView.backgroundColor = UIColor.viewMycultureBlue
        } else if (indexPath.row == 10) {
            cell.numLabel.text = "0"
        } else if (indexPath.row == 9) {
            cell.imageView.image = UIImage(named: "closeX1")
            cell.innerView.backgroundColor = UIColor.profilePink
        } else {
            cell.numLabel.text = String(indexPath.row + 1)
        }
        
        if (artifactValue == "") {
            if (indexPath.row == 11) {
                cell.innerView.alpha = 0.3
            } else if (indexPath.row == 9) {
                cell.innerView.alpha = 0.3
            }
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: NUMBER_CELL_WIDTH, height: NUMBER_CELL_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : ArtifactNumberPadCell = numberPadCollectionView.dequeueReusableCell(withReuseIdentifier: "artifactNumberPadCellId", for: indexPath) as! ArtifactNumberPadCell
        
        if (indexPath.row == 9) {
            artifactTextField.text = ""
            cell.innerView.alpha = 0.3
            disableButtons(collectionView: collectionView)
        } else if (indexPath.row == 11) {
            if artifactValue != "" {
               goToObjectDetail()
            }
        } else {
            enableButtons(collectionView: collectionView)
            if (indexPath.row == 10) {
                artifactTextField.text = artifactValue + "0"
            } else {
                artifactTextField.text = artifactValue + String(indexPath.row + 1)
            }
        }
        artifactValue = artifactTextField.text!
    }
    
    func disableButtons(collectionView: UICollectionView) {
        let closeButtonView = collectionView.cellForItem(at: IndexPath(item: 9,
                                                                   section: 0)) as! ArtifactNumberPadCell
        
        closeButtonView.innerView.alpha = 0.3
        let nextButtonView = collectionView.cellForItem(at: IndexPath(item: 11,
                                                                   section: 0)) as! ArtifactNumberPadCell
        nextButtonView.innerView.alpha = 0.3
    }
    
    func enableButtons(collectionView: UICollectionView) {
        let closeButtonView = collectionView.cellForItem(at: IndexPath(item: 9,
                                                                       section: 0)) as! ArtifactNumberPadCell
        
        closeButtonView.innerView.alpha = 1.0
        let nextButtonView = collectionView.cellForItem(at: IndexPath(item: 11,
                                                                      section: 0)) as! ArtifactNumberPadCell
        nextButtonView.innerView.alpha = 1.0
    }
    
    func goToObjectDetail() {
        let objectDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "objectDetailId") as! ObjectDetailViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(objectDetailView, animated: false, completion: nil)
    }
    
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}

