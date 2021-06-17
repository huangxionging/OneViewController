//
//  CMMyRowTableViewCell.swift
//  OneViewController
//
//  Created by 黄雄 on 2021/6/16.
//

import UIKit

class CMMyRowTableViewCell: UITableViewCell {

    @IBOutlet weak var myInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setCell(withRowModel rowModel: CMSwiftRowModel) {
        self.myInfoLabel.text = rowModel.routerURL
    }
}
