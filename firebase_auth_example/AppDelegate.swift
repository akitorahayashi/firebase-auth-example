//
//  AppDelegate.swift
//  firebase_auth_example
//
//  Created by 林 明虎 on 2024/12/09.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // アプリの起動時
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate: アプリが起動しました")
        FirebaseApp.configure()
        return true
    }
    // シーンセッションの作成時
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("AppDelegate: 新しいシーンセッションが作成されました")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // シーンセッションの破棄時
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("AppDelegate: シーンセッションが破棄されました。破棄されたセッション数: \(sceneSessions.count)")
    }
}

