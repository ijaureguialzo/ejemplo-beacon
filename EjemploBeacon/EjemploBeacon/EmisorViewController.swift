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

class EmisorViewController: FormViewController, CBPeripheralManagerDelegate {

    // REF: Apple: Usar iPhone como baliza: https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon

    // Objects used in the creation of iBeacons
    var region: CLBeaconRegion?
    var manager: CBPeripheralManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Crear la baliza
        self.region = createBeaconRegion()

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

    // Crear la baliza
    func createBeaconRegion() -> CLBeaconRegion? {
        let proximityUUID = UUID(uuidString: miBaliza.uuid)
        let major: CLBeaconMajorValue = miBaliza.major
        let minor: CLBeaconMinorValue = miBaliza.minor
        let beaconID = miBaliza.id

        return CLBeaconRegion(proximityUUID: proximityUUID!,
                              major: major, minor: minor, identifier: beaconID)
    }

    // Actualizar el interfaz
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

    // Detectar si hemos activado correctamente la baliza
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if(peripheral.state == .poweredOn) {
            log.debug("Baliza ON")

            let peripheralData = region?.peripheralData(withMeasuredPower: nil)
            self.manager?.startAdvertising(peripheralData as? [String: Any])

            actualizar(tag: "estado", valor: "Transmitiendo")
        } else if(peripheral.state == .poweredOff) {
            log.debug("Baliza OFF")
            self.manager?.stopAdvertising()
            actualizar(tag: "estado", valor: "Apagada")
        }
    }

}
