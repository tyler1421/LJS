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

#import "LjsScrollView.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsScrollView


#pragma mark Memory Management

- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *) event {
//  DDLogDebug(@"hit: %@", NSStringFromCGPoint(point));
//  DDLogDebug(@"event = %@", event);
  UIView *view = [super hitTest:point withEvent:event];
  if (view != self) {
    DDLogDebug(@"view is not self");
  } else {
    DDLogDebug(@"view is self");
  }
  NSSet *all = [event allTouches];
  DDLogDebug(@"all = %@", all);
  NSSet *forSelf = [event touchesForView:self];
  DDLogDebug(@"for self = %@", forSelf);
  NSSet *forlabel = [event touchesForView:view];
  DDLogDebug(@"for view = %@", forlabel);

  
//  for (UIView *subview in self.subviews) {
//    if (view != nil && view.userInteractionEnabled) {
//      break; 
//    } else {
//      CGPoint newPoint = [self convertPoint:point toView:subview];
//      view = [subview hitTest:newPoint withEvent:event];
//    }
//  }
//  DDLogDebug(@"view = %@", view);
  return view;
}

//- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//  DDLogDebug(@"hit: %@", NSStringFromCGPoint(point));
//  UIView *result;
//  for (UIView *child in self.subviews) {
//    if ([child pointInside:point withEvent:event]) {
//      if ((result = [child hitTest:point withEvent:event]) != nil) {
//        self.delaysContentTouches = NO;
//        break;
//      } else {
//        self.delaysContentTouches = YES;
//      }
//    }
//  }
//  return [super hitTest:point withEvent:event];
//}
//
/*
 - (UIView )hitTest:(CGPoint)point withEvent:(UIEvent )event;
 {
 UIView *view = [super hitTest:point withEvent:event];
 for (UIView *subview in self.subviews) {
 if (view != nil &&
 view.userInteractionEnabled) break;
 CGPoint newPoint = [self convertPoint:point toView:subview];
 view = [subview hitTest:newPoint withEvent:event];
 }
 return view;
 }
 */

  


@end
