//
//  OutlineCellView.swift
//  ql-extension
//
//  Created by EnchantCode on 2023/08/14.
//

import Cocoa
import Instantiate
import InstantiateStandard

class OutlineCellView: NSTableCellView, NibInstantiatable {
    
    /// エントリの種類 (file/directory/symlink) を表すアイコン
    @IBOutlet weak var entryKindIcon: NSImageView!
    
    /// エントリがリンクかどうかを表すインジケータ
    @IBOutlet weak var linkIndicator: NSImageView!
    
    /// エントリ名
    @IBOutlet weak var entryNameLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
