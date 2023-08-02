//
//  TableViewCell.swift
//  somePlaces
//
//  Created by Вадим on 29.07.2023.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
