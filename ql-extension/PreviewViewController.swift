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
            if #available(macOS 13, *) {
                relativeEntryURL = .init(filePath: entry.path, relativeTo: rootURL)
            } else {
                relativeEntryURL = .init(fileURLWithPath: entry.path, relativeTo: rootURL)
            }
            
            // パスのコンポーネント配列を渡してルートノードに追加 最初に `/` が入ってしまっているので読み飛ばす
            let pathComponents = Array(relativeEntryURL.pathComponents[1...])
            self?.rootNode.appendChild(pathcomponents: pathComponents, kind: .init(entrytype: entry.type))
        }
        
        // TODO: viewを更新
        
        handler(nil)
    }
}
