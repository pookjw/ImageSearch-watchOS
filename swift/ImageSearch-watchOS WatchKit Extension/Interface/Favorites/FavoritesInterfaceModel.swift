//
//  FavoritesInterfaceModel.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoritesInterfaceModel {
    public struct Const {
        static let cellIdentifier: String = "ListCell"
    }
    
    public var reloadTableViewEvent: Driver<[SearchData]>
    public var disposeBag: DisposeBag = .init()
    
    private var searchEvent: PublishSubject<[SearchData]> = .init()
    private var favoritesEvent: PublishSubject<[SearchData]> = .init()
    
    public init() {
        reloadTableViewEvent = FavoritesModel.shared.searchData
            .asDriver(onErrorJustReturn: [])
    }
    
    public func toggleFavorite(_ searchData: SearchData) {
        var favorites: [SearchData] = FavoritesModel.shared.searchDataSource
        if let idx = favorites.firstIndex(of: searchData) {
            favorites.remove(at: idx)
        } else {
            favorites.append(searchData)
        }
        FavoritesModel.shared.searchDataSource = favorites
    }
}
