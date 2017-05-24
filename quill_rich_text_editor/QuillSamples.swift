//
//  QuillSamples.swift
//  quill_rich_text_editor
//
//  Created by Josh O'Connor on 5/24/17.
//  Copyright © 2017 Josh O'COnnor. All rights reserved.
//


import Foundation
import UIKit

struct QuillSamples {
    
    static let sampleArray = [blankDescription, browserUnsupportedPage, viewTaskNewDesign]
    
    //#5d6
    static let blankDescription = "{\"ops\":[{\"insert\":\"\\n\"}]}"

    //#6ya
    static let browserUnsupportedPage = "{\"ops\":[{\"insert\":\"This page will be displayed when we  detect a browser someone is using might not be supported. Please make it very simple and informative. \\nMain text: \\\"Whoops! Your browser might be too old to use ClickUp. \\n\\\"ClickUp uses cutting-edge technology that older browsers don\'t support. It\'s time to upgrade your browser.\\\"\\nBig button: \\\"Update browser\\\" \\nSmaller button: \\\"Continue to ClickUp anyway\\\" \\n\"}]}"
    
    //#3tt
    static let viewTaskNewDesign = "{\"ops\":[{\"insert\":\"Base design: \"},{\"attributes\":{\"link\":\"https://projects.invisionapp.com/d/main#/console/10198406/224037083/preview\"},\"insert\":\"https://projects.invisionapp.com/d/main#/console/10198406/224037083/preview\"},{\"insert\":\"\\nNote that there are several screens, see their \"},{\"insert\":\"name\",\"attributes\":{\"background\":\"#ffff00\"}},{\"insert\":\" in that section for what they may represent. \\nFor \"},{\"insert\":\"new drop-down style\",\"attributes\":{\"background\":\"#ffff00\"}},{\"insert\":\", see these pages please click through them: \"},{\"attributes\":{\"link\":\"https://projects.invisionapp.com/d/main#/console/10198406/218510105/preview\"},\"insert\":\"https://projects.invisionapp.com/d/main#/console/10198406/218510105/preview\"},{\"insert\":\"\\nGroup like activity items together and events that happened it close timespan: again, please browse through the screens in task view on invison. \\n\"}]}"
    
}
