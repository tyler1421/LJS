// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTextAndFont.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsTextAndFont


+ (CGFloat) heightWithMessageString:(NSString *) aMessage
                           withFont:(UIFont *) aFont
                              width:(CGFloat) aWidth
                          minHeight:(CGFloat) aMinHeight {
  CGSize textSize = CGSizeMake(aWidth, CGFLOAT_MAX);
  CGSize size = [aMessage sizeWithFont:aFont
                     constrainedToSize:textSize
                         lineBreakMode:UILineBreakModeWordWrap];
  
  CGFloat result = MAX(size.height, aMinHeight);
  return result;
}

+ (CGFloat) heightWithString:(NSString *) aString
                        font:(UIFont *) aFont {
  CGSize size = [aString sizeWithFont:aFont];
  return size.height;
}

+ (CGRect) frameWithFont:(UIFont *) aFont 
                       x:(CGFloat) x 
                       y:(CGFloat) y 
                       w:(CGFloat) w {
  return CGRectMake(x, y, w, [LjsTextAndFont heightWithString:@"ABC"
                                                         font:aFont]);
}


@end

@implementation LjsLabelAttributes

@synthesize lineHeight;
@synthesize labelHeight;
@synthesize numberOfLines;

- (id) initWithString:(NSString *) aString
                 font:(UIFont *) aFont
           labelWidth:(CGFloat) aLabelWidth {
  self = [super init];
  if (self != nil) {
    CGSize oneLineSize = [aString sizeWithFont:aFont];
    self.lineHeight = oneLineSize.height;
    CGSize labelSize = [aString sizeWithFont:aFont
                           constrainedToSize:CGSizeMake(aLabelWidth, CGFLOAT_MAX)
                               lineBreakMode:UILineBreakModeCharacterWrap];
    self.labelHeight = labelSize.height;
    self.numberOfLines = (NSUInteger) self.labelHeight / self.lineHeight;
    
  }
  return self;
}

@end










