//
//  CreateMemoryController.swift
//  EventTracker
//
//  Created by Portia Wang on 7/2/17.
//  Copyright © 2017 Portia Wang. All rights reserved.
//

import UIKit
import MapKit
class CreateMemoryController: UIViewController, MKMapViewDelegate {
    
    
//properties
    
    var activity : Activity?
    @IBOutlet weak var addedPhoto: UIImageView!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    var photoHelper = MGPhotoHelper()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
//functions
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "save"{
            if (titleTextField.text == "")||(descriptionTextField.text == "") || (addedPhoto.image == nil){
                let alertController = UIAlertController(title: "", message:
                    "Did you enter a title/description/photo? If not, please do so! It is important for you to document the details of your memory!! :)", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    //unwind to map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            } else if identifier == "save" {
               
                    let activity = self.activity ?? CoreDataHelper.newActivity();
                    activity.name = titleTextField.text ?? "Untitled Activity"
                    activity.descriptionOfActivity = descriptionTextField.text ?? "No description"
                    activity.dateCreated = Date() as NSDate
                    activity.photo = addedPhoto.image
                    activity.latitude = (locationMapView.userLocation.location?.coordinate)!.latitude as NSObject
                    activity.longitude = (locationMapView.userLocation.location?.coordinate)!.longitude as NSObject
                    CoreDataHelper.saveActivity()
                }
            }
    }
    
   // override func shouldAutorotate() -> Bool {
   //     return false
   // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    locationMapView.showsUserLocation = true
    locationMapView.delegate = self
    uploadPhotoButton.layer.cornerRadius = 10
    addedPhoto.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //set region/zoom in for map
        let userLocation = locationMapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, 2000, 2000)
        locationMapView.setRegion(region, animated: true)
    }
    
    @IBAction func uploadPhotoButtonTapped(_ sender: UIButton) {
        photoHelper.presentActionSheet(from: self)
        photoHelper.completionHandler = { image in
            self.addedPhoto.image = image
        }
    
    }
 
}


