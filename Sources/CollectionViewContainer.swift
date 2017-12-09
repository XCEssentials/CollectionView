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

//---

open
class CollectionViewContainer<EmptyPlaceholder, FailurePlaceholder>: UIView
    where
    EmptyPlaceholder: UIView,
    FailurePlaceholder: UIView
{
    // MARK: - Subviews

    public
    let emptyPlaceholder: EmptyPlaceholder
    
    public
    let failurePlaceholder: FailurePlaceholder

    public
    let collection: UICollectionView

    // MARK: - Helpers

    private
    var nestedViews: [UIView]
    {
        return [emptyPlaceholder, failurePlaceholder, collection]
    }

    public
    var layout: UICollectionViewLayout
    {
        return collection.collectionViewLayout
    }

    // MARK: - Initializers

    public
    required
    init(
        showWhenEmpty empty: EmptyPlaceholder = EmptyPlaceholder.init(),
        showOnFailure failure: FailurePlaceholder = FailurePlaceholder.init(),
        contentLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout()
        )
    {
        self.emptyPlaceholder = empty
        self.failurePlaceholder = failure
        
        self.collection = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        
        //---
        
        super.init(frame: .zero)
        
        //--- hierarchy

        nestedViews.forEach{ self.addSubview($0) }
        
        //--- layout

        translatesAutoresizingMaskIntoConstraints = false

        nestedViews.forEach{

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }
        
        //--- other settings

        emptyPlaceholder.alpha = 1
        emptyPlaceholder.isHidden = false  // shown by default

        failurePlaceholder.alpha = 1
        failurePlaceholder.isHidden = true // hidden

        collection.alpha = 1
        collection.isHidden = true         // hidden
    }
    
    public
    required
    init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Presentation logic helpers

public
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

public
extension CollectionViewContainer
{
    typealias SwitchViaOpacity = (
        prepare: () -> Void, // call this before animation starts
        execute: () -> Void, // call this inside animation block
        cleanup: () -> Void  // call after animation completion (optional)
    )

    var showEmptyViaOpacity: SwitchViaOpacity
    {
        return (
            {
                self.emptyPlaceholder.alpha = 0
                self.bringSubview(toFront: self.emptyPlaceholder)
                self.emptyPlaceholder.isHidden = false
            },
            {
                self.emptyPlaceholder.alpha = 1
            },
            {
                self.failurePlaceholder.isHidden = true
                self.collection.isHidden = true
            }
        )
    }

    var showFailureViaOpacity: SwitchViaOpacity
    {
        return (
            {
                self.failurePlaceholder.alpha = 0
                self.bringSubview(toFront: self.failurePlaceholder)
                self.failurePlaceholder.isHidden = false
            },
            {
                self.failurePlaceholder.alpha = 1
            },
            {
                self.emptyPlaceholder.isHidden = true
                self.collection.isHidden = true
            }
        )
    }

    var showContentViaOpacity: SwitchViaOpacity
    {
        return (
            {
                self.collection.alpha = 0
                self.bringSubview(toFront: self.collection)
                self.collection.isHidden = false
            },
            {
                self.collection.alpha = 1
            },
            {
                self.emptyPlaceholder.isHidden = true
                self.failurePlaceholder.isHidden = true
            }
        )
    }
}

//---

public
typealias SimpleCollectionViewContainer = CollectionViewContainer<NoContentView, NoContentView>

//---

/**
 Shorter typealiases, would be especially convenient when use module name as a prefix.
 */
public
typealias Container<Empty: UIView, Failure: UIView> =
    CollectionViewContainer<Empty, Failure>

public
typealias SimpleContainer = SimpleCollectionViewContainer
