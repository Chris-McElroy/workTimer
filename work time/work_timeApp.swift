//
//  work_timeApp.swift
//  work time
//
//  Created by Chris McElroy on 7/13/22.
//

import SwiftUI

@main
struct work_timeApp: App {
//	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// for playing notificaitons in app:
// from https://ishtiz.com/swift/how-to-show-local-notification-when-the-app-is-foreground
//class AppDelegate: NSObject, UIApplicationDelegate {
//	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//		// Show local notification in foreground
//		UNUserNotificationCenter.current().delegate = self
//
//		return true
//	}
//}
//
//// Conform to UNUserNotificationCenterDelegate to show local notification in foreground
//extension AppDelegate: UNUserNotificationCenterDelegate {
//	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//		completionHandler([.banner, .badge, .sound])
//	}
//}
