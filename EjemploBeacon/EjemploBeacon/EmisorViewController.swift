//
//  EmisorViewController.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import UIKit

import Eureka

import CoreLocation
import CoreBluetooth

class EmisorViewController: FormViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {

    // Objects used in the creation of iBeacons
    var region: CLBeaconRegion?
    var manager = CBPeripheralManager()

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        enableLocationServices()
        
        // Crear la baliza
        self.region = createBeaconRegion()

        form +++ Section("Baliza")
        <<< LabelRow() { row in
            row.title = "UUID"
            row.tag = "uuid"
        }
        <<< LabelRow() { row in
            row.title = "Major"
            row.tag = "major"
        }
        <<< LabelRow() { row in
            row.title = "Minor"
            row.tag = "minor"
        }
        <<< LabelRow() { row in
            row.title = "Identidad"
            row.tag = "identidad"
        }
            +++ Section()
        <<< LabelRow() { row in
            row.title = "Estado"
            row.tag = "estado"
            row.value = "Listo para transmitir"
        }
        <<< ButtonRow { row in
            row.title = "Transmitir"
        }.onCellSelection { cell, row in
            log.debug("Iniciando transmisión")
            
            self.actualizarPantalla()
            
            self.manager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        }

    }

    func createBeaconRegion() -> CLBeaconRegion? {
        let proximityUUID = UUID(uuidString:
            "B6ED17C5-A342-4ACF-9862-8BE7D4E103BC")
        let major: CLBeaconMajorValue = 100
        let minor: CLBeaconMinorValue = 1
        let beaconID = "com.jaureguialzo.ejemplobeacon"

        return CLBeaconRegion(proximityUUID: proximityUUID!,
                              major: major, minor: minor, identifier: beaconID)
    }

    func actualizarPantalla() {
        actualizar(tag: "uuid", valor: self.region?.proximityUUID.uuidString)
        actualizar(tag: "major", valor: "\(self.region?.major ?? 0)")
        actualizar(tag: "minor", valor: "\(self.region?.minor ?? 0)")
        actualizar(tag: "identidad", valor: self.region?.identifier)
    }

    func actualizar(tag campo: String, valor: String?) {
        let fila: LabelRow? = form.rowBy(tag: campo)
        fila?.value = valor
        fila?.reload()
    }
   
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if(peripheral.state == .poweredOn) {
            log.debug("Baliza ON")

            let peripheralData = region?.peripheralData(withMeasuredPower: nil)
            self.manager.startAdvertising(peripheralData as? [String : Any])

            actualizar(tag: "estado", valor: "Transmitiendo")
        } else if(peripheral.state == .poweredOff) {
            log.debug("Baliza OFF")
            self.manager.stopAdvertising()
            actualizar(tag: "estado", valor: "Apagada")
        }
    }

    // REF: Pedir autorización para la localización: https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_always_authorization
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:

            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            log.error("No tenemos acceso a la localización")
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            log.debug("Localización sólo al usar la aplicación")
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            log.debug("Localización permanente")
            break
        }
    }

    
}
