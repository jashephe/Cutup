//
//  CTPasteboardItemViewController.h
//  Cutup
//
//  Created by James Shepherdson on 5/23/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTPasteboardItemDataStore.h"

@interface CTPasteboardItemViewController : NSViewController

@property CTPasteboardItemDataStore *pasteboardItemDataStore;

- (void)overwritePasteboardWithPasteboardItem;

@end
