//
//  CTShortcut.h
//  Cutup
//
//  Created by James Shepherdson on 6/14/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTShortcut : NSObject

@property (strong) NSString *characters;
@property unsigned short keyCode;
@property NSUInteger modifierFlags;

@end
