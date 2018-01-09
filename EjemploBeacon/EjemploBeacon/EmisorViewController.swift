//
//  EmisorViewController.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import UIKit

import Eureka

class EmisorViewController: FormViewController {

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
        <<< LabelRow() { row in
            row.title = "Identidad"
            row.value = "com.jaureguialzo.ejemplobeacon"
        }
            +++ Section()
        <<< LabelRow() { row in
            row.title = "Estado"
            row.value = "Listo para transmitir"
        }
        <<< ButtonRow { row in
            row.title = "Transmitir"
        }.onCellSelection { cell, row in
            log.debug("Iniciando transmisión")
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
