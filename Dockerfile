FROM ruby:2.5.1

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs=8 --without development test
ADD . /app
CMD ["unicorn", "-c", "./config/unicorn.rb"]
