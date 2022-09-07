# README

Docker instruction:
  - Install Docker and Docker compose
  - Run $ docker compose build
  - Run $ docker compose run -p 3000:3000 web
  - open other terminal and run $ docker compose run web bundle exec "rake db:migrate db:seed"
