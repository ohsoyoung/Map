//
//  ViewController.swift
//  Map
//
//  Created by 오소영 on 2017. 6. 20..
//  Copyright © 2017년 오소영. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var locationName: UILabel!
    @IBOutlet var locationInfo: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationName.text = ""
        locationInfo.text = ""
        locationManager.delegate = self
        
        //정확도 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //위치데이터 추적 위해 사용자에게 승인요구
        locationManager.requestWhenInUseAuthorization()
        
        //위치업데이트 시작
        locationManager.startUpdatingLocation()
        
        //위치보기값을 true로 설정
        myMap.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goLocation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue: CLLocationDegrees, delta span :Double)-> CLLocationCoordinate2D {
        
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpanMake(span, span)
        let pRegion = MKCoordinateRegionMake(pLocation, spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    //원하는 곳에 핀 설치하기 위한 함수
    func setAnnotation(latitude latitudeValue: CLLocationDegrees, longitude longitudeValue: CLLocationDegrees, dalta span :Double, title strTitle: String, subtitle strSubtitle: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitude: latitudeValue, longitude: longitudeValue, delta: span)
        
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let pLocation = locations.last
        goLocation(latitude: (pLocation?.coordinate.latitude)!, longitude: (pLocation?.coordinate.longitude)!, delta: 0.03)
        
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.locationInfo.text = "현재 위치"
            self.locationName.text = address
        
        })
        
        locationManager.stopUpdatingLocation()
    }


    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            setAnnotation(latitude: 37.610192, longitude: 126.95503789999998, dalta: 0.6, title: "우리집", subtitle: "서울시 종로구 구기동")
        }
        else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitude: 37.6063202, longitude: 127.04180799999995, dalta: 0.6, title: "동덕여대", subtitle: "서울특별시 성북구 하월곡동 23-1")
            self.locationName.text = "보고 계신 위치"
            self.locationInfo.text = "동덕여자대학교"
        }
        else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitude: 37.5520078, longitude: 126.92133660000002, dalta: 0.6, title: "홍대", subtitle: "서울특별시 마포구 서교동 366-18")
            self.locationName.text = "보고 계신 위치"
            self.locationInfo.text = "홍대"
        }
        
    }
    
    
}

