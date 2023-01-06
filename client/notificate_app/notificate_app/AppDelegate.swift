//
//  AppDelegate.swift
//  notificate_app
//
//  Created by matama on 2022/12/28.
//

import UIKit
import UserNotifications

//@UIApplicationDelegateAdaptor
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // ① プッシュ通知の利用許可のリクエスト送信
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }

            DispatchQueue.main.async {
                // ② プッシュ通知利用の登録
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        return true
    }
}

extension AppDelegate {

    // ③ プッシュ通知の利用登録が成功した場合
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
//        var token = ""
//
//        for i in 0..<deviceToken.count {
//                token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//            }
            print("Device Token = \(token)")
        NSLog("text: \(textContent)")

        textContent = token
        NSLog("Device token: \(token)")
    }

    // ④ プッシュ通知の利用登録が失敗した場合
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to APNs: \(error)")
    }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // ユーザー通知の許可がなくても、Remote Notificationを受信したらここが実行される。
        // Remote Notificationのペイロードに `"content-available": 1` が入っていると、バックグラウンドからここが呼ばれる

        // UserNotificationCenterDelegateも実装していた場合、
        // アプリがフォアグラウンドで実行中は、
        // このメソッドと合わせて、`userNotificationCenter(_:willPresent:withCompletionHandler:)`も呼ばれる。
        // → 処理が重複しないように注意する必要がある
        // → バックグラウンド判定には、UIApplication.shared.applicationState == .background が使えそう

        // ここで処理する内容は、
        // userInfoからカスタムペイロードを取り出したり……
//        let isNewDataAvailable = userInfo["new-data-available"] as! Bool
        // UserDefaultsにセットして、次回の起動時にフェッチさせるようにしたり……
//        UserDefaults.standard.set(isNewDataAvailable, forKey: "new-data-available")
        // サーバと同期したり
//        if isNewDataAvailable {
//            let remote = MyServiceRepository()  // あくまでサンプル
//            let newData = remote.fetch()  // 非同期処理しているとする
//            MyLocalStorage().setApplicationData(newData)
//        }
        let path_id = userInfo["path_id"] as? String
        textContent = path_id ?? ""
        NSLog("text: \(String(describing: path_id))")

        // そして30秒以内に、completionHandlerを呼ぶ（必須）
        completionHandler(.newData)
    }
}
