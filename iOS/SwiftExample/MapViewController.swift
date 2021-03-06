
import UIKit
import MapKit
import CoreLocation
import Foundation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSURLConnectionDelegate {

    @IBOutlet var mapView : MKMapView?
    
    var data = NSMutableData()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         self.mapView?.mapType = MKMapType.Hybrid
//        self.mapView.delegate = self
        let location = "1 Lomb Memorial Drive, Rochester, NY 14623"
        var geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, {(placemarks, error) -> Void in
            
            if((error) != nil){
                
                println("Error", error)
            }
                
            else if let placemark = placemarks?[0] as? CLPlacemark {
                
                var placemark:CLPlacemark = placemarks[0] as CLPlacemark
                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
                
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                pointAnnotation.title = "RIT"
                
                self.mapView?.addAnnotation(pointAnnotation)
                self.mapView?.centerCoordinate = coordinates
                self.mapView?.selectAnnotation(pointAnnotation, animated: true)
                self.mapView?.zoomEnabled = true
                let mapCoord = coordinates
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCoord, fromEyeCoordinate: mapCoord, eyeAltitude: 1000)
                self.mapView?.setCamera(mapCamera, animated: true)
                println("Added annotation to map view")
            }
            })
    }
    
    func startConnection(){
        let urlPath: String = "http://rushg.me/TreasureHunt/hunt.php?q=getNearestHunts&coord=number,number"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary

//        var aArray: AvailableHunts = AvailableHunts(JSONString: jsonResult.description)
//        println(aArray.name1) // Output is "myUser"
        
        //var arrayObjects: AnyObject? = jsonResult.valueForKey("status")
        //let zero = arrayObjects[1]
       // println(arrayObjects)
    }
    
//       http://rushg.me/TreasureHunt/hunt.php?q=getNearestHunts&coord=number,number
    
    func mapView (mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            var pinView:MKPinAnnotationView = MKPinAnnotationView()
            pinView.annotation = annotation
            pinView.pinColor = MKPinAnnotationColor.Red
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            return pinView
    }
    
    func mapView(mapView: MKMapView!,
        didSelectAnnotationView view: MKAnnotationView!){
            
            println("Selected annotation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class AvailableHunts : NSObject {
        var name1 : String = ""
        var name2 : String = ""
        var name3 : String = ""
        var name4 : String = ""
        var name5 : String = ""
        var name6 : String = ""
        var name7 : String = ""
        var name8 : String = ""
        var name9 : String = ""
        
        init(JSONString: String) {
            super.init()
            
            var error : NSError?
            let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            let JSONDictionary: Dictionary = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: &error) as NSDictionary
            
            // Loop
            for (key, value) in JSONDictionary {
                let keyName = key as String
                let keyValue: String = value as String
                
                // If property exists
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
            // Or you can do it with using
            // self.setValuesForKeysWithDictionary(JSONDictionary)
            // instead of loop method above
        }
    }
    
}
