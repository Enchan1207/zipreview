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
        
        // アーカイブ内の各エントリのパスを取得
        let entryPaths: [URL] = archive.map{entry in
            let pathStr = entry.path(using: .utf8)
            if #available(macOS 13, *) {
                return .init(filePath: pathStr)
            } else {
                return .init(fileURLWithPath: pathStr)
            }
        }
        
        for (index, entryPath) in entryPaths.enumerated() {
            NSLog("entry %d: %@", index, entryPath.absoluteString)
        }
        
        handler(nil)
    }
}
