//
//  CTPreferencesManager.m
//  Cutup
//
//  Created by James Shepherdson on 6/5/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPreferencesManager.h"
#import "NSString+Range.h"
#import "NSToolbar+Height.h"

@interface CTPreferencesManager()
@property NSToolbar *toolbar;
@property NSMutableDictionary *toolbarItems;
@property NSMutableArray *views;
@end

@implementation CTPreferencesManager

@synthesize window, generalPrefView, interfacePrefView, advancedPrefView;
@synthesize toolbar, toolbarItems, views;

- (void)awakeFromNib {
	window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 300) styleMask:(NSTitledWindowMask | NSClosableWindowMask) backing:NSBackingStoreBuffered defer:NO];
	[window setTitle:@"Preferences"];
	toolbarItems = [[NSMutableDictionary alloc] initWithCapacity:1];
	views = [[NSMutableArray alloc] initWithCapacity:1];
	toolbar = [window toolbar];
	
	// Preference views
	[self addPreferenceView:generalPrefView withLabel:@"General" icon:[NSImage imageNamed:NSImageNamePreferencesGeneral]];
	[self addPreferenceView:interfacePrefView withLabel:@"Interface" icon:[NSImage imageNamed:NSImageNameColorPanel]];
	[self addPreferenceView:advancedPrefView withLabel:@"Advanced" icon:[NSImage imageNamed:NSImageNameAdvanced]];
	// ----------------
	
	[self prepareToolbar];
	
	[self changePanes:[toolbarItems objectForKey:[[self sortedToolbarItemIdentifiers] objectAtIndex:0]]];
	
	[self showPreferencesWindow];
}

- (void)showPreferencesWindow {
	[window center];
	[window makeKeyAndOrderFront:self];
}

- (void)prepareToolbar {
	if (toolbar == nil)
		toolbar = [[NSToolbar alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.preferences.toolbar", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]];
	
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setAutosavesConfiguration:NO];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	[toolbar setDelegate:self];
	[window setToolbar:toolbar];
	if ([toolbar respondsToSelector:@selector(setSelectedItemIdentifier:)]) {
		[toolbar setSelectedItemIdentifier:@"preferenceView.0"];
	}
}

- (void)changePanes:(id)sender {
	NSView *newView = [views objectAtIndex:((NSToolbarItem *)sender).tag];
	[window.contentView setSubviews:[NSArray array]];
	CGFloat deltaHeight = [window.contentView bounds].size.height - newView.frame.size.height;
	[window setFrame:NSMakeRect(window.frame.origin.x, window.frame.origin.y + deltaHeight, newView.frame.size.width, newView.frame.size.height + 22 + [toolbar heightForWindow:window]) display:YES animate:YES];
	[window.contentView addSubview:newView];
	window.title = ((NSToolbarItem *)sender).label;
}

static int tagCounter = 0;
- (void)addPreferenceView:(NSView *)preferenceView withLabel:(NSString *)label icon:(NSImage *)icon {
	NSString *identifier = [NSString stringWithFormat:@"preferenceView.%i", tagCounter];
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
	[item setPaletteLabel:label];
	[item setLabel:label];
	[item setImage:icon];
	[item setTag:tagCounter];
	[item setTarget:self];
	[item setAction:@selector(changePanes:)];
	[toolbarItems setObject:item forKey:identifier];
	[views addObject:preferenceView];

	tagCounter++;
}


#pragma mark Toolbar Delegate

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [self sortedToolbarItemIdentifiers];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [self sortedToolbarItemIdentifiers];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return [self sortedToolbarItemIdentifiers];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	return [toolbarItems objectForKey:itemIdentifier];
}
					   
#pragma mark Toolbar Item Dictionary Management

- (NSArray *)sortedToolbarItemIdentifiers {
	return [toolbarItems keysSortedByValueUsingComparator:^NSComparisonResult(NSToolbarItem *id1, NSToolbarItem *id2) {
		if (id1.tag == id2.tag)
			return NSOrderedSame;
		return (id1.tag < id2.tag ? NSOrderedAscending : NSOrderedDescending);
	}];
}

@end
