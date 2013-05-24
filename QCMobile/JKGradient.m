//
//  JKGradient.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/24/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKGradient.h"
#import "JKContextUtil.h"

typedef NS_ENUM(NSInteger, JKGradientDirection) {
    JKVerticalUpside = 0,
    JKHorizontalRightside,
    JKVerticalDownside,
    JKHorizontalLeftside
};

BOOL JKGradientVertical(JKGradientDirection direction) {
    return direction == JKVerticalUpside || direction == JKVerticalDownside;
}

@implementation JKGradient

@dynamic inputDirection, inputColor1, inputColor2;

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *)key
{
    if ([key hasPrefix:@"inputColor"]) {
        return @{ JKPortAttributeTypeKey: JKPortTypeColor };
    }
    
    return nil;
}

- (BOOL) isRenderer
{
    return YES;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _numberofPoints = state[@"numberOfPoints"];
        _clearDepthBuffer = [state[@"clearDepthBuffer"] boolValue];
    }
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    // draws a sprite of 2 x numberOfPoints
    
    NSInteger direction = [self.inputDirection integerValue];
    NSInteger numberOfPoints = [self.numberofPoints integerValue];
    
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *positions = [NSMutableArray array];
    
    CGFloat unitWidth = 2.0f;
    CGFloat unitHeight = JKPixelsToUnits(context, context.size.height);
    
    for (int i=1; i<=numberOfPoints; i++) {
        int j = i;
        if (direction == JKVerticalUpside || direction == JKHorizontalRightside) {
            // reverse colors and points
            j = numberOfPoints - (i - 1);
        }
        
        NSString *colorKey = [NSString stringWithFormat:@"inputColor%d", j];
        NSString *positionKey = [NSString stringWithFormat:@"inputPosition%d", j];
        
        [colors addObject:[self valueForInputKey:colorKey]];
        if (i == 1) {
            [positions addObject:@(0.0f)];
        } else if (i == numberOfPoints) {
            [positions addObject:@(1.0f)];
        } else {
            [positions addObject:[self valueForInputKey:positionKey]];
        }
    }
    
    GLKVector3 *uniqueVertices = malloc(sizeof(GLKVector3) * numberOfPoints * 2);
    GLKVector4 *uniqueColors = malloc(sizeof(GLKVector4) * numberOfPoints * 2);
    
    int x, y;
    CIColor *color;
    for (int i=0; i<numberOfPoints; i++) {
        color = [colors objectAtIndex:i];
        
        if (JKGradientVertical(direction)) {
            x = (unitWidth / -2.0f);
            y = (unitHeight / -2.0f) + [[positions objectAtIndex:i] floatValue] * unitHeight;
        } else {
            x = (unitWidth / -2.0f) + [[positions objectAtIndex:i] floatValue] * unitWidth;
            y = (unitHeight / -2.0f);
        }
        
        uniqueVertices[i*2] = GLKVector3Make(x, y, 0);
        
        if (JKGradientVertical(direction)) {
            x = (unitWidth / 2.0f);
        } else {
            y = (unitHeight / 2.0f);
        }
        
        uniqueVertices[i*2+1] = GLKVector3Make(x, y, 0);
        
        uniqueColors[i*2] = GLKVector4Make(color.red, color.green, color.blue, color.alpha);
        uniqueColors[i*2+1] = GLKVector4Make(color.red, color.green, color.blue, color.alpha);
    }
    
    GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
    [effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, uniqueVertices);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, uniqueColors);
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, numberOfPoints * 2);
    
    glDisable(GL_BLEND);

    
    free(uniqueVertices);
    free(uniqueColors);
    
    if (self.clearDepthBuffer) {
        glClear(GL_DEPTH_BUFFER_BIT);
    }
}

@end
