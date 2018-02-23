//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Tiago Xavier da Cunha Almeida on 27/11/17.
//  Copyright © 2017 tiagoAlmeida. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class {
    func addPlace(place: Place)
}

class PlaceFinderViewController: UIViewController {
    
    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
        
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.latitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                self.load(show: false)
                
                if error == nil {
                    if !self.savePlace(with: placemarks?.first) {
                        self.showMessage(type: .error("Não foi encontrado nenhum local com o mesmo nome."))
                    }
                } else {
                    self.showMessage(type: .error("Erro desconhecido."))
                }
                
                
            })
        }
    }
    
    
    @IBAction func findCity(_ sender: UIButton) {
        
        tfCity.resignFirstResponder()
        let city = tfCity.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(city) { (placemarks, error) in
            self.load(show: false)
            
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    self.showMessage(type: .error("Não foi encontrado nenhum local com o mesmo nome."))
                }
            } else {
                self.showMessage(type: .error("Erro desconhecido."))
            }
            
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {return false}
        let name = placemark.name ?? placemark.country ?? "Unknown"
        let address = Place.getFormattedAdress(placemark: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        

        let region = MKCoordinateRegionMakeWithDistance(coordinate, 3500, 3500)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    func showMessage(type: PlaceFinderMessageType) {
        
        let title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
        case .confirmation(let name):
            title = "Local encontrado"
            message = "Deseja adicionar \(name)?"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Erro"
            message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmation = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.delegate?.addPlace(place: self.place)
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(confirmation)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func load(show: Bool){
        viewLoading.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
   
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
