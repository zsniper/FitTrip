//
//  DetailViewController.swift
//  WeatherHack2
//
//  Created by zkmb on 2015-01-18.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var name:String!
    var address:String!
    var time:String!
    var tags:String!
    var originX:Double!
    var originY:Double!
    var destX:Double!
    var destY:Double!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (name != nil) {
            nameLabel.text = name
        }
        
        if (address != nil) {
            addressLabel.text = address
        }
        
        if (time != nil) {
            timeLabel.text = time
        }
        
        if (tags != nil) {
            tagsLabel.text = tags
        }
        
        if (destX == 0) {
            return
        }
        
        
        // Do any additional setup after loading the view.
        
        mapView?.setCenterCoordinate(CLLocationCoordinate2DMake(originX, originY), animated: false)
        
        let BASE_RADIUS = 0.0144927536 * 3
        
        var location = CLLocation(latitude: originX, longitude: originY)
        var region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(BASE_RADIUS, BASE_RADIUS))
        
        mapView?.setRegion(region, animated: true)
        
        var source = MKPlacemark(coordinate: CLLocationCoordinate2DMake(originX, originY), addressDictionary: ["": ""])
        
        var srcMapItem = MKMapItem(placemark: source)
        srcMapItem.name = "";
        
        var destination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destX, destY), addressDictionary: ["": ""])
        
        var distMapItem = MKMapItem(placemark: destination)
        distMapItem.name = "";
        
        var request = MKDirectionsRequest()
        request.setSource(srcMapItem)
        request.setDestination(distMapItem)
        //        request.transportType = MKDirectionsTransportTypeWalking;
        
        var direction = MKDirections(request: request)
        
        direction.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            NSLog("Response = \(response)")
            
            var arrRoutes = response.routes
            for obj in arrRoutes {
                var rout:MKRoute = obj as MKRoute
                var line = rout.polyline
                
                self.mapView?.addOverlay(line)
                
                NSLog("Rout Name : \(rout.name)")
                NSLog("Total Distance (in Meters) :\(rout.distance)")
                
                var steps = rout.steps
                
                NSLog("Total Steps : \(steps.count)")
                
                for obj1 in steps {
                    NSLog("Rout Instruction : \(obj.instructions)")
                    NSLog("Rout Distance : \(obj.distance)")
                }
                
            }
        }
        
    }
    
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay.isKindOfClass(MKPolyline)) {
            var aView = MKPolylineRenderer(polyline: overlay as MKPolyline)
            aView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            aView.lineWidth = 10
            return aView
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
