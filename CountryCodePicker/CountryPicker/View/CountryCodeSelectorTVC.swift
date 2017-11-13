//
//  CountryCodeSelectorTVC.swift
//  CountryCodePicker
//
//  Created by Sauvik Dolui on 19/04/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit

class CountryCodeSelectorTVC: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configWithCountry(_ country: Country) {
        flagImageView.image = country.getFlagImage()
        countryCodeNameLabel.text = "(\(country.dialCode)) \(country.name)"
    }
    

}
