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
    
    func countryWith(dialcode: String) -> Country? {
        return self.countries.filter { $0.dialCode == dialcode }.first
    }
    func countryWith(countryCode: String) -> Country? {
        return self.countries.filter { $0.code == countryCode.uppercased() }.first
    }
    func getCountriesWithSearchText(_ searchText: String) -> [Country]{
        return self.countries.filter { $0.dialCode.hasSubString(string: searchText) ||
                                $0.name.hasSubString(string: searchText)
        }
    }
    
}


