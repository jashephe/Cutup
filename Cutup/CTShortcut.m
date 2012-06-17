//
//  CTShortcut.m
//  Cutup
//
//  Created by James Shepherdson on 6/14/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import "CTShortcut.h"

@implementation CTShortcut

@synthesize characters, keyCode, modifierFlags;

- (id)init {
	self = [super init];
	if (self) {
		characters = [[NSString alloc] initWithString:@""];
	}
	return self;
}

@end
