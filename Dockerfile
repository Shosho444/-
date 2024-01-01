FROM ruby:3.2.2
ARG RUBYGEMS_VERSION=3.3.20
ENV TZ Asia/Tokyo
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn
RUN mkdir /rails_practice
WORKDIR /rails_practice
COPY Gemfile Gemfile.lock /rails_practice/
RUN bundle install
COPY package.json yarn.lock /rails_practice/
RUN yarn install
RUN yarn add daisyui
RUN yarn add @fortawesome/fontawesome-free
COPY . /rails_practice

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]