//
//  CharacterTableViewCell.swift
//  MarvelApp
//
//  Created by Alexander Rivero on 28/11/20.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
