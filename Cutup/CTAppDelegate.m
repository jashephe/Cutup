//
//  CTAppDelegate.m
//  Cutup
//
//  Created by James Shepherdson on 5/20/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTAppDelegate.h"
#import "CTPasteboardViewController.h"
#import "CTPasteboardWindow.h"
#import "DDHotKeyCenter.h"
#import "CTPreferencesManager.h"
#import "NSWindow+Center.h"
#import "MAKVONotificationCenter.h"
#import "LaunchAtLoginController.h"

@interface CTAppDelegate ()
@property (strong) NSWindow *window;
@property (strong) NSStatusItem *statusItem;
@property (strong) CTPasteboardViewController *pasteboardViewController;
@end

@implementation CTAppDelegate

@synthesize statusItemMenu;
@synthesize window, statusItem, pasteboardViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	pasteboardViewController = [[CTPasteboardViewController alloc] initWithNibName:@"CTPasteboardViewController" bundle:[NSBundle mainBundle]];
	[pasteboardViewController.view setFrame:NSMakeRect(0, 0, [[[NSUserDefaults standardUserDefaults] valueForKey:@"pasteboardWindow.width"] floatValue], [[[NSUserDefaults standardUserDefaults] valueForKey:@"pasteboardWindow.height"] floatValue])];
	[pasteboardViewController unarchivePasteboardItemsData];
	window = [[CTPasteboardWindow alloc] initWithContentRect:pasteboardViewController.view.frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[window setMinSize:NSMakeSize(200, 150)];
	[window setLevel:NSFloatingWindowLevel];
	[window reallyCenter];
	[window setContentView:[pasteboardViewController view]];
	[[[DDHotKeyCenter alloc] init] registerHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSShiftKeyMask) task:^(NSEvent *task) {
		if ([window isVisible]) {
			[window orderOut:self];
		}
		else {
			[NSApp activateIgnoringOtherApps:YES];
			[window makeKeyAndOrderFront:self];
		}
	}];
	[self configurePreferences];
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:32];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:@"CT"];
	[statusItem setMenu:statusItemMenu];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[pasteboardViewController archivePasteboardItemsData];
}

- (void)configurePreferences {
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	[[NSUserDefaultsController sharedUserDefaultsController] addObservationKeyPath:[@"values." stringByAppendingString:@"pasteboardWindow.color"] options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
		[window.contentView setNeedsDisplay:YES];
	}];
}

- (IBAction)showPreferences:(id)sender {
	[NSBundle loadNibNamed:@"CTPreferences" owner:self];
}

@end
