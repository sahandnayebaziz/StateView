![Views last updated: just now.](https://www.dropbox.com/s/cjqcrxnq060ax74/stateview%20header.png?dl=1)

StateView is a UIView substitute that automatically updates itself when data changes.

Contents:
- [Overview](#overview)
- [What's it like?](#whats-it-like)
- [Sample apps](#sample-apps)
- [How does it work?](#how-does-it-work)
- [Installation](#installation)
- [What's next?](#whats-next)
- [Credits](#credits)
- [License](#license)

## Overview

StateView is a UIView subclass that uses modern thinking and inspiration from what Facebook has done with React and the DOM to make displaying and updating your views easier, simpler, and more fun.

With StateView...
- Your views update themselves when your data changes.
- Your views add, remove, and update their subviews by themselves when your data changes.
- Your views only update themselves if they need to. Each StateView calculates a diff (powered by a wonderful package named [Dwifft](https://github.com/jflinter/Dwifft)) when your data changes to understand which subviews can stay, which can go, and which can be refreshed. Then, your StateView makes only those minimal changes.
- You can write any custom view as a StateView.
- You can write StateViews that contain other StateViews, standard UIViews, or a mix of both.
- Your StateViews can automatically update  a subview that is a standard UIView without any new code or special wrapping around that UIView.
- You are encouraged to keep state across different views in your view hierarchy. Managing this state is easier when you use StateView and don't have to think about when, where, or how to call to methods like init, addSubview, and removeFromSuperview on your subviews.
- You don't need to re-architect your app to be a declarative, functional, event-streamed, sequence-based, event-catching app to enjoy the benefits of reactivity and a family of views that are all pure functions of their state.

## What's it like?

When you create your first StateView, you will become familiar with **props**, **state**, and **render()**.

You can use **props** to pass values from one StateView to another, **state** to keep values in a StateView privately, and **render()** to describe how a StateView looks. StateView is simply a subclass of UIView that uses these three to update itself when your data changes.

(Both **props** and **state** allow values of type `Any` to encourage you to keep and pass around anything that works for you.)

When you add your first subview to a StateView inside **render()**, you will become familiar with **place()**.

You can use **place()** to add a subview to your StateView. Then, your StateView will call addSubview and removeFromSuperview by itself so you don't have to.

In **render()**, simply look at your **state** and any passed-in **props**, and write code like...

```swift
override func render() {
	
	if let selectedImage = self.state["selectedImage"] as? UIImage {
		place(ImageViewWithTags.self, "image") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
	} else {
		place(PlaceholderImageView.self, "placeholder") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
	}
}
```

If in **state**, the key "selectedImage" contains a UIImage, an 'ImageViewWithTags' is placed, given the key "image", and given some AutoLayout constraints (using a wonderful library named [SnapKit](https://github.com/SnapKit/SnapKit)). If in **state**, "selectedImage" is nil or missing altogether, a PlaceholderImageView is placed instead.

Simply update your data and the view will update itself.

Change the value of "selectedImage" in **state** and this StateView will display, or not display, another custom StateView named ImageViewWithTags. Your StateView will call addSubview and removeFromSuperview by itself to render an updated view.

This, the way you can use **render()** and **place()**, is one of the most fun parts of using StateView.  

Your code to decide which subviews to add to a StateView can go in **render()** where it will run any time your data changes. The results of a **render()** pass are then diffed with the results of the previous **render()** pass and your StateView only makes up the difference.

You can use **props** to pass values from one StateView to another. You can propagate new data in the **state** of one StateView to its children this way. In this case, to pass the new image in **state** to ImageViewWithTags, you can write code like...

```swift
override func render() {

	if let selectedImage = self.state["selectedImage"] as? UIImage {
		let imageView = place(ImageViewWithTags.self, "image") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
		imageView.prop(forKey: Home.image, is: selectedImage)
	} else {
		place(PlaceholderImageView.self, "placeholder") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
	}
}
```

Now this instance of ImageViewWithTags will receive selectedImage in its **props**. ImageViewWithTags can then access the new value of selectedImage anywhere in any of its methods, and especially in its own render method to do something like update a UIImageView. 

ImageViewWithTags can access the value of selectedImage by using the same key used here, `Home.image`, which is an enum. You can create any number of your own enums to name your values any way that works for you. Any time **state** has a new value for selectedImage, ImageViewWithTags will receive the new value and update itself.

The second value in place, **key**, is used to help understand which views are the same between renders. The value of **key** can be anything you’d like, as long as no other subviews in that StateView have the same key. If the **key** of something you’ve placed changes between renders, StateView will render that subview from scratch since there won't be any existing views placed with the new **key** that can be preserved.

When you create your first StateView, you will become familiar with the following thought process:
- How can this view change? I can leave variables in **state** to describe these different changes.
- Now in **render()**, when **state** has this value for that key, I should place this subview, but if it has this value for that other key, I should place this one instead.
- I can enumerate all the values I plan on passing between these views so that I can see them in one place and make it easy for others to understand data flow in my application.
- That subview will get its **props** from this StateView's parent view, so I can pass along two of the **props** passed into this StateView into that StateView.
- Which code is responsible for changing that value in **state** again? Oh, this callback here. I should add an initial value for that key in **state** to this StateView so that my **render()** has something concrete to use to decide what to display before that callback returns something.  
- Is there anything else I should put in **render()** since render runs any time my data changes? Is there anything else I'd like to be subtly different in my view when my data looks like this but not like that?

A [full documentation](https://github.com/sahandnayebaziz/StateView/wiki/Documentation) of StateView and a [getting started](https://github.com/sahandnayebaziz/StateView/wiki/Getting-started) guide is in the [wiki](https://github.com/sahandnayebaziz/StateView/wiki).

## Sample apps

[Frame](https://github.com/sahandnayebaziz/StateView-Samples-Frame) is the first app made with StateView. With StateView, Frame ended up being just four classes, three of which are well under one hundred lines.

## How does it work?

When you use a StateView, there is a ShadowView behind-the-scenes that helps understand which subviews can stay, which can go, and which can be refreshed between calls to **render()**.

Each instance of StateView has a one-to-one matching instance of ShadowView that uses lightweight structs and references to keep a record of the view hierarchy and the data that the hierarchy represents.

Both **render()** and **place()** work closely with a StateView’s ShadowView to make the smallest number of changes to the view hierarchy to update what you see on screen.

When **state** changes in one of your views, a ShadowView orchestrates the calculation of the diff, the adding and removing of any needed or not needed subviews, and the passing of **props** from StateViews to their contained StateViews.

## Installation

You can install StateView from CocoaPods.

`pod 'StateView'`

## What's next?

StateView was made to give iOS developers a safe, easy way to see their views update themselves. Above all, the goal is for StateView to be easy to use.

Any help towards making the methods, parameters, and patterns contained inside feel simpler despite the complexity of what StateView does is appreciated greatly. As are improvements to the performance of StateView.

If you’d like to contribute, take a look at the list of known issues in the wiki or start a new conversation in this project's issues!

## Credits

StateView was written by Sahand Nayebaziz. StateView was inspired by [React](https://facebook.github.io/react/) and the DOM.

## License

StateView is released under the MIT license. See LICENSE for details.
