//
//  ATLUIAvatarImageView.m
//  Atlas
//
//  Created by Kevin Coleman on 10/22/14.
//  Copyright (c) 2015 Layer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
#import "ATLAvatarImageView.h"
#import "ATLConstants.h"

@interface ATLAvatarImageView ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *initialsLabel;

@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;

@end

@implementation ATLAvatarImageView

NSString *const ATLAvatarImageViewAccessibilityLabel = @"ATLAvatarImageViewAccessibilityLabel";

+ (void)initialize {
    ATLAvatarImageView *proxy = [self appearance];
    proxy.backgroundColor = ATLLightGrayColor();
}

- (id)init {
    self = [super init];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lyr_commonInit];
    }
    return self;
}

- (void)lyr_commonInit {
    // Default UI Appearance
    _initialsFont = [UIFont systemFontOfSize:14];
    _initialsColor = [UIColor blackColor];
    _avatarImageViewDiameter = 27;

    self.accessibilityLabel = ATLAvatarImageViewAccessibilityLabel;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = _avatarImageViewDiameter / 2;
    self.opaque = YES;

    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.opaque = YES;
    [self addSubview:_imageView];

    _initialsLabel = [[UILabel alloc] init];
    _initialsLabel.textAlignment = NSTextAlignmentCenter;
    _initialsLabel.textColor = _initialsColor;
    _initialsLabel.font = _initialsFont;
    _initialsLabel.opaque = YES;
    [self addSubview:_initialsLabel];

    [self configureConstraints];
}

- (void)resetView {
    self.avatarItem = nil;
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.initialsLabel.text = nil;
    self.initialsLabel.hidden = YES;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.avatarImageViewDiameter, self.avatarImageViewDiameter);
}

- (void)setAvatarItem:(id<ATLAvatarItem>)avatarItem {
    if (avatarItem.avatarImage) {
        self.initialsLabel.text = nil;
        self.initialsLabel.hidden = YES;
        self.imageView.image = avatarItem.avatarImage;
        self.imageView.hidden = NO;
    } else {
        self.imageView.image = nil;
        self.imageView.hidden = YES;
        self.initialsLabel.text = avatarItem.avatarInitials;
        self.initialsLabel.hidden = NO;
    }

    _avatarItem = avatarItem;
}

- (void)setInitialsColor:(UIColor *)initialsColor {
    self.initialsLabel.textColor = initialsColor;
    _initialsColor = initialsColor;
}

- (void)setInitialsFont:(UIFont *)initialsFont {
    self.initialsLabel.font = initialsFont;
    _initialsFont = initialsFont;
}

- (void)setAvatarImageViewDiameter:(CGFloat)avatarImageViewDiameter {
    self.layer.cornerRadius = avatarImageViewDiameter / 2;
    _avatarImageViewDiameter = avatarImageViewDiameter;
    self.imageHeightConstraint.constant = avatarImageViewDiameter;
    self.imageWidthConstraint.constant = avatarImageViewDiameter;
    self.labelHeightConstraint.constant = avatarImageViewDiameter;
    self.labelWidthConstraint.constant = avatarImageViewDiameter;
    [self invalidateIntrinsicContentSize];
}

- (void)setImageViewBackgroundColor:(UIColor *)imageViewBackgroundColor {
    self.backgroundColor = imageViewBackgroundColor;
    _imageViewBackgroundColor = imageViewBackgroundColor;
}

- (void)configureConstraints {
    _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:_avatarImageViewDiameter];
    _imageWidthConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:_avatarImageViewDiameter];
    _labelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.initialsLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:_avatarImageViewDiameter];
    _labelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.initialsLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:_avatarImageViewDiameter];

    NSArray *constraints = @[
                             [NSLayoutConstraint constraintWithItem:self.imageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f],
                             [NSLayoutConstraint constraintWithItem:self.imageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f],
                             _imageHeightConstraint,
                             _imageWidthConstraint,
                             [NSLayoutConstraint constraintWithItem:self.initialsLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f],
                             [NSLayoutConstraint constraintWithItem:self.initialsLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f],
                             _labelHeightConstraint,
                             _labelWidthConstraint,
                             ];

    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.initialsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
