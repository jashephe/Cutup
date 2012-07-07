//
//  CTShortcutRecorder.m
//  Cutup
//
//  Created by James Shepherdson on 6/8/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTShortcutRecorder.h"
#import "CTShortcutRecorderCell.h"

@interface CTShortcutRecorder ()
@property BOOL isRecording;
@end

@implementation CTShortcutRecorder

@synthesize isRecording, shortcut;

//- (void)commonInit {
//	[self setFocusRingType:NSFocusRingOnly];
//}
//
//- (id)initWithFrame:(NSRect)frameRect {
//	self = [super initWithFrame:frameRect];
//	if (self) {
//		[self commonInit];
//	}
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//	self = [super initWithCoder:aDecoder];
//	if (self) {
//		[self commonInit];
//	}
//	return self;
//}

+ (void)initialize {
	if (self == [CTShortcutRecorder class])
		[self setCellClass:[CTShortcutRecorderCell class]];
}


+ (Class)cellClass {
	return [CTShortcutRecorderCell class];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
	if (![self isEnabled])
		return;
	[[self window] makeFirstResponder:self];
	if (!shortcut) {
		shortcut = [[CTShortcut alloc] init];
		self.isRecording = YES;
	}
}
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
	if (!isRecording)
		return NO;
	shortcut.characters = [theEvent charactersIgnoringModifiers];
	shortcut.keyCode = [theEvent keyCode];
	shortcut.modifierFlags = [NSEvent modifierFlags];
	NSLog(@"Shortcut | Character:%@, Key Code:%hu, Modifiers:%lu", shortcut.characters, shortcut.keyCode, shortcut.modifierFlags);
	[self setNeedsDisplay:YES];
	isRecording = NO;
	return YES;
}

@end
