//
//  CTShortcutRecorderCell.m
//  Cutup
//
//  Created by James Shepherdson on 6/8/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTShortcutRecorderCell.h"
#import "CTShortcutRecorder.h"

@implementation CTShortcutRecorderCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[self drawBorderWithFrame:cellFrame];
	[self drawTextWithFrame:NSInsetRect(cellFrame, 6, 3)];
}

- (void)drawBorderWithFrame:(NSRect)borderFrame {
	NSBezierPath *border = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(borderFrame, 2, 2) xRadius:MIN(borderFrame.size.width, borderFrame.size.height)/4.0f yRadius:MIN(borderFrame.size.width, borderFrame.size.height)/4.0f];
	[[NSColor whiteColor] set];
	[border fill];
	[[NSColor colorWithCalibratedWhite:0.4 alpha:1.0f] set];
	[border stroke];
	
	if ([self showsFirstResponder] && [self focusRingType] == NSFocusRingOnly) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle([self focusRingType]);
        [border fill];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (void)drawTextWithFrame:(NSRect)textFrame {
	[((CTShortcutRecorder *)[self controlView]).shortcut.characters drawInRect:textFrame withAttributes:nil];
}

@end
