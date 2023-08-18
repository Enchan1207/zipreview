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
        guard let columnID = tableColumn?.identifier.rawValue,
              let node = item as? Node else {return nil}
        
        // カラムの識別子で分岐
        switch columnID {
            
        case "name":
            // ファイル種別と名前
            guard let nameCellView = outlineView.makeView(withIdentifier: .init(.init(describing: FileNameCellView.self)), owner: self) as? FileNameCellView else {return nil}
            nameCellView.configureCell(node)
            return nameCellView
            
        case "modified_at":
            // 最終更新日
            guard let modifyDateCellView = outlineView.makeView(withIdentifier: .init(.init(describing: FileInfoCellView.self)), owner: self) as? FileInfoCellView,
                  let entryInfo = node.entryInfo else {return nil}
            
            // いい感じにフォーマットして設定
            let formatter = DateFormatter()
            formatter.calendar = .init(identifier: .gregorian)
            formatter.locale = .current
            formatter.dateStyle = .long
            modifyDateCellView.infoLabel.stringValue = formatter.string(from: entryInfo.lastModifiedAt)
            return modifyDateCellView
            
        case "size":
            // 展開後のファイルサイズ
            guard let originSizeCellView = outlineView.makeView(withIdentifier: .init(.init(describing: FileInfoCellView.self)), owner: self) as? FileInfoCellView,
                  let entryInfo = node.entryInfo else {return nil}
            
            // いい感じにフォーマットして設定
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = .useAll
            formatter.countStyle = .file
            originSizeCellView.infoLabel.stringValue = formatter.string(fromByteCount: .init(entryInfo.uncompressedSize))
            originSizeCellView.infoLabel.alignment = .right
            return originSizeCellView
            
        case "compress_rate":
            // 圧縮比
            guard let compressRateCellView = outlineView.makeView(withIdentifier: .init(.init(describing: FileInfoCellView.self)), owner: self) as? FileInfoCellView,
                  let entryInfo = node.entryInfo else {return nil}
            let compressRate = 1.0 - Double(entryInfo.compressedSize) / Double(entryInfo.uncompressedSize)
            
            // いい感じにフォーマットして設定
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            compressRateCellView.infoLabel.stringValue = formatter.string(from: .init(value: compressRate))!
            compressRateCellView.infoLabel.alignment = .right
            return compressRateCellView
            
        default:
            return nil
        }
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
