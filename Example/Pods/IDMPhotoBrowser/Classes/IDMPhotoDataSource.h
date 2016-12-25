//
//  IDMPhotoDataSource.h
//  Pods
//
//  Created by Oliver ONeill on 10/12/2016.
//
//

#import <Foundation/Foundation.h>
#import "IDMBrowserDelegate.h"

/**
 * A class for loading in images as needed, gives much more flexibility
 * over a fixed array. This could be used for an infinite scrolling setup
 */
@protocol IDMPhotoDataSource <NSObject>
/**
 * Loads new images that should eventually appear at the end of `getPhotos`
 * result. This should be an asynchronous call that does not block, it should
 * call the appropriate delegate method on completion.
 * @param browser - on completion you should call
 * `IDMBrowserDelegate.imagesLoaded` to notify the caller of completion
 */
- (void)loadMoreImages:(id<IDMBrowserDelegate>)browser;
/**
 * Returns the current set of photos. This should grow in length when
 * `loadMoreImages` is called.
 */
- (NSArray *)getPhotos;
@end
