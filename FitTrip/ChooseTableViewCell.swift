//
//  ChooseTableViewCell.swift
//  WeatherHack2
//
//  Created by zkmb on 2015-01-18.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

import UIKit

class ChooseTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
