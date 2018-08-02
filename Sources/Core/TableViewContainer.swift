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
class TableViewContainer<EmptyPlaceholder, FailurePlaceholder>: UIView
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
    let table: UITableView

    // MARK: - Helpers

    private
    var nestedViews: [UIView]
    {
        return [emptyPlaceholder, failurePlaceholder, table]
    }

    // MARK: - Initializers

    public
    required
    init(
        showWhenEmpty empty: EmptyPlaceholder = EmptyPlaceholder.init(),
        showOnFailure failure: FailurePlaceholder = FailurePlaceholder.init(),
        style: UITableViewStyle = .plain
        )
    {
        self.emptyPlaceholder = empty
        self.failurePlaceholder = failure

        self.table = UITableView(
            frame: CGRect.zero,
            style: style
        )

        //---

        super.init(frame: .zero)

        //--- hierarchy

        nestedViews.forEach{ self.addSubview($0) }

        //--- layout

        translatesAutoresizingMaskIntoConstraints = false

        nestedViews.forEach{

            $0.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }

        //--- other settings

        self.backgroundColor = .clear

        emptyPlaceholder.alpha = 1
        emptyPlaceholder.isHidden = false  // shown by default

        failurePlaceholder.alpha = 1
        failurePlaceholder.isHidden = true // hidden

        table.backgroundColor = .clear
        table.alpha = 1
        table.isHidden = true // hidden
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
extension TableViewContainer
{
    func showEmpty()
    {
        emptyPlaceholder.isHidden = false
        failurePlaceholder.isHidden = true
        table.isHidden = true
    }

    func showFailure()
    {
        emptyPlaceholder.isHidden = true
        failurePlaceholder.isHidden = false
        table.isHidden = true
    }

    func showContent()
    {
        emptyPlaceholder.isHidden = true
        failurePlaceholder.isHidden = true
        table.isHidden = false
    }
}

public
extension TableViewContainer
{
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
                self.table.isHidden = true
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
                self.table.isHidden = true
            }
        )
    }

    var showContentViaOpacity: SwitchViaOpacity
    {
        return (
            {
                self.table.alpha = 0
                self.bringSubview(toFront: self.table)
                self.table.isHidden = false
            },
            {
                self.table.alpha = 1
            },
            {
                self.emptyPlaceholder.isHidden = true
                self.failurePlaceholder.isHidden = true
            }
        )
    }
}

// MARK: - Helper aliases

public
typealias TableContainer<Empty: UIView, Failure: UIView> =
    TableViewContainer<Empty, Failure>

public
typealias StandardTableContainer =
    TableContainer<NoContentView, NoContentView>
