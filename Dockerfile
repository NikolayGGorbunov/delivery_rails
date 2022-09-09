# syntax=docker/dockerfile:1
FROM ruby:3.0.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
ENV BUNDLE_PATH /gems
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install
COPY . /myapp/


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["server", "-b", "0.0.0.0"]
EXPOSE 3000
