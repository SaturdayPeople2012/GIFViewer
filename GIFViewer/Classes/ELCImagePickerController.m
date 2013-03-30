//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"

@implementation ELCImagePickerController

@synthesize delegate;

-(void)cancelImagePicker {
	if([delegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

-(void)selectedAssetsNames:(NSArray*)_assets {
    
}

-(void)selectedAssets:(NSArray*)_assets {

	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	for(ALAsset *asset in _assets) {

		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
		[workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
        
        //lkm - add filename {
        NSString* originalFileName = [[asset defaultRepresentation] filename];
        [workingDictionary setObject:originalFileName forKey:@"UIImagePickerControllerMediaMetadata"];
        //lkm - add filename }
        
        //lkm - save file{
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSError *error;
        //참고: http://stackoverflow.com/questions/6686730/iphone-how-does-one-read-an-image-from-the-photo-library-as-nsdata
        // 근데 이레저레 좀 만졌다. 
        //블록 크기만큼 바이트를 만든다.
        uint8_t *bytes = malloc([representation size]);
        //바이트를 로드하고, 바이트블록의 길이를 알아낸다.
        NSUInteger length = [representation getBytes:bytes fromOffset:0 length:[representation size] error:&error];

        //NSData타입 형태로 변환한다.
        NSData *data = [NSData dataWithBytes:bytes length:length];
        
        NSString *docsDir;
        NSArray *dirPaths;
        
        // documents 경로를 얻는다.
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
        
        docsDir = [dirPaths objectAtIndex:0];
        BOOL ret = NO;
#if 0
        //TTT 이렇게 하면 nil이다. 못불러온다.
        NSData *gifData = [NSData dataWithContentsOfURL:[[asset defaultRepresentation] url]];
        ret = [gifData writeToFile:[docsDir stringByAppendingPathComponent:originalFileName] atomically:YES];
        NSLog(@"ret : %d", ret);
#endif
        //저장한다.
        ret = [data writeToFile:[docsDir stringByAppendingPathComponent:originalFileName] atomically:YES];
        NSLog(@"ret2 : %d", ret);
		//lkm - save file}
        
		[returnArray addObject:workingDictionary];
		
		[workingDictionary release];	
	}
	
    [self popToRootViewControllerAnimated:NO];
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil] ;
    
	if([delegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[delegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {    
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    NSLog(@"deallocing ELCImagePickerController");
    [super dealloc];
}

@end
