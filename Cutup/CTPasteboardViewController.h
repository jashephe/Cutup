//
//  CTPasteboardViewController.h
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CTPasteboardItemViewController.h"

@interface CTPasteboardViewController : NSViewController

@property IBOutlet NSView *pasteboardContentView;
@property IBOutlet NSSegmentedControl *controlBar;
@property (strong) CTPasteboardItemViewController *pasteboardItemViewController;
@property (strong) NSMutableArray *pasteboardItemsData;

- (BOOL)archivePasteboardItemsData;
- (BOOL)unarchivePasteboardItemsData;
- (void)clearPasteboardHistory;
- (IBAction)performControlBarAction:(NSSegmentedControl *)sender;

@end
