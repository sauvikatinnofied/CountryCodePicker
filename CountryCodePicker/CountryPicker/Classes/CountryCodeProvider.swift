//
//  CountryCodeProvider.swift
//  CountryCodePicker
//
//  Created by Sauvik Dolui on 20/04/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit


/*
 {
 "name": "Albania",
 "dial_code": "+355",
 "code": "AL"
 }
 */
public struct Country {
    let name: String
    let dialCode: String
    let code: String
}

public extension Country {
    init?(dictionary: [String : String]) {
        guard let name = dictionary["name"],
        let dialCode = dictionary["dial_code"],
        let code = dictionary["code"]  else {
            debugPrint("Invalid Country Dictionary")
            return nil
        }
        self.init(name: name, dialCode: dialCode, code: code)
    }
    func getFlagImage() -> UIImage? {
        return UIImage(named: code,
                       in: Bundle(path: CountryProvider.shared.resourcePath),
                       compatibleWith: nil)
    }
}

public struct CountryGroup {
    let letter: String
    let countries: [Country]
}

public class CountryProvider {
    static let shared = CountryProvider()
    
    lazy var resourcePath: String = {
        guard let resourcePath = Bundle.main.path(forResource: "CountryPicker", ofType: "bundle") else {
            fatalError("CountryPicker.bundle NOT FOUND, Can not load Countries ")
        }
        return resourcePath
    }()
    
    lazy var countries: [Country] =  {
        
        let bundle = Bundle(path: self.resourcePath)
        
        guard let countryJSONFilePath = bundle?.path(forResource: "CountryList", ofType: "json"),
            let url = URL(string: "file://" + countryJSONFilePath) else {
            fatalError("CountryList.json file read error")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let countryDicArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: String]]
            return countryDicArray.flatMap {Country.init(dictionary: $0)}
        } catch {
            print(error)
        }
        return [Country]()
    }()
    
    lazy var groupedCountries: [CountryGroup] =  {
        return self.getLetterWiseGroupedCountries(searchText: nil)
    }()
    
    func countryWith(dialcode: String) -> Country? {
        return self.countries.filter { $0.dialCode == dialcode }.first
    }
    func countryWith(countryCode: String) -> Country? {
        return self.countries.filter { $0.code == countryCode.uppercased() }.first
    }
    func getCountriesWithSearchText(_ searchText: String) -> [Country]{
        return self.countries.filter {
            $0.dialCode.hasSubString(string: searchText) ||
                                $0.name.hasSubString(string: searchText)
        }
    }
    
    func getLetterWiseGroupedCountries(searchText: String?) -> [CountryGroup] {
        
        guard let searchText = searchText else {
            // No search text found
            return getCountriesGroupedByLetter(countries: self.countries)
        }
        let filteredCountries = getCountriesWithSearchText(searchText)
        return getCountriesGroupedByLetter(countries: filteredCountries)
    }
    private func getCountriesGroupedByLetter(countries: [Country]) -> [CountryGroup] {
        
        // Initial Dictionary
        var letterGroupedCountries = [CountryGroup]()
        
        // Proceesing code goes here
        let allCountryInitialLetters = countries.flatMap{ $0.name }.flatMap{ $0.uppercased().characters.first }
        let letters = allCountryInitialLetters.flatMap{ String(describing: $0) }
        let distinctLetters = Array(Set(letters)).sorted()
        for letter in distinctLetters {
            var matchedCountries = countries.filter {
                 return $0.name.hasPrefix(letter)
            }
            matchedCountries = matchedCountries.sorted {$0.name < $1.name }
            letterGroupedCountries.append(CountryGroup(letter: letter, countries: matchedCountries))
        }
        return letterGroupedCountries
    }
    
}


