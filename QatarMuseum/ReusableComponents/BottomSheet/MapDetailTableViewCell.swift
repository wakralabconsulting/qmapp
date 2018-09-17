//
//  MapDetailTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 10/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class MapDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailSecondLabel: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageDetailLabel: UILabel!
    @IBOutlet weak var shareBtnViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    var favBtnTapAction : (()->())?
    var shareBtnTapAction : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    func setupCellUI() {
        titleLabel.textAlignment = .left
        descriptionLabel.textAlignment = .left
        detailSecondLabel.textAlignment = .left
        imageDetailLabel.textAlignment = .left
        
        titleLabel.font = UIFont.diningHeaderFont
        descriptionLabel.font = UIFont.englishTitleFont
        detailSecondLabel.font = UIFont.englishTitleFont
        imageDetailLabel.font = UIFont.sideMenuLabelFont
    }
    
    func setObjectDetail() {
        titleLabel.text = "Albarello"
        descriptionLabel?.text = "This example is a rare example of the Mamluk production of albarelli in Damascus, primarily produced for the European market. The albarello (pl. albarelli) was used as a medicinal jar for holding apothecary ointments and dried herbal drugs. Its elongated shape helps us to recognize the nature and function of this typical object. The Italain word albarello has a quite controversial etymology: sometimes said to be derivng from the Latin albaris, meaning \"in wood\" or \"white\", sometimes from the Arabic al-barmil, which designates a barrel. Albarelli have been produced in the Middle East and Central Asia since the 11th-century and later on in 15th-century Spain and Italy, although they are believed to have been first produced in Syria before making their way to Europe through Spain and Italy. Indeed, many European paintings and archives in France, Italy and Spain refer to vessels produced or imported from Syria."
        detailSecondLabel.text = "This particular albarello might have specifically commissioned for an apothecary in Florence as the floral scrolls, lotus blossoms and rosettes of the overall decoration bears a frieze with three shields cartouches enclosing a fleur-de-lys (lily) coat of arm on a blue background. The fleur-de-lys is one of the oldest heraldic symbols in the world and one of the four most popular patterns because of its value of purity and power in the biblical tradition since the Byzantines. This heraldic sign was widely used in medieval Spain and Italy and here represents the city if Florence. The fleur-de-lys and blazons in general were also featured on Ayyubid and Mamluk potteries, coins or buildings as part of a decorated repertoire that entered with the Crusaders."
        imageDetailLabel.text = "Saint Jerome in His Study \nDomenico Ghirlandaio (1449-1494) \nChurch of Ognissanti, Florence, 1480"
        centerImageView.image = UIImage(named: "lusterwar_apothecarry_jar_full")
        shareBtnViewHeight.constant = 0
        bottomPadding.constant = 0
    }
    
    func setObjectHistoryDetail() {
        titleLabel.text = "Object History"
        descriptionLabel?.text = "According to the Medici Archival records in Florence, this vas is possibly one of the three 'alberegli domaschini' owned by Piero di Cosimo de Medici (1416-59), the de-facto ruler of Florence from 1464-69."
        detailSecondLabel.text = "Like his father before him, Piero continued the family's tradition of artistic patronage, extending the collection beyond Italian Renaissance works to include Dutch and Flemish paintings, as well as rare books. This particular vase most probably remained in royal or aristocratic families for generations, before being discovered - along with four other similar vases - in a private Italian collection in 2005. Before this re-discovery, only one other albarello of its kind was recorded in the Musee des arts Decoratifs, Paris."
        imageDetailLabel.text = "Portrait of Piero di Cosimo de' Medici \nBronzino (Agnolo di Cosimo) (1503-1572) \nFlorence, 1550-1570 \nNational Gallery, London"
        centerImageView.image = UIImage(named: "science_tour")
        shareBtnViewHeight.constant = 0
        bottomPadding.constant = 0
    }
    
    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.favoriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.favoriteButton.transform = CGAffineTransform.identity
                            })
                            self.favBtnTapAction?()
        })
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.shareButton.transform = CGAffineTransform.identity
                            })
                            self.shareBtnTapAction?()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
