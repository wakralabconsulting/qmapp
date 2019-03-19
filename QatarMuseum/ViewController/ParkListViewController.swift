//
//  ParkListViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 19/03/19.
//  Copyright © 2019 Wakralab. All rights reserved.
//

import UIKit

class ParkListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, HeaderViewProtocol {
    
    
    
    
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var parkTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUI()
    }
    func setUI() {
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("PARKS_HEADER_LABEL", comment: "PARKS_HEADER_LABEL Label in the Exhibitions page").uppercased()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func registerCell() {
        self.parkTableView.register(UINib(nibName: "ParkListView", bundle: nil), forCellReuseIdentifier: "parkListCellId")
        self.parkTableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
        parkTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = parkTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
            
            cell.textLabel?.text = "The National Museum of Qatar Park houses playgrounds, the Desert Rose Cafe, several public artworks, a lagoon and two large kiosks with amenities including prayer rooms, washrooms and cafes."
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel!.font = UIFont.collectionFirstDescriptionFont
            return cell
        } else if ((indexPath.row == 1) || (indexPath.row == 2)) {
            let parkListCell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
            parkListCell.selectionStyle = .none
            return parkListCell
        } else {
            let parkListSecondCell = parkTableView.dequeueReusableCell(withIdentifier: "parkListCellId", for: indexPath) as! ParkListTableViewCell
            parkListSecondCell.selectionStyle = .none
            parkListSecondCell.setParkListValues()
            return parkListSecondCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath.row == 1) || (indexPath.row == 2)) {
            let heightValue = UIScreen.main.bounds.height/100
            return heightValue*27
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            let parksView =  self.storyboard?.instantiateViewController(withIdentifier: "parkViewId") as! ParksViewController
            parksView.parkPageNameString = ParkPageName.NMoQPark
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(parksView, animated: false, completion: nil)
        }
    }
    func headerCloseButtonPressed() {
        self.dismiss(animated: false, completion: nil)
    }
}
