//
//  MapViewController.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/9/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    var sitesList: [SiteDomain]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapContraints()
        validateDataBase()
        
    }
    
    private func validateDataBase(){
        if DatabaseManager.isSitesTableEmpty() {
            self.sitesList = DatabaseManager.getAllSites()
            DispatchQueue.main.async {
                self.addAnnotationsToMap()
            }
        }else {
            fetchSites()
        }
    }
    
    private func setMapContraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo : self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo : self.view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo : self.view.trailingAnchor).isActive = true
    }
    
    private func fetchSites() {
        guard let sitesURL = URL(string: "https://sammycalle.github.io/mockFileEP/sites.json") else { return }
        
        NetworkManager.shared.fetchData(from: sitesURL) { [weak self] (result: Result<SitesResponse, Error>) in
            switch result {
            case .success(let fetchedSites):
                let siteEntity = EntityMappers.mapSites(sitesResponse: fetchedSites)
                DatabaseManager.saveSitesToDatabase(sites: siteEntity)
                self?.validateDataBase()
            case .failure(let error):
                print("Failed to fetch sites: \(error)")
            }
        }
    }

private func addAnnotationsToMap() {
    
    if let unwrappedSites = sitesList {
        for site in unwrappedSites {
            let annotation = SiteAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: site.lat, longitude: site.lon)
            annotation.title = site.name
            annotation.subtitle = site.details
            annotation.siteID = site.siteID
            mapView.addAnnotation(annotation)
        }
    } else {
        print("No sites data available")
    }
}


func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else {
        return nil
    }
    
    let identifier = "SiteAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
        annotationView?.annotation = annotation
    }
    
    return annotationView
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? SiteAnnotation else { return }
    
    if let siteId = annotation.siteID {
        let detailVC = SiteDetailViewController()
        detailVC.siteID = siteId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
}


