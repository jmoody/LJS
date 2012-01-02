
// a1 is always the RECEIVED value
// a2 is always the EXPECTED value
// GHAssertNoErr(a1, description, ...)
// GHAssertErr(a1, a2, description, ...)
// GHAssertNotNULL(a1, description, ...)
// GHAssertNULL(a1, description, ...)
// GHAssertNotEquals(a1, a2, description, ...)
// GHAssertNotEqualObjects(a1, a2, desc, ...)
// GHAssertOperation(a1, a2, op, description, ...)
// GHAssertGreaterThan(a1, a2, description, ...)
// GHAssertGreaterThanOrEqual(a1, a2, description, ...)
// GHAssertLessThan(a1, a2, description, ...)
// GHAssertLessThanOrEqual(a1, a2, description, ...)
// GHAssertEqualStrings(a1, a2, description, ...)
// GHAssertNotEqualStrings(a1, a2, description, ...)
// GHAssertEqualCStrings(a1, a2, description, ...)
// GHAssertNotEqualCStrings(a1, a2, description, ...)
// GHAssertEqualObjects(a1, a2, description, ...)
// GHAssertEquals(a1, a2, description, ...)
// GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
// GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
// GHFail(description, ...)
// GHAssertNil(a1, description, ...)
// GHAssertNotNil(a1, description, ...)
// GHAssertTrue(expr, description, ...)
// GHAssertTrueNoThrow(expr, description, ...)
// GHAssertFalse(expr, description, ...)
// GHAssertFalseNoThrow(expr, description, ...)
// GHAssertThrows(expr, description, ...)
// GHAssertThrowsSpecific(expr, specificException, description, ...)
// GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
// GHAssertNoThrow(expr, description, ...)
// GHAssertNoThrowSpecific(expr, specificException, description, ...)
// GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)

#import "LjsTestCase.h"
#import "LjsJsonRpcReply.h"

#import "SBJson.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


#ifdef JSON_RPC_10
static NSString *MissingVersion = @"{\"result\": 19, \"id\": 3}";
static NSString *CorrectWithResult = @"{\"result\": 19, \"id\": 3}";
static NSString *NoErrorOrResult = @"{\"id\": 3}";
static NSString *ErrorAndResult = @"{\"result\": 19, \"error\": {\"name\":\"JSONRPCError\", \"message\": \"Procedure not found.\", \"errors\":[{\"name\":\"Exception\", \"message\":\"Not a valid format.\"}]}, \"id\": 4}";
static NSString *NoId = @"{\"result\": 19}";
static NSString *InvalidJson = @"{\"id\":null,\"error\":{\"name\":\"JSONRPCError\", \"name\":\"JsonException\", \"message\":\"Cannot import System.String from a JSON Object value.\"}]}";
static NSString *CorrectWithError = @"{\"error\": {\"name\":\"JSONRPCError\", \"message\": \"Procedure not found.\", \"errors\":[{\"name\":\"Exception\", \"message\":\"Not a valid format.\"}]}, \"id\": 4}";


static NSString *IncorrectErrorCodeOrName = @"{\"error\": {\"error-name\":\"JSONRPCError\", \"message\": \"Procedure not found.\", \"errors\":[{\"name\":\"Exception\", \"message\":\"Not a valid format.\"}]}, \"id\": 4}";

static NSString *IncorrectErrorMessage = @"{\"error\": {\"name\":\"JSONRPCError\", \"error-message\": \"Procedure not found.\", \"errors\":[{\"name\":\"Exception\", \"message\":\"Not a valid format.\"}]}, \"id\": 4}";

static NSString *IncorrectErrorWithBadKey = @"{\"error\": {\"name\":\"JSONRPCError\", \"message\": \"Procedure not found.\", \"additional-info\":[{\"name\":\"Exception\", \"message\":\"Not a valid format.\"}]}, \"id\": 4}";

#else
static NSString *MissingVersion = @"{\"result\": 19, \"id\": 3}";
static NSString *CorrectWithResult = @"{\"jsonrpc\": \"2.0\", \"result\": 19, \"id\": 3}";

static NSString *NoErrorOrResult = @"{\"jsonrpc\": \"2.0\", \"id\": 3}";

static NSString *ErrorAndResult = @"{\"jsonrpc\": \"2.0\", \"result\": 19, \"error\": {\"code\": -32601, \"message\": \"Procedure not found.\"}, \"id\": 4}";

static NSString *NoId = @"{\"jsonrpc\": \"2.0\", \"result\": 19}";

static NSString *CorrectWithError = @"{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"message\": \"Procedure not found.\"}, \"id\": 4}";

static NSString *CorrectWithErrorAndData = @"{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"message\": \"Procedure not found.\", \"data\": \"Some data.\"}, \"id\": 4}";

static NSString *IncorrectErrorCodeOrName = @"{\"jsonrpc\": \"2.0\", \"error\": {\"error-code\": -32601, \"message\": \"Procedure not found.\", \"data\": \"Some data.\"}, \"id\": 4}";

static NSString *IncorrectErrorMessage = @"{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"error\": \"Procedure not found.\", \"data\": \"Some data.\"}, \"id\": 4}";

static NSString *IncorrectErrorWithBadKey = @"{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"error\": \"Procedure not found.\", \"additional-info\": \"Some data.\"}, \"id\": 4}";

static NSString *InvalidJson = @"{\"id\":null,\"error\":{\"name\":\"JSONRPCError\", \"name\":\"JsonException\", \"message\":\"Cannot import System.String from a JSON Object value.\"}]}";
#endif

@interface LjsJsonRpcReplyTests : LjsTestCase {}
@end

@implementation LjsJsonRpcReplyTests

//- (id) init {
//  self = [super init];
//  if (self) {
//    // Initialization code here.
//  }
//  return self;
//}
//
//- (void) dealloc {
//  [super dealloc];
//}

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  // Run at end of all tests in the class
}

- (void) setUp {
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
}  

- (void) test_replyWasValidJson {
  
  LjsJsonRpcReply *reply;
  
  reply =  [[LjsJsonRpcReply alloc]
                              initWithJsonReply:CorrectWithResult];
  GHAssertTrue([reply replyWasValidJson], nil);
  GHAssertNil(reply.jsonParseError, nil);
    
}

- (void) test_replyWasValidRpc {
  NSError *parseError;
#ifdef JSON_RPC_10
  // nop
#else
  NSError* jsonRpcFormatError;
#endif
  
  NSString *non20jsonRpcError;

  LjsJsonRpcReply *reply;
  BOOL result;
  
  reply =  [[LjsJsonRpcReply alloc]
                              initWithJsonReply:MissingVersion];
  result = [reply replyWasValidRpc];
#if JSON_RPC_10
  GHAssertTrue(result, nil);
  GHAssertNil(reply.jsonRpcFormatError, nil);
#else
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);
  
#endif
  
  
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithResult];
  result = [reply replyWasValidRpc];
  GHAssertTrue(result, nil);
  GHAssertNil(reply.jsonRpcFormatError, nil);

   
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:NoErrorOrResult];
  result = [reply replyWasValidRpc];
  
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);
  
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:ErrorAndResult];
  result = [reply replyWasValidRpc];
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);
  
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:NoId];
  result = [reply replyWasValidRpc];
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);

  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithError];
  result = [reply replyWasValidRpc];
  GHAssertTrue(result, nil);
   GHAssertNil(reply.jsonRpcFormatError, nil);

#ifdef JSON_RPC_10
  // nop
#else
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithErrorAndData];
  result = [reply replyWasValidRpc];
  GHAssertTrue(result, nil);
  GHAssertNil(reply.jsonRpcFormatError, nil);
#endif
  
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:IncorrectErrorCodeOrName];
  result = [reply replyWasValidRpc];
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);

  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:IncorrectErrorMessage];
  result = [reply replyWasValidRpc];
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);

  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:IncorrectErrorWithBadKey];
  result = [reply replyWasValidRpc];
  GHAssertFalse(result, nil);
  GHAssertNotNil(reply.jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@ : %@", [reply.jsonRpcFormatError code], 
            [reply.jsonRpcFormatError localizedDescription],
            [reply.jsonRpcFormatError localizedFailureReason]);
  
  
  
  reply = [[LjsJsonRpcReply alloc]
            initWithJsonReply:InvalidJson];
  GHAssertFalse([reply replyWasValidJson], nil);
  GHAssertNotNil(reply.jsonParseError, nil);
  parseError = reply.jsonParseError;
  GHTestLog(@"error = %d : %@", [parseError code], [parseError localizedDescription]);
  
  
  // has escaped characters
  non20jsonRpcError = @"{\"id\":\"1\",\"error\":{\"name\":\"JSONRPCError\",\"message\":\"Value cannot be null or empty.\r\nParameter name: userName\",\"errors\":[{\"name\":\"ArgumentException\",\"message\":\"Value cannot be null or empty.\r\nParameter name: userName\"}]}}";
  
  reply = [[LjsJsonRpcReply alloc]
            initWithJsonReply:non20jsonRpcError];
  parseError = reply.jsonParseError;
  GHAssertNotNil(parseError, nil);
  GHTestLog(@"error = %d : %@", [parseError code], [parseError localizedDescription]);
  
  
#ifdef JSON_RPC_10
  // nop
#else
  // has invalid error dictionary
  non20jsonRpcError = @"{\"id\":\"1\",\"error\":{\"name\":\"JSONRPCError\",\"message\":\"Value cannot be null or empty.  Parameter name: userName\",\"errors\":[{\"name\":\"ArgumentException\",\"message\":\"Value cannot be null or empty.  Parameter name: userName\"}]}}";
  reply = [[LjsJsonRpcReply alloc]
            initWithJsonReply:non20jsonRpcError];
  jsonRpcFormatError = reply.jsonRpcFormatError;
  GHAssertNotNil(jsonRpcFormatError, nil);
  GHTestLog(@"error = %d : %@", [jsonRpcFormatError code], [jsonRpcFormatError localizedDescription]);
#endif
}

- (void) test_replyContainedRpcError {
  LjsJsonRpcReply *reply;
  BOOL result;
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithResult];
  result = [reply replyHasRpcError];
  GHAssertFalse(result, nil);
 

  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithError];
  result = [reply replyHasRpcError];
  GHAssertTrue(result, nil);
}

- (void) test_replyContainedRpcResult {
  LjsJsonRpcReply *reply;
  BOOL result;
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithResult];
  result = [reply replyHasResult];
  GHAssertTrue(result, nil);
  
  reply =  [[LjsJsonRpcReply alloc]
             initWithJsonReply:CorrectWithError];
  result = [reply replyHasResult];
  GHAssertFalse(result, nil);
}

@end
