//
//  ViewController.swift
//  Sample
//
//  Created by admin on 05/10/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MapKit


class ViewController: UIViewController {
    @IBOutlet weak var attributionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textField: UITextField!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func search(_ sender: AnyObject) {
        let path = GMSMutablePath()
        let bounds = GMSCoordinateBounds(path: path)
        placeAutocomplete(mapString: textField.text!, bounds: bounds)
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

        func loadFirstPhotoForPlace(placeID: String) {
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if error != nil {
                // TODO: handle the error.
                print("Error", error?.localizedDescription)
                } else {
                    if let firstPhoto = photos?.results.first {
                        self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
        func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
            GMSPlacesClient.shared()
            .loadPlacePhoto(photoMetadata, constrainedTo: imageView.bounds.size,
                            scale: self.imageView.window!.screen.scale) { (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error", error.localizedDescription)
                                } else {
                                    self.imageView.image = photo
                                }
                                self.attributionTextView.attributedText = photoMetadata.attributions;
        }
    }
        func placeAutocomplete(mapString: String, bounds: GMSCoordinateBounds) {
            let placesClient = GMSPlacesClient.shared()
        let filter = GMSAutocompleteFilter()
            
            filter.type = GMSPlacesAutocompleteTypeFilter.noFilter
            placesClient.autocompleteQuery(mapString, bounds: bounds, filter: filter, callback: { (results, error: Error?) -> Void in
                if results != nil{
                    for result in results! {
                        print("Result \(result.attributedFullText.string) with placeID \(result.placeID)")
//
                        print(result.types)
                        if result.types.contains("establishment")
                        {
                            print(result.placeID)
                            self.loadFirstPhotoForPlace(placeID: result.placeID!)
                            break
                        }
            }
            }
        })
        }
}
