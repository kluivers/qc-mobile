//
//  JKMouseInteraction.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/25/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKMouseInteraction.h"

#import "JKContext.h"
#import "JKContextUtil.h"

#import "JKConnection.h"

@interface JKPatch (JKMouseInteractionPrivate)
@property(nonatomic, readonly) NSArray *connections;
- (JKPatch *) patchWithKey:(NSString *)key;
@end

@interface JKMouseInteraction ()
@property(nonatomic, strong) NSNumber *outputMouseDown;
@property(nonatomic, strong) NSNumber *outputClickCount;
@property(nonatomic, strong) NSNumber *outputXDrag;
@property(nonatomic, strong) NSNumber *outputYDrag;
@end

@implementation JKMouseInteraction {
    BOOL touching;
    CGPoint touchStart;
}

@dynamic outputMouseDown, outputClickCount, outputXDrag, outputYDrag;

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    JKPatch *interactionPatch = nil;
    NSArray *connections = [self.parent connections];
    for (JKConnection *conn in connections) {
        if ([conn.sourceNode isEqualToString:self.key] && [conn.sourcePort isEqualToString:@"outputInteraction"]) {
            interactionPatch = [self.parent patchWithKey:conn.destinationNode];
            break;
        }
    }
    
    if (!interactionPatch) {
        // no tap target
        return;
    }
    
    UITouch *touch = [context.touches anyObject];
    
    if (!touch) {
        touching = NO;
    }
    
    if (touching) {
        // TODO: proper 'API' access to view, or location in view
        
        CGPoint currLocation = [touch locationInView:(UIView *)context];
        
        self.outputXDrag = @(JKPixelsToUnits(context, currLocation.x - touchStart.x));
        self.outputYDrag = @(JKPixelsToUnits(context, currLocation.y - touchStart.y));
    } else if (touch) {
        touching = YES;
        touchStart = [touch locationInView:(UIView *)context];
        
        self.outputXDrag = @0;
        self.outputYDrag = @0;
    }
    
    self.outputMouseDown = @((touch != nil));
    self.outputClickCount = @(touch.tapCount);
}

@end
