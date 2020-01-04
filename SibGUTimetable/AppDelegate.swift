//
//  AppDelegate.swift
//  SibGUTimetable
//
//  Created by Alexandr on 14/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    static var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is nil and context too")
        }
    
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UITabBar.appearance().tintColor = .red
        UITabBar.appearance().barTintColor = .white
        
//        let tabBarController = UITabBarController()
//        tabBarController.tabBar.shadowImage = UIImage()
//        
//        let vc1 = UIViewController()
//        vc1.title = "In progress"
//        vc1.view.backgroundColor = .white
//        vc1.tabBarItem = UITabBarItem(title: "News feed", image: UIImage(named: "tab_bar_item_news_feed"), tag: 0)
//        let navC1 = putInNavigationController(vc1)
//        
//        let vc2 = ViewController()
//        vc2.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(named: "tab_bar_item_timetable"), tag: 1)
//        let navC2 = putInNavigationController(vc2)
//        
//        let vc3 = UIViewController()
//        vc3.title = "In progress"
//        vc3.view.backgroundColor = .white
//        vc3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "tab_bar_item_settings"), tag: 2)
//        let navC3 = putInNavigationController(vc3)
//        
//        tabBarController.viewControllers = [navC1, navC2, navC3]
//        tabBarController.selectedIndex = 1
        
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()
        let appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        
        return true
    }
    
    fileprivate func putInNavigationController(_ vc: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        return navigationController
    }


    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SibGUTimetable")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

