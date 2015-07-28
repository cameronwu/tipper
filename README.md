# tipper

This is a tip calculator app created as a pre-work assignment for application to CodePath. It takes the basic requirements 
as outlined here: http://courses.codepath.com/snippets/ios_for_designers/thanks_for_applying, as well as the optional tasks
as outlined here: https://gist.github.com/timothy1ee/434cc97da182c490ea74, and adds the following additional functionality:

- Instead of binding an IBAction to the function onEditingChanged, I've used a textField delegate.
- I’ve adapted FormattedCurrencyInput by Peter Boni (https://github.com/peterboni/FormattedCurrencyInput) to Swift,
  allowing the user to enter numbers right-to-left, and eliminates the need for the decimal keypad.


Time spent: 16 hours


Completed user stories:

- Required: User can enter a bill value, and see the tip calculated by 15%, 18%, and 20% amounts for 1-4 people.


Walkthrough:

![alt tag](https://raw.githubusercontent.com/cameronwu/tipper/master/tipper.gif)
