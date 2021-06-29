//
//  WeatherTableViewCell.swift
//  ApiCall
//
//  Created by Ankit on 27/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var lblconditionText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var objWeather: ForecastDay? {
        didSet {
             guard let objWeather = objWeather else { return  }
            lblDay.text = objWeather.weekDay
            lblconditionText.text = objWeather.day.condition.text
            iconWeather.image = WeatherCondition.iconImage(day: true, code: objWeather.day.condition.code)
        }
       
    }
}
