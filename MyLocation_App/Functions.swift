//
//  Functions.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 11/20/20.
//

import Foundation

// Create method to initialize delay
func afterDelay(_ seconds: Double,
                             run: @escaping () -> Void) {

    DispatchQueue.main.asyncAfter(deadline: .now() + seconds,
                                  execute: run)
}
