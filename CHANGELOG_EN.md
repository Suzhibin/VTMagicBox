#Change Log
All notable changes to this project will be documented in this file.


## [2.0.3](https://github.com/Suzhibin/VTMagicBox/releases/tag/2.0.3) (14/04/2025)
Posted on Monday, April 14, 2025
### Update
- Add againstSafeAreaBottom navigation to the bottom layout enumeration VTPositionStyleBottom can be used
- Add safeBottomHeight navigation to the bottom layout enumeration VTPositionStyleBottom to use
# #

--- 
## [2.0.2](https://github.com/Suzhibin/VTMagicBox/releases/tag/2.0.2) (19/06/2024)
Released on Thursday, May 17, 2024
### changed
- Added MAC Catalyst support
- Menu on the right side of the layout 'VTLayoutStyleRight' changed to `VTLayoutStyleLast`
- `againstSafeAreaBottom` Deletes the `againstStatusBar` function
- Add menu customization or use the third party method `setNavigationView` to change to `setMenuView`
- Menu customization or compatible optimization using third party and built-in layout
##

## [2.0.1](https://github.com/Suzhibin/VTMagicBox/releases/tag/2.0.1) (17/05/2024)
Released on Thursday, May 17, 2024
### changed
- Added navigation portrait mode of left and right layout `VTPositionStyleLeft`, `VTPositionStyleRight`
- Add menu customization or use third party `setNavigationView`
- Added `navigationWidth` to navigation in portrait mode
- Added `bubbleSize` to set absolute bubble size. Adapted to navigation portrait mode
- Added `separatorWidth` separatorWidth setting. Adapted to navigation portrait mode
- Increases `itemHeight` menu height. Adapted to navigation portrait mode
##

## [2.0.0](https://github.com/Suzhibin/VTMagicBox/releases/tag/2.0.0) (01/06/2023)
Released on Thursday, June 1st, 2023
### changed
- VTMagicBox is a fork of VTMagic
- Added menu in the right hand layout `VTLayoutStyleRight`
- Add the navigation bottom layout enumeration `VTPositionStyle`, with `VTPositionStyleDefault` as the default and `VTPositionStyleBottom` as the bottom
- Adding `footerView` uses the same method as adding `headerView`
- Navigation Adds `navigationSubview` at the bottom of the menu for adding background images, etc
- Increase the offset of the `contentViewOffset` content container relative to the bottom of the navigation for designers
- Add normalFont and selectedFont, the menu uses the default font and itemScale invalidates if the font is selected
- Increase `contentHorizontalAlignment` adjust the menu button aligned to deal with the designer's test

##

## [1.2.4](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.4) (08/10/2016)
Released on Wednesday, August 10, 2016.

### changed
- Optimize appearance callbacks, fix unbalance error when call `reloadData`、`reloadDataToPage:`and `switchToPage:animated:` in `viewWillAppear:` method;
- Delete `VTLayoutStyleCustom`, you can set the width of `menuItem` by `itemWidth` directly, it does not work when the value of `layoutStyle` is `VTLayoutStyleDivide`;
- Add `magicView:itemWidthAtIndex:` and `magicView:sliderWidthAtIndex:` delegate methods, you can custom the width of `menuItem` or `sliderView` at `itemIndex`;
- Deprecate property `needExtendBottom`, if you want realize translucent effect, you should set value `UIRectEdgeAll` to `edgesForExtendedLayout`;
- Update the frame of page view before appearance callbacks be called;
- Fix menu bar cannot auto scroll in some special conditions;
- Improved the demo project, to show how to cache and read the page data;
- Auto hide `sliderView` when menu titles are empty;
- Rename internal files;
- Other optimization;


## [1.2.3](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.3) (07/06/2016)
Released on Wednesday, July 6, 2016.

### changed
- Add preloading switch, you can control preloading logic by modifying property `needPreloading`.
- You can custom `sliderView` and `separatorView` if you need.
- You can clear memory cache by method `clearMemoryCache`.
- Add new method `pageIndexForViewController:`, you can get the `pageIndex` of any page controller by this method, and also you can get the `pageIndex` of current page controller by category method `vtm_pageIndex` conveniently.
- Method `updateMenuTitles` was renamed `reloadMenuTitles`, and property `needExtendedBottom` was renamed `needExtendBottom`.
- Fix bug: unable to accurately focus on menu item when switch by `handlePanGesture:`.


## [1.2.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.2) (06/29/2016)
Released on Wednesday, June 29, 2016.

### changed
- Add new method `reloadDataToPage:`, support reload data and switch to specified page at the same time.
- Optimize appearance logic, fix bug that multiple calls appearance methods(`viewWillAppear:`,etc), optimize multiple nesting.
- Modify protocol `VTMagicViewDelegate`, method `viewDidAppeare:` was renamed `viewDidAppear:`, and method `viewDidDisappeare:` was renamed `viewDidDisappear:`.


## [1.2.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.1) (06/19/2016)
Released on Sunday, June 19, 2016.

### changed
- Add property `itemScale`, if you change it, menuItem will have zoom effect when switching.
- Optimize menu bar.

## [1.2.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.2.0) (06/13/2016)
Released on Monday, June 13, 2016.

### changed
- Add property `sliderExtension`.
- Optimize layout.


## [1.1.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.1.0) (06/04/2016)
Released on Sunday, June 4, 2016.

### changed
- Add property `sliderStyle`，you can show a bubble in menu bar by setting `sliderStyle` to `VTSliderStyleBubble`.
- Add **Center** in demo project.

## [1.0.2](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.2) (06/02/2016)
Released on Thursday, June 2, 2016.

### changed
- Add new layout style `VTLayoutStyleCenter`.
- Improved the demo project, add modules **Center**、**Divide** and **Data**.


## [1.0.1](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.1) (06/01/2016)
Released on Wednesday, June 1, 2016.

### changed
- Adjust the file directory.


## [1.0.0](https://github.com/tianzhuo112/VTMagic/releases/tag/1.0.0) (05/31/2016)
The initial version is released on Tuesday, May 31, 2016.

### Features
- You can custom every page controller by different identifier if you need, each one is independent.
- VTMagic will automatically calls the appearance methods when user switches the page, it is convenient for you to manage the data, or do some other things.
- Menu bar supports multiple layout style, you can change it by `layoutStyle`.
- You can also custom `menuItem` if you need, it can display text and image.
- You can get the nearest magicController in any child view controller which is conforms to `<VTMagicProtocol>`, after you import file `VTMagic.h`.
- You can embed webview in any page, if the page can't scroll, you should call method handlePanGesture: to fix it(please refer to **Data** module).
- The page is reusable and support auto rotate.
- For more information please read file `VTMagicView.h`.


