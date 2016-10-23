//
//  ExpandableTableViewCell.swift
//  Yelp
//
//  Created by Chihiro Saito on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {

    
    weak var cellSelectedDelegate: CellSelectedDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    var sectionNumber = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellSelectedDelegate?.expandSection(self, newValue: selected)
    }

}

protocol CellSelectedDelegate: class {
    func expandSection(_ cell: ExpandableTableViewCell, newValue:Bool)
}
