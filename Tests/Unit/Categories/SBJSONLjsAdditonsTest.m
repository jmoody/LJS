#import "LjsTestCase.h"
#import "SBJSON+LjsAdditions.h"

static NSString *const kJsonArrStr = @"[\"a\",\"b\",\"c\"]";
static NSString *const kJsonDictStr = @"{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}";

@interface SBJSONLjsAdditonsTest : LjsTestCase {}

@property (nonatomic, copy) NSString *jsonStr;
@property (nonatomic, strong) NSData *jsonArrData;
@property (nonatomic, strong) NSData *jsonDictData;

@end


@implementation SBJSONLjsAdditonsTest

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
  NSString *path = [[NSBundle mainBundle] pathForResource:@"google-places-autocomplete-sample"
                                                   ofType:@"json"];
  GHAssertNotNil(path, @"should be able to find the json file");
  NSError *fileError = nil;
  NSString *str = [NSString stringWithContentsOfFile:path
                                            encoding:NSUTF8StringEncoding
                                               error:&fileError];
  GHAssertNotNil(str, @"string should not be nil for file at path: %@ : %@",
                 path, fileError);
  
  self.jsonStr = str;
  self.jsonArrData = [kJsonArrStr dataUsingEncoding:NSUTF8StringEncoding];
  GHAssertNotNil(self.jsonArrData, @"should be able to create data from %@", kJsonArrStr);
  self.jsonDictData = [kJsonDictStr dataUsingEncoding:NSUTF8StringEncoding];
  GHAssertNotNil(self.jsonDictData, @"should be able to create data from %@", kJsonDictStr);
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  self.jsonStr = nil;
  self.jsonArrData = nil;
  self.jsonDictData = nil;
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}


#pragma mark - Parser Category

- (void) test_parser_object_with_str {
  SBJsonParser *parser = [SBJsonParser new];
  id obj = [parser objectWithString:self.jsonStr];
  GHAssertNotNil(obj, @"should be able to parse str: %@", self.jsonStr);
}


- (void) test_parser_object_with_str_error {
  SBJsonParser *parser = [SBJsonParser new];
  NSString *str = @"foobar";
  id obj = [parser objectWithString:str];
  GHAssertNil(obj, @"should not be able to parse str: %@", str);
  GHAssertNotNil(parser.error, @"parser error string should not be nil");
}

#pragma mark - Array Category

- (void) test_array_to_json_no_error {
  NSArray *array = [self arrayOfAbcStrings];
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *str = [array toJson:hasError ? &error : nil];
  GHAssertEqualStrings(str, kJsonArrStr, @"strings should match");
  GHAssertNil(error, @"error should be nil");
}


- (void) test_array_to_json_error {
  NSArray *array = [self arrayOfDatesTodayTormorrowDayAfter];
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *str = [array toJson:hasError ? &error : nil];
  GHAssertNil(str, @"should not be able to parse silly objects");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}

#pragma mark - Dictionary Category

- (void) test_dict_to_json_no_error {
  NSArray *objs = [self arrayOfAbcStrings];
  NSArray *keys = [self arrayOfAbcStrings];
  NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs
                                                   forKeys:keys];
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *str = [dict toJson:hasError ? &error : nil];
  GHAssertEqualStrings(str, kJsonDictStr, @"strings should match");
  GHAssertNil(error, @"error should be nil");
}


- (void) test_dict_to_json_error {
  NSArray *objs = [self arrayOfDatesTodayTormorrowDayAfter];
  NSArray *keys = [self arrayOfAbcStrings];
  NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs
                                                   forKeys:keys];
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *str = [dict toJson:hasError ? &error : nil];
  GHAssertNil(str, @"string should be nil");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}

#pragma mark - NSString ==> Array Category

- (void) test_array_from_json {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSArray *actual = [kJsonArrStr arrayFromJson:hasError ? &error : nil];
  GHAssertNotNil(actual, @"should be able to create an array");
  [[self arrayOfAbcStrings] mapc:^(NSString *str, NSUInteger idx, BOOL *stop) {
    GHAssertTrue([actual containsObject:str], @"should be able to find %@ in %@",
                 str, actual);
  }];
  GHAssertNil(error, @"error should be nil");
}

- (void) test_array_from_json_parse_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *toParse = @"foobar";
  NSArray *actual = [toParse arrayFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse: %@", toParse);
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}


- (void) test_array_from_json_dict_returned_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSArray *actual = [kJsonDictStr arrayFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse: %@ to an array", kJsonDictStr);
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}

#pragma mark - NSString ==> Dictionary Category

- (void) test_dict_from_json {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSDictionary *actual = [kJsonDictStr dictionaryFromJson:hasError ? &error : nil];
  GHAssertNotNil(actual, @"should be able to create an dictionary");
  [[self arrayOfAbcStrings] mapc:^(NSString *str, NSUInteger idx, BOOL *stop) {
    GHAssertNotNil([actual objectForKey:str], @"should contain value for key %@ in %@",
                   str, actual);
  }];
  GHAssertNil(error, @"error should be nil");
}

- (void) test_dict_from_json_parse_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSString *toParse = @"foobar";
  NSDictionary *actual = [toParse dictionaryFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse: %@", toParse);
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}


- (void) test_dict_from_json_array_returned_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSDictionary *actual = [kJsonArrStr dictionaryFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse: %@ to a dictionary", kJsonArrStr);
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}

#pragma mark - NSData ==> Array Category

- (void) test_array_from_data {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSArray *actual = [self.jsonArrData arrayFromJson:hasError ? &error : nil];
  GHAssertNotNil(actual, @"should be able to create an array");
  [[self arrayOfAbcStrings] mapc:^(NSString *str, NSUInteger idx, BOOL *stop) {
    GHAssertTrue([actual containsObject:str], @"should be able to find %@ in %@",
                 str, actual);
  }];
  GHAssertNil(error, @"error should be nil");
}

- (void) test_array_from_data_parse_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSData *toParse = [@"foobar" dataUsingEncoding:NSUTF8StringEncoding];
  NSArray *actual = [toParse arrayFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse non-json data");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}


- (void) test_array_from_data_dict_returned_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSArray *actual = [self.jsonDictData arrayFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse json dictionary data to array");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}


#pragma mark - NSData ==> Dictionary Category

- (void) test_dict_from_data {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSDictionary *actual = [self.jsonDictData dictionaryFromJson:hasError ? &error : nil];
  GHAssertNotNil(actual, @"should be able to create an dictionary");
  [[self arrayOfAbcStrings] mapc:^(NSString *str, NSUInteger idx, BOOL *stop) {
    GHAssertNotNil([actual objectForKey:str], @"should contain value for key %@ in %@",
                   str, actual);
  }];
  GHAssertNil(error, @"error should be nil");
}

- (void) test_dict_from_data_parse_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSData *toParse = [@"foobar" dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *actual = [toParse dictionaryFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse non-json data");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}


- (void) test_dict_from_data_array_returned_error {
  NSError *error = nil;
  BOOL hasError = [LjsVariates flip];
  NSDictionary *actual = [self.jsonArrData dictionaryFromJson:hasError ? &error : nil];
  GHAssertNil(actual, @"should not be able to parse array data into dictionary");
  if (hasError) {
    GHAssertNotNil(error, @"error should not be nil");
    GHTestLog(@"%@", error);
  }
}



@end
