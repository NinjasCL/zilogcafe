//
//  ExtendNSLogFunctionality.h
//  ZilogCafe
//
//  Created by Camilo on 15-10-13.
//
// From http://mobile.tutsplus.com/tutorials/iphone/customize-nslog-for-easier-debugging/

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#ifdef DEBUG
#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define NSLog(x...)
#endif
void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

