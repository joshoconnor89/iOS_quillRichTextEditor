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
    var currentSampleIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(60), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height - 110)))
        view.addSubview(containerView!)
        
        noteEditorController = QuillNoteEditorViewController(nibName: nil, bundle: nil)
        noteEditorController?.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //noteEditorController?.setUpTextInWebView(QuillSamples.browserUnsupportedPage)
    }
    
    func clenseHTML(_ htmlParam_p: String) -> String {
        var stringToReturn = htmlParam_p
        stringToReturn = htmlParam_p.replacingOccurrences(of: "\"", with: "\\\"")
        stringToReturn = htmlParam_p.replacingOccurrences(of: "\n", with: "\\n")
        stringToReturn = htmlParam_p.replacingOccurrences(of: "\r", with: "")
        stringToReturn = htmlParam_p.replacingOccurrences(of: "\'", with: "\\\'")
        return stringToReturn
    }

    
    @IBAction func newExampleButtonPressed(_ sender: Any) {
        let count = QuillSamples.sampleArray.count
            
        if currentSampleIndex < count {
            noteEditorController?.setUpTextInWebView(QuillSamples.sampleArray[currentSampleIndex])
        }else{
            noteEditorController?.setUpTextInWebView(QuillSamples.sampleArray[0])
            currentSampleIndex = 0
        }
        currentSampleIndex = currentSampleIndex + 1
        
    }
    

}


extension ViewController: QuillNoteEditorDelegate {

    func onSelectedTextinRange(_ range: NSRange, havingAttributes attributes: [Any]) {
        quillToolbar?.onSelectedTextinRange(range, havingAttributes: attributes)

    }
    
    func onWebViewLoaded() {
        noteEditorController?.setUpTextInWebView(QuillSamples.automaticallyGiveTeamsNewName)
    }

}

