//
//  WCModel.swift
//  ImageSearch-watchOS
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation
import WatchConnectivity
import RxSwift

final class WCModel: NSObject, WCSessionDelegate {
    public var context: BehaviorSubject<[String: Any]> = .init(value: [:])
    public var contextSource: [String: Any] {
        get {
            return (try? context.value()) ?? [:]
        }
        set {
            sendContext(newValue)
        }
    }
    public static let shared: WCModel = .init()
    
    private let userDefaults: UserDefaults = .standard
    private let session: WCSession = .default
    
    private struct Const {
        static let userDefaultsKey: String = "WCModelData"
    }
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
        }
        loadUserDefaults()
    }
    
    public func activateIfSupported() {
        if WCSession.isSupported() {
            session.activate()
        }
    }
    
    public func sendContext(_ context: [String: Any]) {
        print("Sending context... \(context)")
        if session.activationState == .activated {
            do {
                try session.updateApplicationContext(context)
            } catch {
                print("Alert! Updating app context failed \(error.localizedDescription)")
            }
        } else {
            print("Alert! WCSession is not activated.")
        }
        
        self.context.onNext(context)
        saveUserDefaults()
    }
    
    private func saveUserDefaults() {
        userDefaults.set(contextSource, forKey: Const.userDefaultsKey)
    }
    
    private func loadUserDefaults() {
        guard let value: [String: Any] = userDefaults.dictionary(forKey: Const.userDefaultsKey) else {
            return
        }
        context.onNext(value)
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session Status: \(session), Error: \(String(describing: error?.localizedDescription))")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received context: \(applicationContext)")
        DispatchQueue.main.async { [weak self] in
            self?.sendContext(applicationContext)
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    #endif
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
