//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Richard Reed on 10/13/16.
//  Copyright © 2016 Richard Reed. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
