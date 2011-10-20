#import "LjsLog.h"
#import "HTTPLogging.h"


#undef HTTP_LOG_ERROR   
#undef HTTP_LOG_WARN    
#undef HTTP_LOG_INFO    
#undef HTTP_LOG_VERBOSE


#undef HTTP_LOG_ASYNC_ERROR   
#undef HTTP_LOG_ASYNC_WARN    
#undef HTTP_LOG_ASYNC_INFO    
#undef HTTP_LOG_ASYNC_VERBOSE 
   

#undef HTTPLogError(frmt, ...)
#undef HTTPLogWarn(frmt, ...) 
#undef HTTPLogInfo(frmt, ...)
#undef HTTPLogVerbose(frmt, ...)
      
#undef HTTPLogCError(frmt, ...) 
#undef HTTPLogCWarn(frmt, ...) 
#undef HTTPLogCInfo(frmt, ...)  
#undef HTTPLogCVerbose(frmt, ...) 

#define HTTP_LOG_FATAL   (httpLogLevel & LOG_FLAG_FATAL)
#define HTTP_LOG_ERROR   (httpLogLevel & LOG_FLAG_ERROR)
#define HTTP_LOG_WARN    (httpLogLevel & LOG_FLAG_WARN)
#define HTTP_LOG_NOTICE  (httpLogLevel & LOG_FLAG_NOTICE)
#define HTTP_LOG_INFO    (httpLogLevel & LOG_FLAG_INFO)
#define HTTP_LOG_DEBUG   (httpLogLevel & LOG_FLAG_DEBUG)


// Configure asynchronous logging.

#define HTTP_LOg_ASYNC_FATAL   ( NO && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_ERROR   ( NO && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_WARN    (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_NOTICE  (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_INFO    (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_DEBUG   (YES && HTTP_LOG_ASYNC_ENABLED)

// Define logging primitives.

#define HTTPLogFatal(frmt, ...)    LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_ERROR,   httpLogLevel, LOG_FLAG_FATAL,  \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogError(frmt, ...)    LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_ERROR,   httpLogLevel, LOG_FLAG_ERROR,  \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogWarn(frmt, ...)     LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_WARN,    httpLogLevel, LOG_FLAG_WARN,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogNotice(frmt, ...)     LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_WARN,    httpLogLevel, LOG_FLAG_NOTICE,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogInfo(frmt, ...)     LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_INFO,    httpLogLevel, LOG_FLAG_INFO,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogDebug(frmt, ...)  LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_VERBOSE, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCFatal(frmt, ...)      LOG_C_MAYBE(HTTP_LOG_ASYNC_ERROR,  httpLogLevel, LOG_FLAG_FATAL,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCError(frmt, ...)      LOG_C_MAYBE(HTTP_LOG_ASYNC_ERROR,  httpLogLevel, LOG_FLAG_ERROR,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCWarn(frmt, ...)       LOG_C_MAYBE(HTTP_LOG_ASYNC_WARN,   httpLogLevel, LOG_FLAG_WARN,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCNotice(frmt, ...)       LOG_C_MAYBE(HTTP_LOG_ASYNC_WARN,   httpLogLevel, LOG_FLAG_NOTICE,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCInfo(frmt, ...)       LOG_C_MAYBE(HTTP_LOG_ASYNC_INFO,   httpLogLevel, LOG_FLAG_INFO,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCDebug(frmt, ...)    LOG_C_MAYBE(HTTP_LOG_ASYNC_VERBOSE, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)



