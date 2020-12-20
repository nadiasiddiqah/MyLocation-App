//
//  SceneDelegate.swift
//  MyLocation_App
//
//  Created by Nadia Siddiqah on 10/29/20.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Instance properties
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        }
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: - Helper Methods
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification,
            object: nil, queue: OperationQueue.main) { (notification) in
            
            let message = """
            There was a fatal error in the app and it cannot continue.

            Press OK to terminate the app. Sorry for the inconvenience.
            """
            
            let alert = UIAlertController(title: "Internal Error",
                                          message: message,
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK",
                                       style: .default) { _ in
                let exception = NSException(
                    name: NSExceptionName.internalInconsistencyException,
                    reason: "Fatal Core Data Error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
        
            let tabController = self.window!.rootViewController!
            tabController.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Scene Methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let tabController = window!.rootViewController as! UITabBarController
        if let tabViewControllers = tabController.viewControllers {
            // First tab
            var navController = tabViewControllers[0] as! UINavigationController
            let viewController1 = navController.viewControllers.first as! CurrentLocationViewController
            viewController1.managedObjectContext = managedObjectContext
            // Second tab
            navController = tabViewControllers[1] as! UINavigationController
            let viewController2 = navController.viewControllers.first as! LocationsViewController
            viewController2.managedObjectContext = managedObjectContext
            // Third tab
            navController = tabViewControllers[2] as! UINavigationController
            let viewController3 = navController.viewControllers.first as! MapViewController
            viewController3.managedObjectContext = managedObjectContext
        }
        print(applicationDocumentsDirectory)
        listenForFatalCoreDataNotifications()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

