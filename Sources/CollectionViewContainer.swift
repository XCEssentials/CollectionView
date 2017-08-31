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

import SnapKit

//===

open
class CollectionViewContainer<Empty, Failure, Data>: UIView
    where
    Empty: UIView,
    Failure: UIView,
    Data: CollectionDataContainer
{
    public
    let emptyPlaceholder: Empty
    
    public
    let failurePlaceholder: Failure
    
    public
    var layout: UICollectionViewLayout
    {
        return collection.collectionViewLayout
    }
    
    public
    let collection: UICollectionView
    
    public
    let data: Data
    
    public
    func proxy() -> CollectionContainerProxy<Data>
    {
        return CollectionContainerProxy(
            view: self.collection,
            data: self.data
        )
    }
    
    // MARK: - Initializers
    
    public
    required
    init(
        showWhenEmpty empty: Empty,
        showOnFailure failure: Failure,
        contentLayout layout: UICollectionViewLayout,
        dataController: Data
        )
    {
        self.emptyPlaceholder = empty
        self.failurePlaceholder = failure
        
        self.collection = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        
        self.data = dataController
        
        //---
        
        super.init(frame: .zero)
        
        //--- hierarchy
        
        addSubview(emptyPlaceholder)
        addSubview(failurePlaceholder)
        addSubview(collection)
        
        //--- layout
        
        emptyPlaceholder.snp.makeConstraints {
            
            $0.edges.equalToSuperview()
        }
        
        failurePlaceholder.snp.makeConstraints {
            
            $0.edges.equalToSuperview()
        }
        
        collection.snp.makeConstraints {
            
            $0.edges.equalToSuperview()
        }
        
        //--- other settings
        
        emptyPlaceholder.isHidden = false
        failurePlaceholder.isHidden = true
        collection.isHidden = true
        
        //--- bindings
        
        collection.delegate = dataController
        collection.dataSource = dataController
        
        if
            #available(iOS 10.0, *)
        {
            collection.prefetchDataSource = dataController
        }
        
//        if
//            #available(iOS 11.0, *)
//        {
//            collection.dragDelegate = dataController
//            collection.dropDelegate = dataController
//        }
    }
    
    public
    required
    init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Presentation logic

extension CollectionViewContainer
{
    func showEmpty()
    {
        emptyPlaceholder.isHidden = false
        failurePlaceholder.isHidden = true
        collection.isHidden = true
    }
    
    func showFailure()
    {
        emptyPlaceholder.isHidden = true
        failurePlaceholder.isHidden = false
        collection.isHidden = true
    }
    
    func showContent()
    {
        emptyPlaceholder.isHidden = true
        failurePlaceholder.isHidden = true
        collection.isHidden = false
    }
}
