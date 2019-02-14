Cohorts
=====

This is the software that was used to manage [Cohorts](https://cohortsfeedback.com/), a service of [Ad Hoc](https://adhoc.team/) that allowed us to conduct incisive research with groups of relevant people to make government digital services work better for all. It was heavily based on [kimball](https://github.com/smartchicago/kimball), originally developed for the [Civic User Testing Group](http://www.cutgroup.org/) by the [Smart Chicago Collaborative](http://www.smartchicagocollaborative.org/). See also the [launch blog post for Cohorts](https://adhocteam.us/2017/03/13/cohorts-launch/) and [The CUTGroup Book](http://www.cutgroupbook.org/).

The tool was decomissioned in early 2019 and the code open sourced. This repo is archived because the tool is no longer used or supported.

Features
-----

Cohorts was a tool to recruit, manage, and communicate with a large pool of people to test the products we build. Cohorts stored information about people that have signed up to participate in Ad Hoc user research. It did so by integrating with three external services:
* [Wufoo](https://www.wufoo.com/) was used to create web forms that can be sent out to participants to collect more information about them.
* [Twilio](https://www.twilio.com/) was used to communicate with participants via SMS.
* [Mailchimp](https://mailchimp.com/) and [Mandrill](https://mandrillapp.com/) were used to communicate with participants via email.

Setup
-----
Cohorts is a Ruby on Rails app. The regular rules apply:

1. Locally or in a VM, install dependencies:
    * **PostgreSQL** - [Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04) | [Mac](https://solidfoundationwebdev.com/blog/posts/how-to-install-postgresql-using-brew-on-osx)
    * **Ruby 2.3.1** - Install using [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/rvm/install)
    * **Bundler** - `gem install bundler` after installing Ruby
2. Clone this repo: `git clone https://github.com/adhocteam/cohorts-open.git`
3. In the project directory, run `bundle install`
4. Create a PostgreSQL superuser with your computer's username (replace [myuser]):
	* `sudo -u postgres createuser -s [myuser]`
	* `sudo -u postgres psql`
	* `\password [myuser]`  and enter password
	* `\q`
	* Set password as `PG_PASS` environment variable in your `.bashrc`/`.bash_profile` or in `.env`
5. Setup the database by running `bundle exec rake db:setup`
6. Run the app with `rails s`

Environment Variables
-----
Environment variables are loaded from the `.env` file in the root directory using the [dotenv](https://github.com/bkeepers/dotenv) gem. This file should not be committed to git. To get started locally, you can run the following command: `cp sample.env .env`

If you are hosting the app on [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) or [Heroku](https://www.heroku.com/home), you can also manage the environment using their built-in interfaces.

External Services
-----

#### Wufoo

Wufoo hosts all forms used for Cohorts. There are 4 environment variables that need to be defined for Wufoo:
* `WUFOO_ACCOUNT` - your account identifier
* `WUFOO_API` - your API key
* `WUFOO_HANDSHAKE_KEY` - a handshake key prefix that must be defined on each Wufoo form's Webhook
* `WUFOO_DEFAULT_FORM` - the hash ID for the default signup form

Webhooks are used on Wufoo to send data back to Cohorts. Currently there are 2 webhooks in use:
* `admin/people` - This endpoint is used for new signups via any signup/registration Wufoo form.
* `admin/submissions` - This endpoint is for all other Wufoo forms (call out, availability, tests). It saves the results in the submissions model.

If a new signup form is added to Wufoo the form must be mapped so that the users can be added to the database.
* - Manually import the form from Wufoo into cohorts by going to the forms page and clicking on plus sign button on the upper right to pull updates from Wufoo. The form now exist in the rails application but does not have any mappings.
* - Add the mappings for your new form to `add_mappings_to_forms.rake`. The Field numbers can be found on wufoo under Form -> More -> API Information.
* - It is only necessary to add mappings for fields which are necessary for the creation of the user.
* - Run `rake add_mappings_to_forms:update` which will then run your rake mapping and add it to the DB.


#### Twilio

Twilio is used to send and receive text messages for sign up, notifications, and surveys. It is also used to schedule interviews and calls. There are 3 environment variables that need to be defined for Twilio:
* `TWILIO_ACCOUNT_SID` - your account identifier
* `TWILIO_AUTH_TOKEN` - your API key
* `TWILIO_NUMBER` - the phone number that will be used to send messages

Webhooks are used on Twilio to send messages to Cohorts. Set the following webhook on your Twilio phone number:
* `/twilio/receive`

#### Mailchimp & Mandrill

Mailchimp is used to create email campaigns and send email to segmented groups of people. Mandrill an SMTP service used to send one-off emails from the application. There are 4 environment variables that need to be defined for Mailchimp and Mandrill:
* `MAILCHIMP_API_KEY`
* `MAILCHIMP_LIST_ID`
* `MANDRILL_USERNAME`
* `MANDRILL_API_KEY`

Tests
-----
To run all tests and Rubocop:
```
bundle exec rake
```

Contributors
------------
##### CUTGroup:
* Chris Gansen (cgansen@gmail.com)
* Dan O'Neil (doneil@cct.org)
* Bill Cromie (bill@robinhood.org)
* Josh Kalov (jkalov@cct.org)

##### Ad Hoc:
* Dan O'Neil (danx@adhocteam.us)
* Nick Clyde (nick@adhocteam.us)
* Danny Chapman (danny@adhocteam.us)
* Scott Robbin (srobbin@gmail.com)
* Oren Fromberg (oren@adhocteam.us)
* Jesse Skeets (jesse@adhocteam.us)
* Brooks Johnson (brooks@adhocteam.us)

License
-------

The application code is released under the MIT License. See [LICENSE](LICENSE.md) for terms.
