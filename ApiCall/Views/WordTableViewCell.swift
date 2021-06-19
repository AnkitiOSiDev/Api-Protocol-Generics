//
//  WordTableViewCell.swift
//  ApiCall
//
//  Created by Ankit on 12/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {
   
    @IBOutlet weak var lblDefination: UILabel!
    @IBOutlet weak var lblExample: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var word : Word? {
        didSet {
            guard let word = word else { return  }
            lblExample.text = word.definition
            lblDefination.text = word.example
        }
    }
    
}

extension UITableViewCell {
    static var nibCell : UINib? {
        return UINib.init(nibName:Self.identifierCell, bundle: nil)
    }
    
    static var identifierCell : String {
        return String(describing: Self.self)
    }
}
