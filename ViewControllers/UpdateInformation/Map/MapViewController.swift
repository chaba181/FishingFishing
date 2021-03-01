//
//  MapViewController.swift
//  Fishing
//
//  Created by mac on 25.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var fish: FishingInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(fish?.address ?? "") { (placemarks, error) in
            
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.fish?.title
            annotation.subtitle = "место для рыбалки"
            
            guard let location = placemark?.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationIdentifier = "fishingAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        guard let data = fish?.photo else { return nil }
        guard let loadedImage = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] else {return nil}
        let images = loadedImage.compactMap({ UIImage(data: $0) })
        rightImage.image = images.first
        annotationView?.rightCalloutAccessoryView = rightImage
        
        return annotationView
    }
}
