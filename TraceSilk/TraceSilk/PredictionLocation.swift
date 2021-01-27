//
//  PredictionLocation.swift
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
    }
}
