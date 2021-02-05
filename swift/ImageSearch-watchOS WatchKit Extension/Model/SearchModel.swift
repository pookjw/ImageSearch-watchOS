//
//  SearchModel.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/5/21.
//

import Foundation
import Alamofire
import RxSwift

final class SearchModel {
    public enum SearchError: Error, LocalizedError {
        case invalidData
        
        public var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Data Error!"
            }
        }
    }
    
    public static let shared: SearchModel = .init()
    public let searchData: PublishSubject<[SearchData]> = .init()
    
    private let api = URL(string: "https://dapi.kakao.com/v2/search/image")!
    private let kakaoAK = "dff576e28ce434796a2329a6a2366d76"
    
    public func request(text: String, page: Int = 1) {
        let parameters = ["query": text, "page": String(page)]
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(kakaoAK)"
        ]
        
        AF.request(api, method: .get, parameters: parameters, headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate(statusCode: 200...299)
            .responseJSON(queue: DispatchQueue.global()) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(_):
                    do {
                        guard let data = response.data else { throw SearchError.invalidData }
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(ReceivedData.self, from: data)
                        self.searchData.onNext(self.convert(decoded))
                    } catch {
                        self.searchData.onError(error)
                    }
                case let .failure(error):
                    self.searchData.onError(error)
                }
            }
    }
    
    private func convert(_ receivedData: ReceivedData) -> [SearchData] {
        return receivedData.documents
            .map { document in
                SearchData(
                    title: document.display_sitename,
                    thumbnailImage: URL(string: document.thumbnail_url),
                    originalImage: URL(string: document.image_url),
                    docURL: URL(string: document.doc_url)
                )
            }
    }
    
    private init() {}
}
