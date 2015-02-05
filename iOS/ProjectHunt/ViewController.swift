//
//  ViewController.swift
//  ProjectHunt
//
//  Created by Student on 2/4/15.
//  Copyright (c) 2015 Rush. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapControl: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latitute : CLLocationDegrees = 48.90
        var longitude : CLLocationDegrees = 34.1
        var latitudeDelta : CLLocationDegrees = 0.0
        var longitudeDelta : CLLocationDegrees = 0.0
        
        var span : MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        var reqdLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitute, longitude)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(reqdLocation, span)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

