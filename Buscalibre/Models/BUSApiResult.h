//
//  BUSApiResult.h
//  buscalibre
//
//  Created by Magnet SPA on 31-08-17.
//  Copyright © 2017 Magnet. All rights reserved.
//

#ifndef BUSApiResult_h
#define BUSApiResult_h

typedef struct {
    BOOL success;
    int code;
    char *message;
} BUSApiResult;

NS_INLINE BUSApiResult BUSApiResultMake(BOOL success, int code, char *message) {
    BUSApiResult result;
    
    result.success = success;
    result.code = code;
    result.message = message;
    
    return result;
}

#endif /* BUSApiResult_h */
