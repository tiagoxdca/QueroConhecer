//
//  Place.swift
//  QueroConhecer
//
//  Created by Tiago Xavier da Cunha Almeida on 22/12/17.
//  Copyright © 2017 tiagoAlmeida. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAdress(placemark: CLPlacemark) -> String{
        var adress = ""
        
        if let street = placemark.thoroughfare {
            adress += street  // Rua
        }
        
        if let number = placemark.subThoroughfare {
            adress += " \(number)"  //Number
        }
        
        if let subLocality = placemark.subLocality {
            adress += ", \(subLocality)"  //bairro
        }
        
        if let city = placemark.locality {
            adress += "\n \(city)" //cidade
        }
        
        if let state = placemark.administrativeArea {
            adress += " - \(state)"  // estado
        }
        if let postalCode = placemark.postalCode {
            adress += "\nCodigo Postal:  \(postalCode)"
        }
        if let country = placemark.country {
            adress += "\nPaís: \(country)"
        }
        
        return adress
    }
    
}

extension Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
