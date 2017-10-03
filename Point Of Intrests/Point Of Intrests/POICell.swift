//
//  POICell.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/30/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import UIKit

class POICell: UITableViewCell {
    @IBOutlet weak var contactNumberLabel: UILabel!

    @IBOutlet weak var poiImageView: UIImageView!

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
