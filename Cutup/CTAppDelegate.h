//
//  CTAppDelegate.h
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CTAppDelegate : NSObject <NSApplicationDelegate>

@property IBOutlet NSMenu *statusItemMenu;
@property IBOutlet NSMenuItem *launchAtLoginItem;

- (IBAction)showPreferences:(id)sender;
- (IBAction)clearHistory:(id)sender;
- (IBAction)togglePasteboardWindow:(id)sender;
- (IBAction)setLaunchesAtLogin:(id)sender;

@end
