//
//  DrinkCell.swift
//  CocktailApp
//
//  Created by Денис Андриевский on 09.09.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

final class DrinkCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
