//
//  ReceptorViewController.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import UIKit

import Eureka

class ReceptorViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        form +++ Section("Baliza")
        <<< LabelRow() { row in
            row.title = "UUID"
            row.value = "B6ED17C5-A342-4ACF-9862-8BE7D4E103BC"
        }
        <<< LabelRow() { row in
            row.title = "Major"
            row.value = "10"
        }
        <<< LabelRow() { row in
            row.title = "Minor"
            row.value = "1"
        }
            +++ Section()
        <<< LabelRow() { row in
            row.title = "Estado"
            row.value = "Inactivo"
        }
        <<< ButtonRow { row in
            row.title = "Detectar"
        }.onCellSelection { cell, row in
            log.debug("Iniciando detección")
        }
            +++ Section("Resultados")
        <<< SwitchRow { row in
            row.title = "Encontrada"
            row.value = true
        }
        <<< LabelRow() { row in
            row.title = "Precisión"
            row.value = "0.7234365243"
        }
        <<< LabelRow() { row in
            row.title = "Distancia"
            row.value = "Cerca"
        }
        <<< LabelRow() { row in
            row.title = "RSSI"
            row.value = "-54"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
