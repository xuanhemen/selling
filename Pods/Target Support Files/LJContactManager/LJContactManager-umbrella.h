#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LJContactManager.h"
#import "LJPeoplePickerDelegate.h"
#import "LJPerson.h"
#import "LJPickerDetailDelegate.h"
#import "NSString+LJExtension.h"

FOUNDATION_EXPORT double LJContactManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char LJContactManagerVersionString[];

