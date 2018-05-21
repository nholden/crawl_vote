# Crawl Vote
Helps groups on the move choose a next spot

## Installation
```
git clone git://github.com/nholden/crawl_vote
cd crawl_vote
brew install redis postgresql heroku
bundle install
yarn
cp .env.example .env
bundle exec rake db:reset
```

## Getting started
Sign up for a Pusher Channels app at  [https://pusher.com/signup](https://pusher.com/signup) and a Yelp API key at [https://www.yelp.com/developers/documentation/v3](https://www.yelp.com/developers/documentation/v3) and update `.env`.

Start these long-running processes in separate terminal windows:

```
heroku local
webpack-dev-server
```

Crawl Vote should be accessible at http://localhost:3345 (or whichever port you specify in `.env`).

## Testing
```
bundle exec rspec
```

## Contributing
Contributions are welcome from everyone! Feel free to make a pull request or use GitHub issues for help getting started, to report bugs, or to make feature requests.

## License
This project was created by [Nick Holden](https://www.nickholden.io) and is licensed under the terms of the MIT license.
