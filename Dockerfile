# syntax=docker/dockerfile:1
FROM ruby:2.7.1
# prepare the app directory and set it as the working directory
RUN apt-get update -qq && apt-get install -y --force-yes nodejs postgresql-client
VOLUME .:/myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
# install the gems required for the app but first remove the existing bundler
RUN gem uninstall bundler
RUN gem install bundler -v  2.2.9
#RUN bundle install --without development test
RUN bundle install
# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
# Configure the main process to run when running the image
#CMD ["rails", "--version"]
CMD ["rails", "server", "-b", "0.0.0.0"]







