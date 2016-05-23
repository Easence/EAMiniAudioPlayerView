//
//  UIButton+EAButtonExtendedHit.m
//  EAAudioPlayerView
//
//  Created by EA.Huang on 5/19/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import "UIButton+EAButtonExtendedHit.h"

@import ObjectiveC.runtime;

static const void *hitInsetsKey = &hitInsetsKey;

@implementation UIButton (EAButtonExtendedHit)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(!self.hitEdgeInsets.top && !self.hitEdgeInsets.bottom && !self.hitEdgeInsets.left && !self.hitEdgeInsets.right)
    {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets
{
    objc_setAssociatedObject(self, hitInsetsKey, [NSValue valueWithUIEdgeInsets:hitEdgeInsets], OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)hitEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, hitInsetsKey);
    return [value UIEdgeInsetsValue];
}
@end
