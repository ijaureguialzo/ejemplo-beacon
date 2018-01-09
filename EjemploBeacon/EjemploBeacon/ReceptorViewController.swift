//
//  ReceptorViewController.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import UIKit

import Eureka

import CoreLocation
import CoreBluetooth

class ReceptorViewController: FormViewController, CLLocationManagerDelegate {

    // REF: Apple: Calcular distancia a baliza: https://developer.apple.com/documentation/corelocation/determining_the_proximity_to_an_ibeacon

    // Objects used in the creation of iBeacons
    var region: CLBeaconRegion?
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Formulario
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
            +++ Section()
        <<< LabelRow() { row in
            row.title = "Estado"
            row.tag = "estado"
            row.value = "Inactivo"
        }
        <<< ButtonRow { row in
            row.title = "Detectar"
        }.onCellSelection { cell, row in
            log.debug("Iniciando detección")

            self.manager?.startMonitoring(for: self.region!)

            self.actualizar(tag: "estado", valor: "Iniciando detección")
        }
            +++ Section("Resultados")
        <<< SwitchRow { row in
            row.title = "Encontrada"
            row.tag = "encontrada"
            row.value = false
        }
        <<< LabelRow() { row in
            row.title = "Precisión"
            row.tag = "precision"
        }
        <<< LabelRow() { row in
            row.title = "Distancia"
            row.tag = "distancia"
        }
        <<< LabelRow() { row in
            row.title = "RSSI"
            row.tag = "rssi"
        }

        self.manager = CLLocationManager()
        manager?.delegate = self
        region = CLBeaconRegion(proximityUUID: UUID(uuidString: miBaliza.uuid)!, identifier: miBaliza.id)
    }

    // Actulizar el interfaz
    func actualizar(tag campo: String, valor: String?) {
        let fila: LabelRow? = form.rowBy(tag: campo)
        fila?.value = valor
        fila?.reload()
    }

    func actualizarSwitch(tag campo: String, activado valor: Bool) {
        let fila: SwitchRow? = form.rowBy(tag: campo)
        fila?.value = valor
        fila?.reload()
    }

    func reset() {
        self.actualizar(tag: "uuid", valor: "")
        self.actualizar(tag: "major", valor: "")
        self.actualizar(tag: "minor", valor: "")
        self.actualizarSwitch(tag: "encontrada", activado: false)
        self.actualizar(tag: "precision", valor: "")
        self.actualizar(tag: "rssi", valor: "")
    }

    // Responder a los eventos de localización
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.actualizar(tag: "estado", valor: "Buscando...")
        manager.startRangingBeacons(in: region as! CLBeaconRegion) // Para pruebas
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        self.actualizar(tag: "estado", valor: "Posible coincidencia")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.actualizar(tag: "estado", valor: "Error :(")
        log.error(error)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        reset()
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if(beacons.count == 0) { return }

        let beacon = beacons.last!

        if (beacon.proximity == .unknown) {
            self.actualizar(tag: "distancia", valor: "")
            reset()
            return
        } else if (beacon.proximity == .immediate) {
            self.actualizar(tag: "distancia", valor: "Al lado")
        } else if (beacon.proximity == .near) {
            self.actualizar(tag: "distancia", valor: "Cerca")
        } else if (beacon.proximity == .far) {
            self.actualizar(tag: "distancia", valor: "Lejos")
        }

        self.actualizar(tag: "uuid", valor: beacon.proximityUUID.uuidString)
        self.actualizar(tag: "major", valor: "\(beacon.major)")
        self.actualizar(tag: "minor", valor: "\(beacon.minor)")
        self.actualizarSwitch(tag: "encontrada", activado: true)
        self.actualizar(tag: "precision", valor: "\(beacon.accuracy)")
        self.actualizar(tag: "rssi", valor: "\(beacon.rssi)")

    }

}
