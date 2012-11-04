
#import "TwitterRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation TwitterRequest

@synthesize username;
@synthesize password;
@synthesize receivedData;
@synthesize delegate;
@synthesize callback;
@synthesize errorCallback;
@synthesize credentialCallback;

-(void)friends_timeline:(id)requestDelegate requestSelector:(SEL)requestSelector{
	isPost = NO;

	self.delegate = requestDelegate;
	self.callback = requestSelector;
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/friends_timeline.xml"];
	[self request:url];
}

-(void)statuses_update:(NSString *)status delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;{
	isPost = YES;
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/update.xml"];
	requestBody = [NSString stringWithFormat:@"status=%@",status];
	[self request:url];
}

-(void)statuses_update:(NSString *)status withPhoto:(NSData*)photoData delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;{
	isPost = YES;
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	NSURL *url = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];	
	
	request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
	[request setDelegate:self];
	
	[request setData:photoData forKey:@"media"];
	[request setPostValue:username forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	[request setPostValue:status forKey:@"message"];
	
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSLog(@"%@", [request responseString]);
	
	
	if(delegate && callback) {
		if([delegate respondsToSelector:self.callback]) {
			[delegate performSelector:self.callback withObject:receivedData];
		} else {
			NSLog(@"No response from delegate");
		}
	} 
	
	//[request release];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
}

-(void)verify_credentials:(id)requestDelegate requestSelector:(SEL)requestSelector;{
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/account/verify_credentials.xml"];
	[self request:url];
}

-(void)request:(NSURL *) url {
	theRequest   = [[NSMutableURLRequest alloc] initWithURL:url];
	
	if(isPost) {
		NSLog(@"ispost");
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[theRequest setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
		[theRequest setValue:[NSString stringWithFormat:@"%d",[requestBody length] ] forHTTPHeaderField:@"Content-Length"];
	}
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	//NSLog(@"challenged %@",[challenge proposedCredential] );
	
	if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:[self username]
                                                 password:[self password]
                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];

    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		NSLog(@"Invalid Username or Password");
    }
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    //[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	[theRequest release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if(errorCallback) {
		[delegate performSelector:errorCallback withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	if(delegate && callback) {
		if([delegate respondsToSelector:self.callback]) {
			[delegate performSelector:self.callback withObject:receivedData];
		} else {
			NSLog(@"No response from delegate");
		}
	} 
	
	[theConnection release];
    [receivedData release];
	[theRequest release];
}

-(void) dealloc {
	[super dealloc];
}


@end
