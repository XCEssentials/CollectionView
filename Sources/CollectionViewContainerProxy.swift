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

public
struct CollectionContainerProxy<Data: CollectionDataContainer>
{
    let view: UICollectionView
    let data: Data
}

//===

public
extension CollectionContainerProxy
{
    // MARK: - Items management
    
    func insert(items: [Data.Item], at indexPath: IndexPath)
    {
        do
        {
            data.items[indexPath.section].elements = // 3. update section
                try data.items.xce.element(at: indexPath.section) // 1. if valid section
                    .elements.xce.insert(items, at: indexPath.item) // 2. if valid for insert items
            
            view.insertItems(at: [indexPath]) // 4. update UI
        }
        catch
        {
            // silently ignore
        }
    }
    
    func removeItem(at indexPath: IndexPath)
    {
        do
        {
            data.items[indexPath.section].elements =
                try data.items.xce.element(at: indexPath.section)
                    .elements.xce.remove(elementAt: indexPath.item)
            
            view.deleteItems(at: [indexPath])
        }
        catch
        {
            // silently ignore
        }
    }
    
    // MARK: - Selection management
    
    /**
     See: https://developer.apple.com/documentation/uikit/uicollectionview/1618057-selectitem
     
     - Parameter indexPath: The index path of the item to select. Specifying nil for this parameter clears the current selection.
     */
    func selectItem(
        at indexPath: IndexPath?,
        scrollPosition: UICollectionViewScrollPosition
        )
    {
        do
        {
            if
                let indexPath = indexPath
            {
                data.items[indexPath.section] =
                    try data.items.xce.element(at: indexPath.section)
                        .select(at: indexPath.item)
            }
            else
            {
                for i in data.items.startIndex...data.items.endIndex
                {
                    data.items[i] = data.items[i].clearSelection()
                }
            }
            
            view.selectItem(
                at: indexPath,
                animated: false,
                scrollPosition: scrollPosition
            )
        }
        catch
        {
            // silently ignore
        }
    }
    
    func deselectItem(at indexPath: IndexPath)
    {
        do
        {
            data.items[indexPath.section] =
                try data.items.xce.element(at: indexPath.section)
                    .deselect(at: indexPath.item)
            
            view.deselectItem(at: indexPath, animated: false)
        }
        catch
        {
            // silently ignore
        }
    }
}
