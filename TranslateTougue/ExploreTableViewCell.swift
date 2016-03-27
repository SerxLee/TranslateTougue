//
//  ExploreTableViewCell.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var exploreTweetProfileImageView: RoundedRectangleImageView!
    @IBOutlet weak var exploreTweetNameLabel: UILabel!
    @IBOutlet weak var exploreTweetScreenNameLabel: UILabel!
    @IBOutlet weak var exploreTweetDateLabel: UILabel!
    @IBOutlet weak var exploreTweetTextLabel: UILabel!
    @IBOutlet weak var exploreTweetRetweetButton: UIButton!
    @IBOutlet weak var exploreTweetRetweetLabel: UILabel!
    @IBOutlet weak var exploreTweetLikeButton: UIButton!
    @IBOutlet weak var exploreTweetLikeLabel: UILabel!
    
    var exploreTweetAccountVerified: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}