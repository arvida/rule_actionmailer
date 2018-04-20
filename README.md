# RuleActionmailer

A drop-in Action Mailer adapter for sending mail via [Rule's](https://www.rule.se/apidoc/) transactional API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "rule_actionmailer", git: "https://github.com/varvet/rule_actionmailer"
```

And then execute:

    $ bundle

## Usage

First, you need to add the delivery method, initialized with your api key. Create a file named `rule_io.rb` in your application's `config` directory and paste the following in there:

```
ActionMailer::Base.add_delivery_method :rule_actionmailer,
  RuleActionmailer::DeliveryMethod,
  api_key: "YOUR-SECRET-KEY",
  base_url: "http://app.rule.io/api/v2"
```

Next, put this in your application's environment file:

```
config.action_mailer.delivery_method = :rule_actionmailer
```

...and everything should work!


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/varvet/rule_actionmailer.
