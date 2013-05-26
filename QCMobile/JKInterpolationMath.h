//
//  JKInterpolationMath.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/9/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

CGFloat JKLinearInterpolation(CGFloat t, CGFloat start, CGFloat end);

CGFloat JKQuadraticInInterpolation(CGFloat t, CGFloat start, CGFloat end);
CGFloat JKQuadraticOutInterpolation(CGFloat t, CGFloat start, CGFloat end);
CGFloat JKQuadraticInOutInterpolation(CGFloat t, CGFloat start, CGFloat end);

CGFloat JKCubicInInterpolation(CGFloat t, CGFloat start, CGFloat end);
CGFloat JKCubicOutInterpolation(CGFloat t, CGFloat start, CGFloat end);
CGFloat JKCubicInOutInterpolation(CGFloat t, CGFloat start, CGFloat end);

CGFloat JKExponentialInInterpolation(CGFloat t, CGFloat start, CGFloat end);
CGFloat JKExponentialOutInterpolation(CGFloat t, CGFloat start, CGFloat end);


