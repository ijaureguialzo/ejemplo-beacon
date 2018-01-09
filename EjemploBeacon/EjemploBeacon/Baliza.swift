//
//  Baliza.swift
//  EjemploBeacon
//
//  Created by Ion Jaureguialzo Sarasola on 9/1/18.
//  Copyright © 2018 Ion Jaureguialzo Sarasola. All rights reserved.
//

import Foundation

import CoreLocation

struct Baliza {
    var uuid: String
    var major: CLBeaconMajorValue
    var minor: CLBeaconMinorValue
    var id: String
}
