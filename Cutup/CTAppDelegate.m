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
#import "NSWindow+Center.h"
#import "MAKVONotificationCenter.h"
#import "LaunchAtLoginController.h"
#import "CTShortcut.h"

@interface CTAppDelegate ()
@property (strong) CTPasteboardWindow *window;
@property (strong) NSStatusItem *statusItem;
@property (strong) CTPasteboardViewController *pasteboardViewController;
@end

@implementation CTAppDelegate

@synthesize statusItemMenu, launchAtLoginItem;
@synthesize window, statusItem, pasteboardViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self setPreferenceDefaults];
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];  // Why isn't this set on a per-color well basis?
	
	
	LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
	if([launchController launchAtLogin])
		[launchAtLoginItem setState:NSOnState];
	else
		[launchAtLoginItem setState:NSOffState];
	
	NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Info.plist"]];
	NSLog(@"%@ Version:  %@", [plistData objectForKey:@"CFBundleName"], [plistData objectForKey:@"CFBundleVersion"]);
	
	pasteboardViewController = [[CTPasteboardViewController alloc] initWithNibName:@"CTPasteboardViewController" bundle:[NSBundle mainBundle]];
	[pasteboardViewController.view setFrame:NSMakeRect(0, 0, [[[NSUserDefaults standardUserDefaults] valueForKey:CTPasteboardWindowWidthKey] floatValue], [[[NSUserDefaults standardUserDefaults] valueForKey:CTPasteboardWindowHeightKey] floatValue])];
	[pasteboardViewController unarchivePasteboardItemsData];
	
	window = [[CTPasteboardWindow alloc] initWithContentRect:pasteboardViewController.view.bounds styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[window setBackgroundGradient:[[NSGradient alloc] initWithStartingColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientTopColorKey]] endingColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientBottomColorKey]]]];
	[window setBorderColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientBorderColorKey]]];
	[window setLevel:NSFloatingWindowLevel];
	[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	[window setMinSize:NSMakeSize(200, 200)];
	[window reallyCenter];
	[window setContentView:[pasteboardViewController view]];
	
	[[[DDHotKeyCenter alloc] init] registerHotKeyWithKeyCode:9 modifierFlags:(NSCommandKeyMask | NSShiftKeyMask) task:^(NSEvent *task) {
		[self togglePasteboardWindow:nil];
	}];
	
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:32];
	[statusItem setHighlightMode:YES];
	[statusItem setImage:[NSImage imageNamed:@"menubar"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"menubar-alt"]]; 
	[statusItem setMenu:statusItemMenu];
//	[self configurePreferenceActions];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[pasteboardViewController archivePasteboardItemsData];
}

#pragma mark Preferences Management

- (void)setPreferenceDefaults {
	NSDictionary *initialValues = [[NSDictionary alloc] initWithObjectsAndKeys:
								   [NSNumber numberWithInt:300], CTPasteboardWindowWidthKey,
								   [NSNumber numberWithInt:250], CTPasteboardWindowHeightKey,
								   [NSArchiver archivedDataWithRootObject:[NSColor colorWithCalibratedWhite:0.98 alpha:0.96]], CTPasteboardWindowGradientTopColorKey,
								   [NSArchiver archivedDataWithRootObject:[NSColor colorWithCalibratedWhite:0.92 alpha:0.96]], CTPasteboardWindowGradientBottomColorKey,
								   [NSArchiver archivedDataWithRootObject:[NSColor colorWithCalibratedWhite:0.5 alpha:1.0]], CTPasteboardWindowGradientBorderColorKey,
								   [NSNumber numberWithBool:NO], CTLaunchAtLoginKey,
								   [NSNumber numberWithInt:30], CTPasteboardItemsMemoryKey,
								   nil];
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValues];
	[[NSUserDefaultsController sharedUserDefaultsController] revertToInitialValues:self];
}

- (void)configurePreferenceActions {
	[[NSUserDefaultsController sharedUserDefaultsController] addObservationKeyPath:[NSArray arrayWithObjects:[@"values." stringByAppendingString:CTPasteboardWindowGradientTopColorKey], [@"values." stringByAppendingString:CTPasteboardWindowGradientBottomColorKey], [@"values." stringByAppendingString:CTPasteboardWindowGradientBorderColorKey], nil] options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
		[window setBackgroundGradient:[[NSGradient alloc] initWithStartingColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientTopColorKey]] endingColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientBottomColorKey]]]];
		[window setBorderColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:CTPasteboardWindowGradientBorderColorKey]]];
		[window.contentView setNeedsDisplay:YES];
	}];
}

#pragma mark IBActions

- (IBAction)showPreferences:(id)sender {
	NSLog(@"showPreferences:(id)sender Not implemented.");
}

- (IBAction)clearHistory:(id)sender {
	[pasteboardViewController clearPasteboardHistory];
}

- (IBAction)togglePasteboardWindow:(id)sender {
	if ([window isVisible]) {
		[window orderOut:self];
	}
	else {
		[NSApp activateIgnoringOtherApps:YES];
		[window makeKeyAndOrderFront:self];
		[window makeFirstResponder:pasteboardViewController];
	}
}

- (IBAction)setLaunchesAtLogin:(id)sender {
	LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
	if ([sender state] == NSOffState) {
		[launchController setLaunchAtLogin:YES];
		[sender setState:NSOnState];
	}
	else {
		[launchController setLaunchAtLogin:NO];
		[sender setState:NSOffState];
	}
}

@end
