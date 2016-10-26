//
//  PlaceWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/20/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit

class PlaceWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityAddressDescription: UILabel!
    @IBOutlet weak var cityWeatherTemp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
