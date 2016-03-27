//
//  HomeTableViewCell.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeTweetProfileImageView: RoundedRectangleImageView!
    @IBOutlet weak var homeTweetNameLabel: UILabel!
    @IBOutlet weak var homeTweetScreenNameLabel: UILabel!
    @IBOutlet weak var homeTweetTextLabel: UILabel!
    @IBOutlet weak var homeTweetRetweetButton: UIButton!
    @IBOutlet weak var homeTweetRetweetCountLabel: UILabel!
    @IBOutlet weak var homeTweetLikeButton: UIButton!
    @IBOutlet weak var homeTweetLikeCountLabel: UILabel!
    @IBOutlet weak var homeTweetDateLabel: UILabel!
    
    var homeTweetAccountVerified: Bool = false
    var homeTweetID: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
