//
//  BDebugDefine.h
//  ObjectiveCBaseApplication
//
//  Created by Linh on 8/4/17.
//  Copyright © 2017 smvn. All rights reserved.

#ifndef Cyberpay_BDebugDefine_h
#define Cyberpay_BDebugDefine_h

// Andrew: Retailer ID: 182, Seller ID: 351

#if defined DEBUG

/** Skip OTP process when adding seller (UI only) */
//#define B_DEBUG_SKIP_SELLER_ADD_OTP

/** Skip OTP process when editing seller mobile (UI only) */
//#define B_DEBUG_SKIP_SELLER_UPDATE_OTP

/** Skip OTP process when activating giro account (UI only) */
//#define B_DEBUG_SKIP_GIRO_ACTIVATION_OTP

/** Toggles GIRO account list */
//#define B_DEBUG_TOGGLE_GIRO_ACCOUNT_STATUS

/** Toggles Withdraw GIRO */
//#define B_DEBUG_TOGGLE_WITHDRAW_GIRO_ACCOUNT_STATUS

/** Enable resend OTP after x seconds */
#define B_DEBUG_SHORT_OTP_WAIT_TIME 15

/** Enter background mode after x seconds */
#define B_DEBUG_SHORT_SUSPEND 5

/** Always show cafe select screen after login */
//#define B_DEBUG_SHOW_CAFE_SELECT

/** Automatically submit login passcode */
#define B_DEBUG_AUTO_PASSCODE @"111111"

/** Automatically fill login mobile */
#define B_DEBUG_AUTO_MOBILE [[NSProcessInfo processInfo] environment][@"B_MOBILE"]

/** Automatically fill login OTP */
#define B_DEBUG_AUTO_OTP @"123456"

#define B_DEBUG_DETAILED_ERROR

//#define B_DEBUG_INVERT_PRINT_COLOR

/** Show product api type in product list */
#define B_DEBUG_SHOW_PRODUCT_API_TYPE

#endif // #if defined DEBUG





#if defined DEBUG || defined INTRELEASE

/** Enable changing of server in login page */
#define B_INT_CHANGE_SERVER_ENABLED

#define B_INT_DETAILED_ERROR

#endif // #if defined DEBUG || defined INTRELEASE





#endif
