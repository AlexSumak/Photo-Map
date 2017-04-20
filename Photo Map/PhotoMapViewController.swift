//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,LocationsViewControllerDelegate, MKMapViewDelegate {
  @IBOutlet weak var mapsView: MKMapView!
  
  var pickedImage: UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapsView.delegate = self
    
    let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
    // Set animated property to true to animate the transition to the region
    mapsView.setRegion(region, animated: false)
    
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("Camera is available 📸")
      vc.sourceType = .camera
    } else {
      print("Camera 🚫 available so we will use photo library instead")
      vc.sourceType = .photoLibrary
    }
    
    //self.present(vc, animated: true, completion: nil)
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    addPin(latitude: latitude, longitude: longitude)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseID = "myAnnotationView"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
    if (annotationView == nil) {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
    }
    
    let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
    // Add the image you stored from the image picker
    imageView.image = pickedImage
    
    return annotationView
  }
  
  func addPin(latitude: NSNumber, longitude: NSNumber) {
    let annotation = MKPointAnnotation()
    let locationCoordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
    annotation.coordinate = locationCoordinate
    annotation.title = String(describing: latitude)
    mapsView.addAnnotation(annotation)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    // Get the image captured by the UIImagePickerController
    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
    pickedImage = editedImage
    
    self.dismiss(animated: true) {
      self.performSegue(withIdentifier: "tagSegue", sender: nil)
    }
    
    // Dismiss UIImagePickerController to go back to your original view controller
    dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let locationsViewController = segue.destination as! LocationsViewController
    locationsViewController.delegate = self
  }
  
  @IBAction func onCameraTap(_ sender: Any) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("Camera is available 📸")
      vc.sourceType = .camera
    } else {
      print("Camera 🚫 available so we will use photo library instead")
      vc.sourceType = .photoLibrary
    }
    
    self.present(vc, animated: true, completion: nil)
    
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
