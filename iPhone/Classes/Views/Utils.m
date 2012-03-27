//
//  Utils.m
//  FlashCardDB
//
//  Created by Friends on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#include <sys/xattr.h>


@implementation Utils

+ (NSString*) getFileName:(NSString*) audioFile
{
	NSArray* arr = [audioFile componentsSeparatedByString:@"/"];
	return (arr.count > 0) ? [arr lastObject] : nil;
}

+ (UIColor*) colorFromString: (NSString*) colorStr
{
	if (colorStr == nil && colorStr.length == 0) return nil;
	NSArray* arr = [colorStr componentsSeparatedByString:@","];
	
	if (arr.count < 3) return nil;

	CGFloat red = [[arr objectAtIndex:0] intValue] / 255.0f;
	CGFloat green = [[arr objectAtIndex:1] intValue] / 255.0f;
	CGFloat blue = [[arr objectAtIndex:2] intValue] / 255.0f;
	UIColor* color= [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	
	return color;
}

+(NSString *) getValueForVar:(NSString *) strVar{

	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"features" ofType:@"plist"];
	NSDictionary *featuresDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	NSString * strReturnvalue=[featuresDict objectForKey:strVar];
	
	//NSLog(@"Key : %@, Value :%@\n",strVar,strReturnvalue);
	
	return strReturnvalue;
}

+(NSString *) getEncodedText:(NSString *) strText{
	
	strText = [strText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#9679;" withString:@"●"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#150;" withString:@"–"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#174;" withString:@"®"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#176;" withString:@"°"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#179;" withString:@"³"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#181;" withString:@"µ"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#188;" withString:@"¼"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#215;" withString:@"×"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#232;" withString:@"è"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#233;" withString:@"é"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#247;" withString:@"÷"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#60;" withString:@"<"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#62;" withString:@">"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8212;" withString:@"—"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8304;" withString:@"⁰"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8310;" withString:@"⁶"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8320;" withString:@"₀"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8321;" withString:@"₁"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8322;" withString:@"₂"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8323;" withString:@"₃"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8324;" withString:@"₄"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8325;" withString:@"₅"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#185;" withString:@"¹"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#189;" withString:@"½"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#190;" withString:@"¾"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8326;" withString:@"₆"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8328;" withString:@"₈"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8531;" withString:@"⅓"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8532;" withString:@"⅔"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8539;" withString:@"⅛"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8540;" withString:@"⅜"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8541;" withString:@"⅝"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#8725;" withString:@"∕"];
	strText = [strText stringByReplacingOccurrencesOfString:@"&#153;" withString:@"™"];
	
	return strText;
}



+ (NSString *) getJSCode{

	NSString* jsCode=[[NSString alloc] 
					  initWithString:@"var FC_SearchResultCount = 0;\
	function FC_HighlightAllOccurencesOfStringForElement(element,keyword) {\
		if (element) {\
			if (element.nodeType == 3) {\
				while (true) {\
					var value = element.nodeValue;\
					var idx = value.toLowerCase().indexOf(keyword);\
					if (idx < 0) break;\
					var span = document.createElement(\"span\");\
					var text = document.createTextNode(value.substr(idx,keyword.length));\
					span.appendChild(text);\
					span.setAttribute(\"class\",\"FCHighlight\");\
					span.style.backgroundColor=\"yellow\";\
					span.style.color=\"black\";\
					text = document.createTextNode(value.substr(idx+keyword.length));\
					element.deleteData(idx, value.length - idx);\
					var next = element.nextSibling;\
					element.parentNode.insertBefore(span, next);\
					element.parentNode.insertBefore(text, next);\
					element = text;\
					FC_SearchResultCount++;\
				}\
			} else if (element.nodeType == 1) {\
				if (element.style.display != \"none\" && element.nodeName.toLowerCase() != 'select') {\
					for (var i=element.childNodes.length-1; i>=0; i--) {\
						FC_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);\
					}\
				}\
			}\
		}\
	}\
	function FC_HighlightAllOccurencesOfString(keyword) {\
		FC_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());\
	}\
	function FC_RemoveAllHighlightsForElement(element) {\
		if (element) {\
			if (element.nodeType == 1) {\
				if (element.getAttribute(\"class\") == \"FCHighlight\") {\
					var text = element.removeChild(element.firstChild);\
					element.parentNode.insertBefore(text,element);\
					element.parentNode.removeChild(element);\
					return true;\
				} else {\
					var normalize = false;\
					for (var i=element.childNodes.length-1; i>=0; i--) {\
						if (FC_RemoveAllHighlightsForElement(element.childNodes[i])) {\
							normalize = true;\
						}\
					}\
					if (normalize) {\
						element.normalize();\
					}\
				}\
			}\
		}\
		return false;\
	}\
	function FC_RemoveAllHighlights() {\
		FC_SearchResultCount = 0;\
		FC_RemoveAllHighlightsForElement(document.body);\
	}"];
					  
	return jsCode;				  
					  
}


+ (void) randomizeArray:(NSMutableArray *) arrValues
{
	srandom(time(NULL));
	for (NSInteger x = 0; x < [arrValues count]; x++) {
		NSInteger randInt = (random() % ([arrValues count] - x)) + x;
		[arrValues exchangeObjectAtIndex:x withObjectAtIndex:randInt];
	}
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
	
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
	
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end

@implementation UINavigationBar (CustomNavigationBar)

	- (void) drawRect:(CGRect) rect{
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			/*
			UIColor *color =[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
			CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
			CGContextFillRect(context, rect);
			*/
			UIImage* img = [UIImage imageNamed:@"bar_bg_right"];
			[img drawInRect:rect];
		}
		else
		{
			UIImage* img = [UIImage imageNamed:@"TopBar"];
			[img drawInRect:rect];
		}
	}


@end
 



@implementation CustomToolBar


- (void) drawRect:(CGRect) rect
{
	UIImage* img = [UIImage imageNamed:@"BottamBar"];
	[img drawInRect:rect];
}

@end

