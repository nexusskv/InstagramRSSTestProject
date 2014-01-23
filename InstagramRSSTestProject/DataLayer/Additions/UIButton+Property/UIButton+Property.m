//
//  UIButton+Property.m
//  InstagramRSSTestProject
//
//  Created by rost on 19.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "UIButton+Property.h"
#import <objc/runtime.h>


@implementation UIButton(Property)

static char UIB_PROPERTY_KEY;

@dynamic longTag;


#pragma mark - Setter Tag
- (void)setLongTag:(NSObject *)longTag
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, longTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark -


#pragma mark - Getter Tag
- (NSObject *)longTag
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}
#pragma mark -

@end