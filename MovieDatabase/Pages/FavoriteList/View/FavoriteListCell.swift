//
//  FavoriteListCell.swift
//  MovieDB-Project
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func removeFavorite(row:Int)
}
class FavoriteListCell: UITableViewCell {

    @IBOutlet weak var posterImgView: UIImageView!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var genrelb: UILabel!
    @IBOutlet weak var releaseDateLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    
    var delegate : CellProtocol?
    var row : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func isClicked(_ sender: Any) {
        delegate?.removeFavorite(row: row!)
    }
}


