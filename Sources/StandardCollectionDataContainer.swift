/*
 
 MIT License
 
 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import UIKit

//===

/**
 Objective-C-based protocols do not support default function implementations in protocol extensions, so here is a default implementation of the protocol, which still allows to custom configure behaviour without subclassing - jsut provide cell getter and cell configuration closures at initialization and it will do rest of the boilerplate work for you.
 */
open
class StandardCollectionDataContainer<Item: Equatable>: NSObject, CollectionDataContainer
{
    // MARK: - Initializers
    
    public
    required
    init(
        cellGetter: @escaping CellGetter,
        cellConfigurator: @escaping CellConfigurator<Item>
        )
    {
        self.cellGetter = cellGetter
        self.cellConfigurator = cellConfigurator
    }
    
    // MARK: - CollectionDataContainer support
    
    public
    let cellGetter: CellGetter
    
    public
    let cellConfigurator: CellConfigurator<Item>
    
    public
    var items: [Selectable<Item>] = []
    
    // MARK: - UICollectionViewDataSource support

    open
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return items.count
    }

    open
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return items[section].elements.count
    }

    open
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell
    {
        return cellGetter(collectionView, indexPath)
    }

    // MARK: - UICollectionViewDataSourcePrefetching support

    @available(iOS 10.0, *)
    open
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
        )
    {
        // override for custom behaviour
    }

    @available(iOS 10.0, *)
    open
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
        )
    {
        // override for custom behaviour
    }

    // MARK: - UICollectionViewDelegate support

    open
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
        )
    {
        cellConfigurator(
            cell,
            items[indexPath.section].elements[indexPath.item]
        )
    }

    // MARK: - UICollectionViewDragDelegate support

    @available(iOS 11.0, *)
    public
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
        ) -> [UIDragItem]
    {
        return [] // override for custom behaviour
    }

    // MARK: - UICollectionViewDropDelegate support

    @available(iOS 11.0, *)
    public
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
        )
    {
        // override for custom behaviour
    }
}
