//
//  PreviewViewController.swift
//  ql-extension
//
//  Created by EnchantCode on 2023/08/14.
//

import Cocoa
import Quartz
import ZIPFoundation

class PreviewViewController: NSViewController, QLPreviewingController {
    
    enum PreviewError: Error {
        case fileOpenFailed
    }
    
    /// ルートノード
    let rootNode = Node(kind: .directory, name: "/", entryInfo: nil)
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }
    
    @IBOutlet weak var outlineView: NSOutlineView! {
        didSet{
            outlineView.delegate = self
            outlineView.dataSource = self
            
            outlineView.autosaveExpandedItems = false
            outlineView.autosaveTableColumns = false
            
            outlineView.selectionHighlightStyle = .regular
            outlineView.floatsGroupRows = false
            
            outlineView.register(OutlineCellView.nib, forIdentifier: .init(rawValue: .init(describing: OutlineCellView.self)))
        }
    }
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        // 読み取りモードでアーカイブを開く
        guard let archive = Archive(url: url, accessMode: .read) else {
            handler(PreviewError.fileOpenFailed)
            return
        }
        
        // アーカイブ内のエントリをすべてルートノードに追加
        archive.forEach { [weak self] entry in
            let entryURL: URL
            if #available(macOS 13, *) {
                entryURL = .init(filePath: entry.path(using: .utf8), relativeTo: .init(filePath: "/"))
            } else {
                entryURL = .init(fileURLWithPath: entry.path(using: .utf8), relativeTo: .init(fileURLWithPath: "/"))
            }
            self?.rootNode.addEntry(entry: entry, destination: entryURL)
        }
        
        outlineView.reloadData()
        
        handler(nil)
    }
}
