//
//  InStockTableViewCell.swift
//  uTrack
//
//  Created by Matthew Jagiela on 5/3/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class InStockTableViewCell: UITableViewCell {
    @IBOutlet var storeLogo: UIImageView!
    @IBOutlet var storeName: UILabel!
    @IBOutlet var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
