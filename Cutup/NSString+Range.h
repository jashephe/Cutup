//
//  NSString+Range.h
//  Cutup
//
//  Created by James Shepherdson on 6/5/12.
//  Copyright (c) 2012 James Shepherdson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Range)

- (NSInteger)indexOfString:(NSString *)text;
- (NSInteger)indexOfChar:(char)character;

@end
