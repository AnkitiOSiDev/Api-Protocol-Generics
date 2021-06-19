//
//  DataProvider.swift
//  ApiCall
//
//  Created by Ankit on 09/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation


protocol WrapperData: Hashable {
}

protocol DataProvider {
    var  pagination :Paging {get}
    var  fetchingStatus: FetchingStatus {get set}
    var  delegate : DataProviderDelegate {get}
    var  pageNo: Int {get}
    func isFetchingFirstPage() -> Bool
    func numberOfItems() -> Int
    func numberOfHeaders() -> Int
    func isNoDataPresent() -> Bool
    func getData<T:Hashable>(index:Int) -> T?
    func getData<T:Hashable>(section:Int) -> T?
    func fetchFirstPage()
    func fetchNextPage()
}


protocol DataProviderDelegate {
    func requestUpdatedSuccessFully()
    func requestFailed(message:String)
}

enum PagingStatus {
    case noData
    case moreData
    case noMoreDataAvailable
}

enum FetchingStatus {
    case idle
    case fetching
}

struct Paging {
    let isPagingAvailable: Bool
    var paginStatus: PagingStatus
    var pageLimit: Int
}


extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
