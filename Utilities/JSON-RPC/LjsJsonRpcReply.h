// Copyright (c) 2010 Little Joy Software
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
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import "SBJson.h"

extern NSString *LjsJsonJsonRpcKey;
extern NSString *LjsJsonJsonRpcRequiredVersion;
extern NSString *LjsJsonReplyErrorKey;
extern NSString *LjsJsonRpcReplyIdKey;
extern NSString *LjsJsonRpcReplyResultKey;

extern NSString *LjsJsonRpcReplyErrorMessageKey;
extern NSString *LjsJsonRpcReplyErrorCodeOrNameKey;
extern NSString *LjsJsonRpcReplyErrorDataOrErrorsKey;
extern NSString *LjsJsonRpcReplyErrorDataUserInfoKey;

extern NSInteger const LjsJsonRpcReplyMissingId;
extern NSString *LjsJsonRpcReplyErrorDomain;

/**
 LjsJsonRpcReply parses a JSON-RPC 1.0 or JSON 2.0 string (reply), validates
 the reply for format and specification (1.0 or 2.0) and generates the 
 necessary NSErrors.
 
 This class provides backwards compatibility to JSON-RPC 1.0 by using a
 compiler macro: JSON_RPC_10.  If you want to use JSON-RPC 1.0, add
 JSON_RPC_10 to your Precompiler Macros not Used in Precompilation build
 settings.  Nothing special needs to be done if you are using JSON-RPC 2.0.
 
 To use, pass a JSON-RPC formatted string to the `initWithJsonReply:` method
 and use the _relyWas_ and _replyHas_ methods to determine the success or
 failure of the parsing.  If there are no errors associated with the raw
 JSON parsing then the replyDict property will contain either:
 
 1. if the reply contained an error - the error details in dictionary format
 2. if the reply contained no error - the result of the JSON-RPC call
 
 Use the follow keys for accessing information in the dictionary:
 
 * LjsJsonJsonRpcKey;
 * LjsJsonJsonRpcRequiredVersion;
 * LjsJsonReplyErrorKey;
 * LjsJsonRpcReplyIdKey;
 * LjsJsonRpcReplyResultKey;
 * LjsJsonRpcReplyErrorMessageKey;
 * LjsJsonRpcReplyErrorCodeOrNameKey;
 * LjsJsonRpcReplyErrorDataOrErrorsKey;
 * LjsJsonRpcReplyErrorDataUserInfoKey;
 
 */
@interface LjsJsonRpcReply : NSObject 

/** @name Properties */

/**
 if non-nil, indicates the reply contained an error key
 */
@property (nonatomic, strong) NSError *errorFoundInReply;

/**
 if non-nil, indicates the reply contained a json-rpc formatting error, such
 as an invalid json-rpc key
 */
@property (nonatomic, strong) NSError *jsonRpcFormatError;

/**
 if non-nil, indicates there was a problem parsing the json - the error will
 be generated by the SBJSON SBJsonParser objectWithString: method.
 */
@property (nonatomic, strong) NSError *jsonParseError;

/**
 the parser
 */
@property (nonatomic, strong) SBJsonParser *parser;

/**
 the result of the parsing
 */
@property (nonatomic, strong) NSDictionary *replyDict;

/** @name Initialization */

/**
 This method populates all the properties.
 
 @return an initialized receiver which is ready to accept queries about 
 errors found, validity, and results
 @param json a string in JSON-RPC 1.0 or 2.0 format
 */
- (id) initWithJsonReply:(NSString *) json;

/** @name Validating */

/**
 @return true iff the reply was valid json
 */
- (BOOL) replyWasValidJson;

/**
 If you are using JSON-RPC 1.0, you need to be sure to define a compiler
 macro JSON_RPC_10.  
 @return true iff the reply was valid JSON-RPC
 */
- (BOOL) replyWasValidRpc;

/**
 @return true iff the reply contained a JSON-RPC error message
 */
- (BOOL) replyHasRpcError;

/**
 @return true iff the reply contained a JSON-RPC result (not an error)
 */
- (BOOL) replyHasResult;

/** @name Reply Identification */

/**
 @return the reply id contained in the reply
 @warning this method is only valid for JSON-RPC 2.0
 */
- (NSInteger) replyId;

/** @name Error Generation */
/**
 @return an error using the error dictionary.
 @warning this method does not need to be called directly - it is a convenience
 method for the class
 @param errorDict the error dictionary from the reply
 */
- (NSError *) errorWithDictionary:(NSDictionary *) errorDict;


@end
