//
//  DetailInterfaceController.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import WatchKit
import Foundation
import Kingfisher

final class DetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var removeButton: WKInterfaceButton!
    private var searchData: SearchData?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let context: [String: SearchData] = context as? [String : SearchData],
              let searchData: SearchData = context["searchData"]
        else { return }
        imageView.kf.setImage(with: searchData.originalImage)
        setTitle(searchData.title)
        self.searchData = searchData
    }
    
    @IBAction func removeButtonAction() {
        guard let searchData: SearchData = searchData else {
            return
        }
        var favorites: [SearchData] = FavoritesModel.shared.searchDataSource
        if let idx = favorites.firstIndex(of: searchData) {
            favorites.remove(at: idx)
            FavoritesModel.shared.searchDataSource = favorites
        }
        pop()
    }
    
}
