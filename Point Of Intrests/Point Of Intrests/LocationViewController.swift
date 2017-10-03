//
//  LocationViewController.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/30/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var coordinate:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
         mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
