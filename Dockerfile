FROM ruby:2.6.5

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle config set without "development test"
RUN bundle install --jobs=8
ADD . /app
CMD ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]
