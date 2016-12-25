//
//  IDMPhotoBrowserDelegate.h
//  Pods
//
//  Created by Oliver ONeill on 10/12/2016.
//
//

#import <Foundation/Foundation.h>
/**
 * A protocol used so that an IDMPhotoBrowser can be notified on the completion
 * of asynchronous call `IDMPhotoDataSource.loadMoreImages`
 */
@protocol IDMBrowserDelegate <NSObject>
- (void)imagesLoaded;
@end
