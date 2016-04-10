![Views last updated: just now.](https://www.dropbox.com/s/cjqcrxnq060ax74/stateview%20header.png?dl=1)

StateView is a UIView substitute that automatically updates itself when data changes.

## Overview

StateView is a class that uses modern thinking and inspirations from what Facebook has done with React and the DOM to make displaying and updating your views easier, simpler, and more fun. 

With StateView... 
- Your views update themselves when your data changes.
- Your views add and remove their subviews by themselves when your data changes.
- Your views only update themselves if they need to. A StateView calculates a diff (powered by a wonderful package named [Dwifft](https://github.com/jflinter/Dwifft)) every time data changes to understand which subviews can stay, which can go, and which can be refreshed. Then, your StateView makes only those minimal changes.
- You can write any custom view as a StateView by describing how it should look once in the render method.
- You can write StateViews that contain other StateViews, standard UIViews, or a mix of both!
- You can include any standard UIView subclass in your StateViews and watch that view get added, removed, and updated automatically without any new code or special wrapping. 
- You can encourage your app to have and keep state across its many pieces. Using a StateView makes managing this state easier as you don't have to think about when, where, or how often to call methods like addSubview and removeFromSuperview.
- You don't need to re-architect your app to be a declarative, functional, event-streamed, sequence-based, event-catching app to enjoy the benefits of reactivity and a family of views that are all pure functions of their state.

## What's it like?

When you create your first StateView, you will become familiar with **props**, **state**, and **render()**.

You can use **props** to pass values from one StateView to another, **state** to keep values privately inside a StateView, and **render()** to actually describe how a StateView looks. StateView is simply a subclass of UIView that uses these three to update itself when your data changes.

(Both **props** and **state** are dictionaries with type `[String: AnyObject]` to encourage you to keep and pass around anything that works for you.)

When you add your first subview to a StateView inside **render()**, you will become familiar with **place()**.

You can use **place()** to add a subview to your StateView. Then, your StateView will call addSubview and removeFromSuperview by itself so you don't have to.

In **render()**, simply look at your **state** and any passed-in **props**, and write code like...

```swift
override func render() {

	if let selectedImage = self.state\["selectedImage"] as? UIImage {
		let imageView = place(ImageViewWithTags.self, "image") { make in
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

Simply update the data and the view will update itself.

Change the value of "selectedImage" in **state** and this StateView will display, or not display, another custom StateView named ImageViewWithTags. Your StateView will call addSubview and removeFromSuperview by itself to render an updated view.

This, the way you can use **render()** and **place()**, is one of the most fun parts of using StateView.

You can use **props** to pass values to a subview that is another StateView. In this case, to pass the new image in **state** to ImageViewWithTags, you can write code like...

```swift
override func render() {

	if let selectedImage = self.state\["selectedImage"] as? UIImage {
		let imageView = place(ImageViewWithTags.self, "image") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
		imageView.prop(forKey: "image", is: selectedImage)
	} else {
		place(PlaceholderImageView.self, "placeholder") { make in
			make.size.equalTo(self)
			make.center.equalTo(self)
		}
	}
}
```

Now this instance of ImageViewWithTags will receive selectedImage in its **props** and can use the value in it's own render method to display a UIImageView and set up its own subviews or in any other of its methods for anything else. Any time **state** has a new value for selectedImage, ImageViewWithTags will re-render automatically when it is passed the new value. 

The second value in place, **key**, is used to help understand which views are the same between renders. The value of **key** can be anything you’d like, as long as no other subviews in that StateView have the same key. If the **key** of something you’ve placed changes between renders, StateView will render that subview from scratch instead of keeping the already rendered copy if that copy is still good.

You can use StateViews like this to write a single render method so your StateView knows how to update itself when your data changes.

When you create your first StateView, you will become familiar with the following thought process:
- How can this view change? I can leave variables in **state** to describe these different changes.
- Now in **render()**, when **state** has this value for that key, I should place this subview, but if it has this value for that other key, I should place this one instead.
- That subview will get its **props** from this StateView's parent view, so I can pass two of the **props** passed to this StateView into that subview.
- Which code is responsible for changing that value in **state** again? Oh, this callback here. I should add an initial value for that key in **state** to this StateView so that my **render()** has something concrete to use to decide what to display before that callback returns something.  

A full list of methods you can call when using StateView is listed in the wiki.

## In Action

The first app built with StateView is [Frame](https://github.com/sahandnayebaziz/StateView-Samples-Frame), an app that can frame portrait and landscape images onto a white background. 

More apps built with StateView will be added here once available.

## How does it work?

When you use a StateView, behind the scenes StateView keeps a ShadowView to help in understanding which subviews should be removed, added, and updated when your data changes.

Each instance of StateView has a one-to-one matching ShadowView instance that uses lightweight structs and references to keep a record of the view hierarchy and the data that the hierarchy represents. 

Both **render()** and **place()** work closely with a StateView’s ShadowView to make the smallest number of changes to the view hierarchy to update what you see on screen.

When **state** changes in one of your views, a ShadowView orchestrates the calculation of the diff, the adding and removing of any needed or not needed subviews, and the passing of **props** from StateViews to their contained StateViews.

## Installation

You can install StateView from CocoaPods.

`pod 'StateView'`

## What's next?

StateView was made to give iOS developers a safe, easy way to see their views update themselves. Above all, the goal is for StateView to be easy to use.

Any help towards making the methods, parameters, and patterns contained inside feel simpler despite the complexity of what StateView does is appreciated greatly. As are improvements to the performance of StateView.

If you’d like to contribute, take a look at the list of known issues in the wiki. 

## Credits

StateView was written by Sahand Nayebaziz. StateView was inspired by [React](https://facebook.github.io/react/) and the DOM.

## License

StateView is released under the MIT license. See LICENSE for details.
