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
    let rootNode = Node(kind: .directory, name: "/")
    
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
    

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
    }
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        // 読み取りモードでアーカイブを開く
        guard let archive = Archive(url: url, accessMode: .read) else {
            handler(PreviewError.fileOpenFailed)
            return
        }
        
        // アーカイブ内のエントリをすべてルートノードに追加
        let rootURL = URL(fileURLWithPath: "/")
        archive.forEach { [weak self] entry in
            // zipファイルをルートとする相対パスを取得
            let relativeEntryURL: URL
            let entryPathStr = entry.path(using: .utf8)
            if #available(macOS 13, *) {
                relativeEntryURL = .init(filePath: entryPathStr, relativeTo: rootURL)
            } else {
                relativeEntryURL = .init(fileURLWithPath: entryPathStr, relativeTo: rootURL)
            }
            
            // パスのコンポーネント配列を渡してルートノードに追加 最初に `/` が入ってしまっているので読み飛ばす
            let pathComponents = Array(relativeEntryURL.pathComponents[1...])
            self?.rootNode.appendChild(pathcomponents: pathComponents, kind: .init(entrytype: entry.type))
        }
        
        outlineView.reloadData()
        
        handler(nil)
    }
}
