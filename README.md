# Magma-TIL

[Staging](https://ancient-island-39702.herokuapp.com/) 

### Install
Follow these setup steps:

```sh
$ git clone https://github.com/magma-labs/hr-til
$ cd hr-til
$ gem install bundler
$ bundle install
$ cp config/application.yml{.example,}
$ rake db:create db:migrate db:seed
$ rails s
```

In development, `db:seed` will load sample data for channels, developers, and
posts. Omit this command to opt-out of this step, or create your own sample
data in `db/seeds/development.rb`.

To allow users from a domain, multiple domains, or a
specific email to log in, set those configurations in your environmental
variables:

```yml
# config/application.yml

permitted_domains: 'magmalabs.io'
```

### Testing

Run all tests with:

```
$ rake
```
Note: test suite has not been refactored 

### Dependencies

- The gem `selenium-webdriver` depends on the Firefox browser.

### Environmental Variables

# Not implemented for magma:
`slack_post_endpoint` allows the app to post to [Slack](https://slack.com/):

```yml
# config/application.yml

slack_post_endpoint: /services/some/hashes
```
