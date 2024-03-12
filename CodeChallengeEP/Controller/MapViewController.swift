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
    
    var sites: SitesResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapContraints()
        fetchSites()
    }
    
    func setMapContraints() {
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
                self?.sites = fetchedSites
                DispatchQueue.main.async {
                    self?.addAnnotationsToMap()
                }
            case .failure(let error):
                print("Failed to fetch sites: \(error)")
            }
        }
    }
    
    private func addAnnotationsToMap() {
        
        if let unwrappedSites = sites?.sites {
            print("Found \(unwrappedSites.count) sites")
            for site in unwrappedSites {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: site.location.lat, longitude: site.location.lon)
                annotation.title = site.name
                annotation.subtitle = site.id
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
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        if let siteId = annotation.subtitle {
            let detailVC = SiteDetailViewController()
            detailVC.siteID = siteId
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


