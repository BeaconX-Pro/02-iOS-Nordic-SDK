
#define MKValidStr(f)         (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define MKValidDict(f)        (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define MKValidArray(f)       (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define MKValidData(f)        (f!=nil && [f isKindOfClass:[NSData class]])

#ifndef MKBLEBase_main_safe
#define MKBLEBase_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#ifndef MK_LOCK
#define MK_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef MK_UNLOCK
#define MK_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif
