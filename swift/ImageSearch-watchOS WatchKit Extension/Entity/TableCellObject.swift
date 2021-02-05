//
//  TableCellObject.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/5/21.
//

import WatchKit

final class TableCellObject: NSObject {
    @IBOutlet weak var superGroup: WKInterfaceGroup!
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var subTitleLabel: WKInterfaceLabel!
    
    private(set) var searchData: SearchData?
    
    public func configure(_ searchData: SearchData) {
        self.searchData = searchData
        imageView.kf.setImage(with: searchData.thumbnailImage)
        titleLabel.setText(getRoundedTitle())
        subTitleLabel.setText(searchData.docURL?.absoluteString)
    }
    
    public func setFavoritedStatus() {
        guard let searchData: SearchData = searchData else { return }
        let favorites: [SearchData] = FavoritesModel.shared.searchDataSource
        superGroup?.setBackgroundColor(favorites.contains(searchData) ? UIColor.orange.withAlphaComponent(0.5) : nil)
    }
    
    private func getRoundedTitle() -> String {
        guard let searchData: SearchData = searchData,
              let title: String = searchData.title,
              !title.isEmpty
        else {
            return "(🤔)"
        }
        return title
    }
}
