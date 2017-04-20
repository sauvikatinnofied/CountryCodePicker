//
//  CountryCodeSelectorVC.swift
//  CountryCodePicker
//
//  Created by Sauvik Dolui on 19/04/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit

class CountryCodeSelectorVC: UIViewController {

    var currentCountryCode: String? = "IN"
    var selectedCountryCode: String? = "US"
    
    // Filtration Helpers
    var searchText = ""
    var isFiltrationGoingOn = false
    var countrySearchResult = [CountryGroup]()
    
    
    // MARK: IBOutlets
    @IBOutlet weak var countryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - TABLE VIEW DATA SOURCE
extension CountryCodeSelectorVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // On going searching
        if isFiltrationGoingOn {
            return countrySearchResult.count
        }
        
        // No Searching
        var sections = CountryProvider.shared.groupedCountries.count
        if let _ = self.currentCountryCode { sections += 1 }
        if let _ = self.selectedCountryCode { sections += 1 }
        return sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if isFiltrationGoingOn {
            return countrySearchResult[section].countries.count
        }

        switch section {
        case 0:
            if let _ = self.selectedCountryCode { return 1 } else { return 0 }
        case 1:
            if let _ = self.currentCountryCode { return 1 } else { return 0 }
        default:
            var letterCountries = CountryProvider.shared.groupedCountries
            return letterCountries[section - 2].countries.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeSelectorTVC", for: indexPath)as! CountryCodeSelectorTVC

        //Filtration Handling
        if isFiltrationGoingOn {
            let countriesForSection = countrySearchResult[indexPath.section].countries
            cell.configWithCountry(countriesForSection[indexPath.row])
            return cell
        }
        
        // Normal Seleciton
        switch indexPath.section {
        case 0:
            // Current selection
            if let selectedCountryCode = self.selectedCountryCode,
            let selectedCountry = CountryProvider.shared.countryWith(countryCode: selectedCountryCode) {
                cell.configWithCountry(selectedCountry)
            } else {
                
            }
        case 1:
            // Current location
            if let countryCode = self.currentCountryCode,
                let country = CountryProvider.shared.countryWith(countryCode: countryCode) {
                cell.configWithCountry(country)
            } else {
                
            }
        default:
            // All Countries
            let allGroupedCountries = CountryProvider.shared.groupedCountries[indexPath.section - 2].countries
            cell.configWithCountry(allGroupedCountries[indexPath.row])
        }
        // Cell configuration code
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 59.0)
        let view = UIView(frame:headerFrame)
        
        // Adding the label
        let headerLabel = UILabel.autolayoutView()
        headerLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 12.0)
        headerLabel.textAlignment = .natural
        headerLabel.textColor = UIColor(colorLiteralRed: 64.0/255.0, green: 69.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        view.addSubview(headerLabel)
        
        headerLabel._setAttribute(attribute: .leading, padding: 17.0)
        headerLabel._setAttribute(attribute: .trailing, padding: 17.0)
        headerLabel._setHeight(height: 13.0)
        view.addConstraint(
            NSLayoutConstraint(item: headerLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.15, constant: 0.0)
        )
        
        var headerText = ""
        if isFiltrationGoingOn {
            headerText =  self.countrySearchResult[section].letter
        } else {
            switch section {
            case 0:
                headerText = "Current Selection"
            case 1:
                headerText = "Current Location"
            default:
                headerText = CountryProvider.shared.groupedCountries[section - 2].letter
            }
        }

        headerLabel.text =  headerText
        view.backgroundColor = .groupTableViewBackground
        return view
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49.0
    }
}
// MARK: - TABLE VIEW DELEGATES
extension CountryCodeSelectorVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Write down code here
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Write down code here
    }
}

// MARK: - SEARCH TEXT FIELD DELEGATES
extension CountryCodeSelectorVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        print(searchText)
        isFiltrationGoingOn = searchText.characters.count > 0
        self.searchText = searchText
        self.countrySearchResult = CountryProvider.shared.getLetterWiseGroupedCountries(searchText: self.searchText)
        self.countryTableView.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

