//
//  JKContextUtil.m
//  QCMobile
//
//  Created by Joris Kluivers on 5/18/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKContextUtil.h"

CGFloat JKPixelsToUnits(id<JKContext> ctx, CGFloat pixels)
{
    return (2.0f / ctx.size.width) * pixels;
}

CGFloat JKUnitsToPixels(id<JKContext> ctx, CGFloat units)
{
    return (ctx.size.width / 2.0f) * units;
}