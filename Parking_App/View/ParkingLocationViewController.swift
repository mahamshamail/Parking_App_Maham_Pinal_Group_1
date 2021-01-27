// Group 1
// 101328732 - Saiyeda Maham Shamail
// 101334143 - Pinalben Patel
// Maham's code

import UIKit
import MapKit

struct Locations{
    var name : String
    var coordinates : CLLocationCoordinate2D
}

class ParkingLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var  latitude : Double = 0.0
    var  longitude : Double = 0.0
    var streetAddress : String = ""
    var myCurrentLatitude : Double = 0.0
    var myCurrentLongitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView?.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        print("LAT \(self.latitude)")
        print("LONG \(self.longitude)")
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
      
        
       
    }
    


//MARK: Displaying the current location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myLocation : CLLocationCoordinate2D = manager.location?.coordinate
        else{ return }
        
        
        print("\(myLocation.latitude)")
        print("\(myLocation.longitude)")
        
        self.myCurrentLatitude = myLocation.latitude
        self.myCurrentLongitude = myLocation.longitude
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        self.mapView?.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        annotation.title = "My current location"
        self.mapView?.addAnnotation(annotation)
        
        let locationArray = [
            Locations(name: "Current Location", coordinates: CLLocationCoordinate2D(latitude: self.myCurrentLatitude, longitude: self.myCurrentLongitude)),
            Locations(name: self.streetAddress, coordinates: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        ]
        self.displayMarkers(locations: locationArray)
        self.showRouteOnMap(pickupCoordinate: locationArray[0].coordinates, destinationCoordinate: locationArray[1].coordinates)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    


//MARK: Display the location with markers

    
    func displayMarkers(locations : [Locations]){
        for loc in locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc.coordinates
            annotation.title = loc.name
            self.mapView?.addAnnotation(annotation)
            
        }
    }
    
    func showRouteOnMap(pickupCoordinate : CLLocationCoordinate2D, destinationCoordinate : CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { response, error in
            guard let response = response else {return}
            if let route = response.routes.first{
                self.mapView?.addOverlay(route.polyline)
                self.mapView?.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80, left: 20, bottom: 100, right: 20), animated: true)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }

}
