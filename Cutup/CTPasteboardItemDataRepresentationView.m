//
//  CTPasteboardItemDataRepresentationView.m
//  Cutup
//
//  Created by James Shepherdson on 6/24/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTPasteboardItemDataRepresentationView.h"
#import "NSImage+ProportionalScaling.h"

#define OVERLAY_BORDER_RADIUS 3.0f

NSString *CTPasteboardItemRepresentationString = @"stringRepresentation";
NSString *CTPasteboardItemRepresentationAttributedString = @"attributedStringRepresentation";
NSString *CTPasteboardItemRepresentationImage = @"imageRepresentation";

@implementation CTPasteboardItemDataRepresentationView

@synthesize type, object;

- (id)initWithFrame:(NSRect)frame type:(NSString *)theType object:(id)theObject {
	self = [super initWithFrame:frame];
	if (self) {
		type = theType;
		object = theObject;
	}
	
	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect drawingRect = [self bounds];
	if (type == CTPasteboardItemRepresentationString) {
		NSString *plainText = (NSString *)object;
		[plainText drawInRect:drawingRect withAttributes:nil];
	}
	else if (type == CTPasteboardItemRepresentationAttributedString) {
		NSAttributedString *richText = (NSAttributedString *)object;
		[richText drawInRect:drawingRect];
	}
	else if (type == CTPasteboardItemRepresentationImage) {
		NSImage *image = (NSImage *)object;
		[[image imageByScalingProportionallyToSize:[self bounds].size] drawInRect:drawingRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
	}
	else {
		[@"No Representation" drawInRect:drawingRect withAttributes:nil];
	}
}

@end
