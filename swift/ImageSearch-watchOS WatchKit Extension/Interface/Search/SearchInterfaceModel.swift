//
//  SearchInterfaceModel.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/5/21.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchInterfaceModel {
    public struct Const {
        static let cellReuseIdentifier: String = "ListCell"
    }
    
    public var reloadTableViewEvent: Driver<[SearchData]>
    public var disposeBag: DisposeBag = .init()
    
    private var searchEvent: PublishSubject<[SearchData]> = .init()
    private var favoritesEvent: PublishSubject<[SearchData]> = .init()
    
    public init() {
        reloadTableViewEvent = Observable
            .combineLatest(SearchModel.shared.searchData, FavoritesModel.shared.searchData)
            .map { (search, _) -> [SearchData] in return search }
            .asDriver(onErrorJustReturn: [])
    }
    
    public func request(text: String, page: Int = 1) {
        SearchModel.shared.request(text: text)
        
        let key: String = "search_history"
        var context: [String: Any] = WCModel.shared.contextSource
        var history: [String: String] = (context[key] as? [String: String]) ?? [:]
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormatter.string(from: Date())
        history[dateString] = text
        
        context[key] = history
        WCModel.shared.sendContext(context)
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
