// Copyright 2011 The Little Joy Software Company. All rights reserved.
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

#import "LjsFileUtilities.h"
#import "Lumberjack.h"
#include "TargetConditionals.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/**
 LjsFileUtilities provides class methods to help with common file operations.
 */
@implementation LjsFileUtilities

/**
 ensures directory exists at path
 @return true iff directory was created or exists
 @param path the directory path
 @param fileManager the file manager to use
 */
+ (BOOL) ensureSaveDirectory:(NSString *) path existsWithManager:(NSFileManager *) fileManager {
  NSError *error = nil;
  BOOL fileExists, result;
  fileExists = [fileManager fileExistsAtPath:path];
  if (fileExists == NO) {
    result = [fileManager createDirectoryAtPath:path
                    withIntermediateDirectories:YES 
                                     attributes:nil
                                          error:&error];
    if (result == YES) {
      DDLogDebug(@"successfully created: %@", path);
    } else {
      DDLogDebug(@"attept to create save directory failed: %@", error);
      
    }
  } else {
    DDLogDebug(@"save directory exists: %@", path);
    result = YES;
  }
  return result;
}

/**
 wrapper around the NSSearchPathDirectoriesInDomains - works for both iOS and
 MacOS
 @return the path to the standard document directory
 */
+ (NSString *) findDocumentDirectoryPath {
  NSArray *dirPaths = 
  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                      NSUserDomainMask, 
                                      YES);
  return [dirPaths objectAtIndex:0];
}


/**
 this method can be useful for controlling the behavior of NSOpenPanel
 
 childPath does not need to exist for this method to work
 
 @warning will have unexpected behavior if childPath is "/"
 
 @return the parent directory of the child path
 @param childPath a file or directory path
 */
+ (NSString *) parentDirectoryForPath:(NSString *) childPath {
  NSArray *tokens = [childPath pathComponents];
  NSString *parentDirectory;
  NSMutableArray *array = [NSMutableArray arrayWithArray:tokens];
  
  if ([array count] > 1) {
    [array removeLastObject];
  } 
  parentDirectory = [NSString pathWithComponents:array];
  return parentDirectory;
}

#if !TARGET_OS_IPHONE
/**
 creates a NSOpenPanel and returns the users selection as a path string.
 @return a string representing the path to the file or directory of the user's
 selection
 @param aPrompt the title of the select button - should be localized
 @param aTitle the title of the panel - should be localized
 @param aLastDirectory the last directory that was opened by nsopenpanel - if 
 this directory exists, the panel will open to this directory
 @param fallbackDirectory if the last directory does not exist, then this the
 open panel will open to this directory
 @param aDefaultsKeyOrNil iff non-nil will use this key to store the users
 selection in NSUserDefaults
 */
+ (NSString *) pathFromOpenPanelWithPrompt:(NSString *) aPrompt 
                                     title:(NSString *) aTitle
                             lastDirectory:(NSString *) aLastDirectory 
                         fallBackDirectory:(NSString *) fallbackDirectory
                          defaultsKeyOrNil:(NSString *) aDefaultsKeyOrNil {

  NSString *result = nil;
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:NO];
  [openPanel setPrompt:aPrompt];
  [openPanel setCanChooseDirectories:YES];
  [openPanel setCanCreateDirectories:YES];
  [openPanel setAllowsMultipleSelection:NO];
  [openPanel setTitle:aTitle];
  
  NSString *lastDirectoryRoot = aLastDirectory;
  
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDirectory;
  if (!([fm fileExistsAtPath:lastDirectoryRoot isDirectory:&isDirectory] && isDirectory)) {
    lastDirectoryRoot = fallbackDirectory;
  }
  
  [openPanel setDirectoryURL:[NSURL fileURLWithPath:lastDirectoryRoot]];
  NSInteger response = [openPanel runModal];
  
  if (response == NSOKButton) {
    NSString *savePath = [[[openPanel URLs] objectAtIndex:0] path];
    if (aDefaultsKeyOrNil != nil) {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      
      [defaults setObject:savePath forKey:aDefaultsKeyOrNil];
    }
    result = savePath;
  }
  return result;
}
#endif


/**
 useful method for getting NSOpenPanel to open at the appropriate directory and
 directory level
 @return a path using value in NSUserDefaults for key aDefaultsKey or to a
 fallback directory
 @param aDefaultsKey a key to use to look up last directory path - can be nil
 @param aFallbackDirectory a fall back directory to use if there is no entry in
 NSUserDefaults for the key or the key is nil
 */
+ (NSString *) lastDirectoryPathWithDefaultsKey:(NSString *) aDefaultsKey
                              fallbackDirectory:(NSString *) aFallbackDirectory {
  
  NSString *result;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *lastDirectoryPath = [defaults stringForKey:aDefaultsKey];
  
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDirectory;
  if (!([fm fileExistsAtPath:lastDirectoryPath isDirectory:&isDirectory] && isDirectory)) {
    result = aFallbackDirectory;
    [defaults setObject:aFallbackDirectory forKey:aDefaultsKey];
  } else {
    result = lastDirectoryPath;
  } 
  return result;
}



@end
