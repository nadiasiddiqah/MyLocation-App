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

// Find Core Data Store location
let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
}()

// Create + Post Fatal Core Data Error Notification
let CoreDataSaveFailedNotification = Notification.Name("CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}
