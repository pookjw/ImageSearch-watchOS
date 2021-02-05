//
//  FavoritesModel.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation
import RxSwift

final class FavoritesModel {
    public static let shared: FavoritesModel = .init()
    public let searchData: BehaviorSubject<[SearchData]> = .init(value: [])
    public var searchDataSource: [SearchData] {
        get {
            return (try? searchData.value()) ?? []
        }
        set {
            saveData(with: newValue)
            searchData.onNext(newValue)
        }
    }
    private let userDefaults: UserDefaults = UserDefaults.standard
    private struct Const {
        static let userDefaultsKey: String = "FavoritesModelData"
    }
    
    public func reset() {
        searchDataSource.removeAll()
        userDefaults.removeObject(forKey: Const.userDefaultsKey)
    }
    
    private init() {
        loadData()
    }
    
    public func loadData() {
        searchDataSource = userDefaults.getObjects(forKey: Const.userDefaultsKey)
        saveData()
    }
    
    private func saveData(with newValue: [SearchData]? = nil) {
        guard let newValue: [SearchData] = newValue else {
            userDefaults.setObjects(searchDataSource, forKey: Const.userDefaultsKey)
            return
        }
        userDefaults.setObjects(newValue, forKey: Const.userDefaultsKey)
    }
}

