//
//  SizeSetting.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_RETINA = (UIScreen.main.scale >= 2.0)

let SCREEN_NATIVE_HEIGHT = UIScreen.main.nativeBounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))
let IS_ZOOMED = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
let IS_IPHONE_XR = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 1792.0)
let IS_IPHONE_XSMAX = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2688.0)
let IS_IPHONE_X_XS = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2436.0)
let IS_IPHONE_12 = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2340)
let IS_IPHONE_12_MAX = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2532)
let IS_IPHONE_5_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
let IS_IPHONE_14 = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2532)
let IS_IPHONE_14_Pro = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2556)
let IS_IPHONE_14_Plus = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2778)
let IS_IPHONE_14_Pro_MAX = (IS_IPHONE && SCREEN_NATIVE_HEIGHT == 2796)

let HAVE_NOTCH = (IS_IPHONE_X_XS || IS_IPHONE_XR || IS_IPHONE_XSMAX || IS_IPHONE_12 || IS_IPHONE_12_MAX || IS_IPHONE_14_Pro || IS_IPHONE_14_Plus || IS_IPHONE_14_Pro_MAX)

let LEFT_VIEW_IPAD : CGFloat = 0.4*SCREEN_WIDTH

let NAV_HEIGHT : CGFloat = IS_IPHONE_14_Pro_MAX  ? 54 : (IS_IPHONE_14_Pro || IS_IPHONE_14_Plus ? 52 : 44.0)
//let STATUSBAR  : CGFloat = IS_IPHONE_14_Pro_MAX ? 54 : (IS_IPHONE_14_Pro || IS_IPHONE_14_Plus ? 52 : (HAVE_NOTCH ? 44.0 : 20.0))
var STATUSBAR: CGFloat {
    return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
}
let TOP_VIEW : CGFloat =  NAV_HEIGHT + STATUSBAR
let BOTTOM_INSET : CGFloat = (HAVE_NOTCH ? 22.0 : 0)
let BOTTOM_BAR : CGFloat = 50.0 + BOTTOM_INSET
let TABBAR_HEIGHT : CGFloat = 49 + BOTTOM_INSET
let PAGEBAR_HEIGHT : CGFloat = 44

let PICKER_HEIGHT : CGFloat = 260
let KEYBOARD_HEIGHT : CGFloat = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 ? 253 : (IS_IPHONE_6 ? 258 : (HAVE_NOTCH ? 333 : (IS_IPHONE_6P ? 271 : 313))))
let ORIGIN_Y_KEYBOARD : CGFloat = SCREEN_HEIGHT - KEYBOARD_HEIGHT

let UNDERLINE_WIDHT = 1.5
let SEPARATE_LINE_WIDHT = 0.5
let MARGIN : CGFloat = 16.0
let INSET : CGFloat = 14.0
let INSET_TABLE : CGFloat = 16.0
let SMALLINSET : CGFloat = 8.0
let COMMENT_IMG : CGFloat = 42.0
let CHOICE_HEIGHT : CGFloat = 60.0

/*
#define isiPhone5  1
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.width == 375)?TRUE:FALSE
#define isiPhone6Plus  ([[UIScreen mainScreen] bounds].size.width == 414)?TRUE:FALSE

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define STATUSBAR ((IS_IPHONE_X)? 44.0 : 20.0)
#define BOTTOM_BAR (IS_IPHONE_X?65:50)
#define BOTTOM_INSET 22.0

#if TARGET_OS_IPHONE
	#define MARGIN 16.0
	#define INSET 14.0
	#define INSET_TABLE 16.0
	#define SMALLINSET 8.0
	#define COMMENT_IMG 42.0
*/
