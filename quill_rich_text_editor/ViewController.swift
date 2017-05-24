//
//  ViewController.swift
//  quill_rich_text_editor
//
//  Created by Joshua O'Connor on 5/24/17.
//  Copyright © 2017 Josh O'COnnor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var containerView: UIView?
    var quillToolbar: QuillToolbar?
    var noteEditorController: QuillNoteEditorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(60), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height - 60)))
        view.addSubview(containerView!)
        
        noteEditorController = QuillNoteEditorViewController(nibName: nil, bundle: nil)
        addChildViewController(noteEditorController!)
        containerView?.addSubview((noteEditorController?.view)!)
        noteEditorController?.view.frame = (containerView?.bounds)!
        noteEditorController?.didMove(toParentViewController: self)
        
        quillToolbar = QuillToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(60)))
        quillToolbar?.editorViewController = noteEditorController
        view.addSubview(quillToolbar!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension ViewController: QuillNoteEditorDelegate {

    func onSelectedTextinRange(_ range: NSRange, havingAttributes attributes: [Any]) {
        quillToolbar?.onSelectedTextinRange(range, havingAttributes: attributes)

    }
    
    func onWebViewLoaded() {
        print("onWebViewLoaded")
    }

}

