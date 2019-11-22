FROM ruby:2.6.3

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install --jobs=8 --without development test
ADD . /app
CMD ["unicorn", "-c", "./config/unicorn.rb"]
