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
    public var userInfo: BehaviorSubject<[AnyHashable: Any]> = .init(value: [:])
    public var userInfoSource: [AnyHashable: Any] {
        get {
            return (try? userInfo.value()) ?? [:]
        }
        set {
            sendUserInfo(newValue, save: false)
        }
    }
    public static let shared: WCModel = .init()
    
    private let userDefaults: UserDefaults = .standard
    private struct Const {
        static let userDefaultsKey: String = "WCModelData"
    }
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session: WCSession = .default
            session.delegate = self
            session.activate()
        }
        loadUserDefaults()
    }
    
    public func sendUserInfo(_ userInfo: [AnyHashable: Any], save: Bool = true) {
        print("Sending userInfo... \(userInfo)")
        self.userInfo.onNext(userInfo)
        if save {
            saveUserDefaults()
        }
    }
    
    private func saveUserDefaults() {
        userDefaults.setValue(userInfoSource, forKey: Const.userDefaultsKey)
    }
    
    private func loadUserDefaults() {
        guard let value: [AnyHashable: Any] = userDefaults.value(forKey: Const.userDefaultsKey) as? [AnyHashable: Any] else {
            return
        }
        userInfo.onNext(value)
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session Status: \(session), Error: \(String(describing: error?.localizedDescription))")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async { [weak self] in
            self?.userInfo.onNext(userInfo)
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    #endif
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}
