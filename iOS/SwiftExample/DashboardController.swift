
import UIKit
import CoreLocation

class DashboardController: UIViewController,  CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet var myLong: UILabel!
    @IBOutlet var myLat: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CoreLocation Delegate Methods
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        var locationArray = locations as NSArray
//        var currentLocation = locationArray.lastObject as CLLocation
//        var locValue = currentLocation.coordinate
//        
//        var myLatString = NSString(format:"%f",locValue.latitude) as String
//        self.myLat.text = myLatString
//        
//        var myLongString = NSString(format:"%f",locValue.longitude) as String
//        self.myLong.text = myLongString
//        
//        //var locationArray = locations as NSArray
//        //var locationObj = locationArray.lastObject as CLLocation
//        //var coord = locationObj.coordinate
//        println(myLatString)
//        println(myLongString)
//    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var str: String
        switch(status){
        case .NotDetermined:       str = "NotDetermined"
        case .Restricted:          str = "Restricted"
        case .Denied:              str = "Denied"
        case .Authorized:          str = "Authorized"
        case .AuthorizedWhenInUse: str = "AuthorizedWhenInUse"
        }
        println("locationManager auth status changed, \(str)")
        
        if( status == .Authorized || status == .AuthorizedWhenInUse ) {
            locationManager.startUpdatingLocation()
            println("startUpdatingLocation")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("found \(locations.count) placemarks.")
        if( locations.count > 0 ){
            let location = locations[0] as CLLocation;
//            let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01,0.01))
//            self.mapView.setRegion(region, animated:true)  // Zoom to Current Location.
            
            locationManager.stopUpdatingLocation()
            println("location updated, lat:\(location.coordinate.latitude), lon:\(location.coordinate.longitude), stop updating.")
            
            // reverse geocoding
//            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
//                println("found \(placemarks.count) placemarks.")
//                if( placemarks.count > 0 ) {
//                    let placemark = placemarks[0] as CLPlacemark
//                    println("placemark:\(placemark.locality), \(placemark.subLocality)")  // ex. Shibuya, Dogenzaka
            
//                    let point = MKPointAnnotation()
//                    point.coordinate = location.coordinate
//                    point.title = "I'm here"
//                    point.subtitle = "\(placemark.locality), \(placemark.subLocality)"
//                    self.mapView.addAnnotation(point)
                }
//            })
//        }
    }
}
