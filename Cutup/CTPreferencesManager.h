//
//  CTPreferencesManager.h
//  Cutup
//
//  Created by James Shepherdson on 6/5/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPreferencesManager : NSObject <NSToolbarDelegate>

@property (strong) NSWindow *window;

// -----------------------------
#pragma mark IB views
@property IBOutlet NSView *generalPrefView;
@property IBOutlet NSView *interfacePrefView;
@property IBOutlet NSView *advancedPrefView;
// -----------------------------

- (void)showPreferencesWindow;

@end
