//
//  AppDelegate.swift
//  WKRecipes
//
//  Created by llv23 on 6/30/15.
//  Copyright © 2015 llv23. All rights reserved.
//

import UIKit
import CoreData
import PKRevealController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKRevealing {

    var window: UIWindow?;
    var revealController: PKRevealController?;

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Step 1: Create your controllers.
        let frontViewController = UIViewController();
        frontViewController.view.backgroundColor = UIColor.orangeColor();

        let frontNavigationController = UINavigationController(rootViewController: frontViewController);
        let rightViewController = UIViewController();
        rightViewController.view.backgroundColor = UIColor.redColor();

        // Step 2: Instantiate.
        self.revealController = PKRevealController(frontViewController: frontNavigationController, leftViewController: self.leftViewController(), rightViewController: self.rightViewController());
        // Step 3: Configure.
        self.revealController!.delegate = self;
        self.revealController!.animationDuration = 0.25;

        // Step 4: Apply.
        self.window!.rootViewController = self.revealController;
        return true
    }
    
    // see : http://stackoverflow.com/questions/24183812/swift-warning-equivalent
    @available(iOS, deprecated=1.0, message="pragma mark - Helpers, not finished yet")
    func leftViewController() -> UIViewController
    {
        let leftViewController = UIViewController();
        leftViewController.view.backgroundColor = UIColor.yellowColor();

        let presentationModeButton = UIButton(frame: CGRectMake(20.0, 60.0, 180.0, 30.0));
        presentationModeButton.setTitle("Presentation Mode", forState: UIControlState.Normal);
        presentationModeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        // see : http://stackoverflow.com/questions/24007650/selector-in-swift
        presentationModeButton.addTarget(self.revealController, action: Selector("startPresentationMode"), forControlEvents: UIControlEvents.TouchUpInside);
        leftViewController.view.addSubview(presentationModeButton);
        
        return leftViewController;
    }
    
    func rightViewController() -> UIViewController
    {
        let rightViewController = UIViewController();
        rightViewController.view.backgroundColor = UIColor.redColor();
    
        let presentationModeButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width-200.0, 60.0, 180.0, 30.0));
        presentationModeButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin;
        presentationModeButton.setTitle("Presentation Mode", forState: UIControlState.Normal);
        presentationModeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        presentationModeButton.addTarget(self.revealController, action: Selector("startPresentationMode"), forControlEvents: UIControlEvents.TouchUpInside);
    
        rightViewController.view.addSubview(presentationModeButton);
    
        return rightViewController;
    }
    
    func startPresentationMode()
    {
        if (!self.revealController!.isPresentationModeActive)
        {
            self.revealController?.enterPresentationModeAnimated(true, completion: nil);
        }
        else
        {
            self.revealController?.resignPresentationModeEntirely(false, animated: true, completion: nil);
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.llv23.dream2true.WKRecipes" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("WKRecipes", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

