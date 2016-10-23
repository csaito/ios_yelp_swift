//
//  DealTableViewCell.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var onOffSwitch: UISwitch!
    
    weak var switchDelegate: DealSwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

protocol DealSwitchDelegate: class {
    func switchDidToggle(_ cell: DealTableViewCell, newValue:Bool)
}

