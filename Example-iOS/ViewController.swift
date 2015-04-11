//
//  ViewController.swift
//  Example-iOS
//
//  Created by Indragie on 1/15/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit
import CocoaMarkdown

class ViewController: UIViewController, CMAttributedStringRendererDelegate {
    @IBOutlet var textView: UITextView!
    var contentOffset : CGPoint = CGPointZero
    var renderer : CMAttributedStringRenderer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reloadData()
    }

    func reloadData() {
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "md")!
        let document = CMDocument(contentsOfFile: path)
        let renderer = CMAttributedStringRenderer(document: document, attributes: CMTextAttributes())
        let realBounds = UIEdgeInsetsInsetRect(textView.bounds, textView.textContainerInset)
        let effectiveWidth = realBounds.width - 2 * self.textView.textContainer.lineFragmentPadding
        renderer.registerHTMLElementTransformer(CMHTMLStrikethroughTransformer())
        renderer.registerHTMLElementTransformer(CMHTMLSuperscriptTransformer())
        renderer.registerHTMLElementTransformer(CMHTMLUnderlineTransformer())
        renderer.delegate = self
        renderer.maxImageSize = CGSizeMake(effectiveWidth, effectiveWidth)
        textView.attributedText = renderer.render()
        self.renderer = renderer
    }

    // MARK: CMAttributedStringRenderer

    func rendererContentDidInvalidate(render: CMAttributedStringRenderer!) {
        contentOffset = self.textView.contentOffset
        self.reloadData()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.textView.contentOffset = self.contentOffset
            println("restoreOffset")
        })
    }

}

