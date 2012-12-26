//
//  TwitterRequest.h
//  Chirpie
//
//  Created by Brandon Trebitowski on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "ASIFormDataRequest.h"

@interface TwitterRequest : NSObject {
	NSString			*username;
	NSString			*password;
	NSMutableData		*receivedData;
	NSMutableURLRequest	*theRequest;
	NSURLConnection		*theConnection;
	id					delegate;
	SEL					callback;
	SEL					errorCallback;
	SEL					credentialCallback;
	
	BOOL				isPost;
	NSString			*requestBody;
	
	ASIFormDataRequest *request;
}

@property(nonatomic, retain) NSString	   *username;
@property(nonatomic, retain) NSString	   *password;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) id			    delegate;
@property(nonatomic) SEL					callback;
@property(nonatomic) SEL					errorCallback;
@property(nonatomic) SEL					credentialCallback;

-(void)friends_timeline:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)request:(NSURL *) url;
-(void)statuses_update:(NSString *)status delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)statuses_update:(NSString *)status withPhoto:(NSData*)photoData delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)verify_credentials:(id)requestDelegate requestSelector:(SEL)requestSelector;

@end
