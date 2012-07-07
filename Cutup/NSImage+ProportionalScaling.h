//
//  NSImage+ProportionalScaling.h
//  Cutup
//
//  Created by James Shepherdson on 6/24/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (ProportionalScaling)

- (NSImage *)imageByScalingProportionallyToSize:(NSSize)targetSize;

@end
