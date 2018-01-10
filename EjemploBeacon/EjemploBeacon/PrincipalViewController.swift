//
//  PrincipalViewController.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import UIKit

import CoreLocation

// REF: Documentación de Apple: https://developer.apple.com/ibeacon/
// REF: Tutorial original sobre iBeacons: https://www.pubnub.com/blog/2014-08-19-smart-ibeacon-communication-in-the-swift-programming-language/

let miBaliza = Baliza(uuid: "B6ED17C5-A342-4ACF-9862-8BE7D4E103BC",
                      major: 100,
                      minor: 1,
                      id: "com.jaureguialzo.ejemplobeacon")

class PrincipalViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Activar la localización y pedir los permisos
        enableLocationServices()
    }

    // REF: Pedir autorización para la localización: https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_always_authorization

    func enableLocationServices() {
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break

        case .restricted, .denied:
            log.error("No tenemos acceso a la localización")
            break

        case .authorizedWhenInUse:
            log.debug("Localización sólo al usar la aplicación")
            break

        case .authorizedAlways:
            log.debug("Localización permanente")
            break
        }
    }

}
