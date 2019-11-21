//
//  DataTableViewCell.swift
//  NewAssigment
//
//  Created by akash.jaiswal on 21/11/19.
//  Copyright © 2019 Assigment.int. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    // Cell properties
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCreatedDate:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Display data on cell
    func showData(data:ListData){
        lblTitle.text = data.title
        lblCreatedDate.text = data.createdDate
    }
}
