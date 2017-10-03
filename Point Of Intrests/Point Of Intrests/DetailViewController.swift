//
//  DetailViewController.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/30/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var pointOfIntrest:PointOfIntrest!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pointOfIntrest.name
        imageView.image = UIImage(data:pointOfIntrest.imageData as Data)
        cityLabel.text = pointOfIntrest.city.name
        contactNumberLabel.text = String(pointOfIntrest.number)
        categoryLabel.text = pointOfIntrest.category.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let locationViewController = segue.destination as? LocationViewController else{
            return
        }
        locationViewController.coordinate = CLLocationCoordinate2D(latitude: pointOfIntrest.latitude, longitude: pointOfIntrest.longitude)
        
     }
    

}
