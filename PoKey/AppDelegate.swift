//
//  AppDelegate.swift
//  PoKey
//
//  Created by Vladimir Spasov on 5/7/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let pokemonDataSource = PokemonDataSource.sharedInstance


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureNavigationTabBar()
        setupApp()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let idString = url.valueOf(queryParamaterName: "id") else { return false }
        guard let id = Int(url.valueOf(queryParamaterName: "id")!) else { return false }
        print("New Ppokemon: \(id)")
        pokemonDataSource.addPokemonWith(id: Int(id))

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate {

    fileprivate func configureNavigationTabBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage     = UIImage()
        UINavigationBar.appearance().isTranslucent     = true

        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)

        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSShadowAttributeName: shadow
        ]

        UIApplication.shared.isStatusBarHidden = true
    }

    fileprivate func setupApp(){
        UserDefaults(suiteName: "group.PoKey")!.register(defaults: [
            "pokemonIds" : [],
            "SkipTutorial" : false,
            ])

        UserDefaults(suiteName: "group.PoKey")!.synchronize()

        let defaults = UserDefaults(suiteName: "group.PoKey")
        let ids = defaults?.array(forKey: "pokemonIds") as! [Int]
        print(ids)
    }
}

extension URL {
    func valueOf(queryParamaterName: String) -> String? {

        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

