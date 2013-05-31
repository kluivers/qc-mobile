//
//  JKSplitter.h
//  QCMobile
//
//  Created by Joris Kluivers on 5/12/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import "JKPatch.h"

@interface JKSplitter : JKPatch

@property(nonatomic, strong) id input;
@property(nonatomic, readonly) id output;

@end
