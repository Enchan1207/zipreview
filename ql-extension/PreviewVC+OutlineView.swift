//
//  PreviewVC+OutlineView.swift
//  ql-extension
//
//  Created by EnchantCode on 2023/08/14.
//

import Cocoa

// MARK: - NSOutlineViewDataSource

extension PreviewViewController: NSOutlineViewDataSource {
    
    // アイテムが含む子アイテムの数を返す
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        // TODO: アイテム見て決める
        return (item == nil) ? 5 : 3
    }
    
    // 親アイテムに対する小アイテムの情報を返す
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        // TODO: アイテム見て決める
        return (item == nil) ? (2 * index + 1) : (2 * (index + 1))
    }
    
    // 展開可能かどうか
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        // TODO: アイテム見て決める
        guard let itemID = item as? Int else {return false}
        return (itemID % 2) != 0
    }
    
    // グループアイテムかどうか
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        // TODO: アイテム見て決める
        return false
    }
    
    // アイテムの高さ
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        // TODO: アイテム見て決める (計算できるようにする?)
        return 20
    }
    
}

// MARK: - NSOutlineViewDelegate

extension PreviewViewController: NSOutlineViewDelegate {
    
    // 各アイテムのビュー構成
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let cellView = outlineView.makeView(withIdentifier: .init(.init(describing: OutlineCellView.self)), owner: self) as? OutlineCellView else {return nil}
        
        // ここでアイテムの値に従ってセルビューを構成
        
        return cellView
    }
    
    // アイテム選択の可否
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return true
    }
    
    // 選択項目変更の処理
    func outlineViewSelectionDidChange(_ notification: Notification) {
        print(notification)
    }
    
}
