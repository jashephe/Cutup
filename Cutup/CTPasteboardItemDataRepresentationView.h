//
//  CTPasteboardItemDataRepresentationView.h
//  Cutup
//
//  Created by James Shepherdson on 6/24/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *CTPasteboardItemRepresentationString;
extern NSString *CTPasteboardItemRepresentationAttributedString;
extern NSString *CTPasteboardItemRepresentationImage;

@interface CTPasteboardItemDataRepresentationView : NSView

@property NSString *type;
@property id object;

- (id)initWithFrame:(NSRect)frame type:(NSString *)theType object:(id)theObject;

@end
