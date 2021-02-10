# Magma-TIL
The heroku App in Prod Points to [til.magmalabs.io](https://til.magmalabs.io/)
[Produdction](https://magma-til.herokuapp.com/) 

### Install
Follow these setup steps:

```sh
$ git clone https://github.com/magma-labs/til
$ cd til
$ gem install bundler
$ bundle install
$ cp config/application.yml{.example,}
$ rake db:create db:migrate db:seed
$ rails s
```

In development, `db:seed` will load sample data for channels, developers, and
posts. Omit this command to opt-out of this step, or create your own sample
data in `db/seeds/development.rb`.


```yml
Only accounts with @magmalabs.io emails are allowed

```

### Testing

Run all tests with:

```
$ rake
```
Note: test suite has not been refactored 


# Not implemented for magma:
`slack_post_endpoint` allows the app to post to [Slack](https://slack.com/):

```yml
# config/application.yml

slack_post_endpoint: /services/some/hashes
```
