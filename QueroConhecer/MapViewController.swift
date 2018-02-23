//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Tiago Xavier da Cunha Almeida on 27/11/17.
//  Copyright © 2017 tiagoAlmeida. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelEndereco: UILabel!
    
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        searchBar.isHidden = true
        viewInfo.isHidden = true
        
        if places.count == 1 {
            title = places[0].name
        } else {
            title = "Meus Lugares"
        }
        
        for place in places{
            addToMap(place: place)
        }
        showPlaces()
    }
    
    func addToMap(place: Place){
        let annotation = PlaceAnnotation(coordinate: place.coordinate, type: .place)
        annotation.title = place.name
        annotation.address = place.address
        mapView.addAnnotation(annotation)
        
    }
    
    func showPlaces(){
        mapView.showAnnotations(mapView.annotations, animated:true)
    }

    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func showRoute(_ sender: UIButton) {
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation){
            return nil
        }
        
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.tintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        annotationView?.glyphImage = type == .place ? #imageLiteral(resourceName: "placeGlyph") : #imageLiteral(resourceName: "poiGlyph")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        
        return annotationView
        
        
    }
}
