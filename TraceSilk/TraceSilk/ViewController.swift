//
//  ViewController.swift
//  TraceSilk
//
//  Created by 孙钰昇 on 2021/1/25.
//

import UIKit
import Vision
import MapKit


class PredictionLocation: NSObject, MKAnnotation{
    var identifier = "Prediction location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init(name:String,lat:CLLocationDegrees,long:CLLocationDegrees){
        title = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
    }
}

class PredictionLocationList: NSObject {
    var place = [PredictionLocation]()
    override init(){
        place += [PredictionLocation(name:"1",lat: 0, long: 0)]
        place += [PredictionLocation(name:"2",lat: 1, long: 1)]
        place += [PredictionLocation(name:"3",lat: 2, long: 2)]
        place += [PredictionLocation(name:"4",lat: 3, long: 3)]
        place += [PredictionLocation(name:"5",lat: 4, long: 4)]
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    

    // Define Core ML model
    // Make sure to add the file  in the Project Navigator, and have Target Membership checked
    let model = RN1015k500()

    
    //MARK: - Map setup
    func resetRegion(){
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }

    var myLatitude = ""
    var myLongitude = ""

    // Array of annotations
    let annotation = MKPointAnnotation()
    var places = PredictionLocationList().place


    override func viewDidLoad() {
        super.viewDidLoad()

        //Swipe configuration

        //let image = UIImage(named: pictureString)
        let image = GetImageController.image
        imageView.image = image

        predictUsingVision(image: image!)

    }

    func predictUsingVision(image: UIImage) {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Something went wrong")
        }

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                let top3 = observations.prefix(through: 2)
                    .map { ($0.identifier, Double($0.confidence)) }
                self.show(results: top3)
            }
        }

        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
    }

    typealias Prediction = (String, Double)

    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            let latLongArr = pred.0.components(separatedBy: "\t")
            myLatitude = latLongArr[1]
            myLongitude = latLongArr[2]
            s.append(String(format: "%d: %@ %@ (%3.2f%%)", i + 1, myLatitude, myLongitude, pred.1 * 100))
            places[i].title = String(i+1)
            places[i].coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(myLatitude)!, longitude: CLLocationDegrees(myLongitude)!)
        }
        predictionLabel.text = s.joined(separator: "\n")
        if GetImageController.location != nil{
            places[0].title = "踪丝锁定"
            places[0].coordinate = GetImageController.location
            predictionLabel.text = "图片踪丝显示,在下图区域!"
        }
        

        // Map reset
        resetRegion()
        // Center on first prediction
        mapView.centerCoordinate = places[0].coordinate
        // Show annotations for the predictions on the map
        mapView.addAnnotations(places)
        // Zoom map to fit all annotations
        zoomMapFitAnnotations()
    }


    



    func zoomMapFitAnnotations() {
        var zoomRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint.init(annotation.coordinate)
            let pointRect = MKMapRect.init(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            if (zoomRect.isNull) {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets.init(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }

}

