#import "LjsLog.h"
#import "HTTPLogging.h"

#undef HTTP_LOG_ERROR
#undef HTTP_LOG_WARN
#undef HTTP_LOG_INFO    
#undef HTTP_LOG_VERBOSE 
#undef HTTP_LOG_TRACE  

#undef HTTP_LOG_ASYNC_ERROR 
#undef HTTP_LOG_ASYNC_WARN  
#undef HTTP_LOG_ASYNC_INFO  
#undef HTTP_LOG_ASYNC_VERBOSE 
#undef HTTP_LOG_ASYNC_TRACE 

// Define logging primitives.

#undef HTTPLogError
#undef HTTPLogWarn
#undef HTTPLogInfo
#undef HTTPLogVerbose
#undef HTTPLogTrace 
#undef HTTPLogTrace2

#undef HTTPLogCError
#undef HTTPLogCWarn
#undef HTTPLogCInfo
#undef HTTPLogCVerbose
#undef HTTPLogCTrace
#undef HTTPLogCTrace2


#define HTTP_LOG_FATAL   (httpLogLevel & LOG_FLAG_ERROR)
#define HTTP_LOG_ERROR   (httpLogLevel & LOG_FLAG_ERROR)
#define HTTP_LOG_WARN    (httpLogLevel & LOG_FLAG_WARN)
#define HTTP_LOG_NOTICE  (httpLogLevel & LOG_FLAG_NOTICE)
#define HTTP_LOG_INFO    (httpLogLevel & LOG_FLAG_INFO)
#define HTTP_LOG_DEBUG   (httpLogLevel & LOG_FLAG_DEBUG)
#define HTTP_LOG_VERBOSE  (httpLogLevel & LOG_FLAG_DEBUG)
#define HTTP_LOG_TRACE   (httpLogLevel & LOG_FLAG_TRACE)

#define HTTP_LOG_ASYNC_FATAL   ( NO && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_ERROR   ( NO && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_WARN    (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_NOTICE  (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_INFO    (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_DEBUG   (YES && HTTP_LOG_ASYNC_ENABLED)
#define HTTP_LOG_ASYNC_TRACE   (YES && HTTP_LOG_ASYNC_ENABLED)

#define HTTPLogFatal(frmt, ...)    LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_FATAL,   httpLogLevel, LOG_FLAG_FATAL,  \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogError(frmt, ...)    LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_ERROR,   httpLogLevel, LOG_FLAG_ERROR,  \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogWarn(frmt, ...)     LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_WARN,    httpLogLevel, LOG_FLAG_WARN,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogNotice(frmt, ...)    LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_NOTICE,   httpLogLevel, LOG_FLAG_NOTICE,  \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogInfo(frmt, ...)     LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_INFO,    httpLogLevel, LOG_FLAG_INFO,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogDebug(frmt, ...)  LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_DEBUG, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogVerbose(frmt, ...)  LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_DEBUG, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogTrace()             LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_TRACE,   httpLogLevel, LOG_FLAG_TRACE, \
HTTP_LOG_CONTEXT, @"%@[%p]: %@", THIS_FILE, self, THIS_METHOD)

#define HTTPLogTrace2(frmt, ...)   LOG_OBJC_MAYBE(HTTP_LOG_ASYNC_TRACE,   httpLogLevel, LOG_FLAG_TRACE, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)


#define HTTPLogCFatal(frmt, ...)      LOG_C_MAYBE(HTTP_LOG_ASYNC_FATAL,  httpLogLevel, LOG_FLAG_FATAL,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCError(frmt, ...)      LOG_C_MAYBE(HTTP_LOG_ASYNC_ERROR,  httpLogLevel, LOG_FLAG_ERROR,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCWarn(frmt, ...)       LOG_C_MAYBE(HTTP_LOG_ASYNC_WARN,   httpLogLevel, LOG_FLAG_WARN,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCNotice(frmt, ...)      LOG_C_MAYBE(HTTP_LOG_ASYNC_NOTICE,  httpLogLevel, LOG_FLAG_Notice,   \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCInfo(frmt, ...)       LOG_C_MAYBE(HTTP_LOG_ASYNC_INFO,   httpLogLevel, LOG_FLAG_INFO,    \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCDebug(frmt, ...)    LOG_C_MAYBE(HTTP_LOG_ASYNC_DEBUG, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCVerbose(frmt, ...)    LOG_C_MAYBE(HTTP_LOG_ASYNC_DEBUG, httpLogLevel, LOG_FLAG_DEBUG, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define HTTPLogCTrace()               LOG_C_MAYBE(HTTP_LOG_ASYNC_TRACE, httpLogLevel, LOG_FLAG_TRACE, \
HTTP_LOG_CONTEXT, @"%@[%p]: %@", THIS_FILE, self, __FUNCTION__)

#define HTTPLogCTrace2(frmt, ...)     LOG_C_MAYBE(HTTP_LOG_ASYNC_TRACE, httpLogLevel, LOG_FLAG_TRACE, \
HTTP_LOG_CONTEXT, frmt, ##__VA_ARGS__)


