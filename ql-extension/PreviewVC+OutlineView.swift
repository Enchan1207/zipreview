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
        if item == nil {
            return rootNode.children.count
        }
        return (item as! Node).children.count
    }
    
    // 親アイテムに対する小アイテムの情報を返す
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return rootNode.children[index]
        }
        return (item as! Node).children[index]
    }
    
    // 展開可能かどうか
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as! Node).kind == .directory
    }
    
    // グループアイテムかどうか
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
    }
    
    // アイテムの高さ
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 20
    }
    
}

// MARK: - NSOutlineViewDelegate

extension PreviewViewController: NSOutlineViewDelegate {
    
    // 各アイテムのビュー構成
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let cellView = outlineView.makeView(withIdentifier: .init(.init(describing: OutlineCellView.self)), owner: self) as? OutlineCellView else {return nil}
        cellView.configureCell(item as! Node)
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
