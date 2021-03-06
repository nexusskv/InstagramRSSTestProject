/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

@protocol JTRevealSidebarDelegate;

@interface UINavigationItem (JTRevealSidebar)

@property (nonatomic, assign) id <JTRevealSidebarDelegate> revealSidebarDelegate;

@end
