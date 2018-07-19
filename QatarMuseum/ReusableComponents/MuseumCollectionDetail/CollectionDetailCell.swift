//
//  CollectionDetailCell.swift
//  QatarMuseums
//
//  Created by Exalture on 18/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class CollectionDetailCell: UITableViewCell {

    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstDescription: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var secondSubTitle: UILabel!
    @IBOutlet weak var secondDescription: UILabel!
    @IBOutlet weak var thirdDescription: UILabel!
    @IBOutlet weak var fourthDescription: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setCollectionCellValues(cellValues: NSDictionary,imageName: String) {
        firstTitle.text = "CERAMIC COLLECTION"
        firstDescription.text = "As well as being objects of great age and beauty, the ceramics in the museum were also meant to be used. \n\n From humble kitchen wares to elaborate tile panels, ceramics were a vital part of everyday life in the Islamic world. \n\n They exemplify the externam influences and internal creativity that inspired this flourishing of ceramic design over 2 centuries. "
        secondTitle.text = "LUSTERWARE APOTHECARY JAR"
        secondSubTitle.text = "Mamluk, Syria, 14th century"
        secondDescription.text = "This jar was probably produced for the celebrated Damascene hospital of Nural-Din Mahmud ibnZangi."
        thirdDescription.text = "The inscription around the neck says it was made for the hospital 'of Nuri' and the 'fleur de lis' design was the motif of Nur al-Din."
        fourthDescription.text = "The other inscriptions read 'water lily', suggesting what was contained within the jar, undoubtedly a pharmaceutical compound or preparation of the plant."
        firstImageView.image = UIImage(named: imageName)
        secondImageView.image = UIImage(named: imageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
