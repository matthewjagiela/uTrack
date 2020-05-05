//
//  TrackedItemCollectionViewCell.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/18/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class TrackedItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var deleteCell: UIButton!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemName: UILabel!
    var editingEnabled = false
    
}
