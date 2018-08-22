//
//  CollectionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 31/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class CollectionDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol {
    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var collectionListArray: NSArray!
    var collectionImageArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        getCollectionDetailDataFromJson()
        registerCell()
        setUI()
        
    }
    func setUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        collectionImageArray = ["mia_park","park_cafe","family_play"];
        headerView.headerViewDelegate = self
        headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
        headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom:13, right: 18)
       
    }
    //MARK: Service call
    func getCollectionDetailDataFromJson(){
        let url = Bundle.main.url(forResource: "CollectionDetailJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            collectionListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerCell() {
        self.collectionTableView.register(UINib(nibName: "CollectionDetailView", bundle: nil), forCellReuseIdentifier: "collectionCellId")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionCellId", for: indexPath) as! CollectionDetailCell
//        if(indexPath.row == collectionListArray.count-1) {
//            collectionCell.favouriteHeight.constant = 130
//            collectionCell.favouriteView.isHidden = false
//            collectionCell.shareView.isHidden = false
//            collectionCell.favouriteButton.isHidden = false
//            collectionCell.shareButton.isHidden = false
//        } else {
            collectionCell.favouriteHeight.constant = 0
            collectionCell.favouriteView.isHidden = true
            collectionCell.shareView.isHidden = true
            collectionCell.favouriteButton.isHidden = true
            collectionCell.shareButton.isHidden = true
//        }
        collectionCell.favouriteButtonAction = {
            () in
            
        }
        collectionCell.shareButtonAction = {
            () in
            
        }
        let collectionDataDict = collectionListArray.object(at: indexPath.row) as! NSDictionary
        
        collectionCell.setCollectionCellValues(cellValues: collectionDataDict, imageName: collectionImageArray.object(at: indexPath.row) as! String, currentRow: indexPath.row)
        loadingView.stopLoading()
        loadingView.isHidden = true
        return collectionCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
