FROM ruby:2.6.0
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
COPY . .

EXPOSE 3000

COPY Gemfile Gemfile.lock ./
ENV LANG C.UTF-8

RUN gem update bundler
RUN bundle install
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt install -y nodejs
RUN npm install
RUN rm ./config/credentials.yml.enc
RUN EDITOR=nano rails credentials:edit
RUN bin/rails db:migrate RAILS_ENV=production
RUN rake assets:precompile

CMD ["rails", "s", "-e", "production"]
