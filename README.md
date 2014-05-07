[![wercker status](https://app.wercker.com/status/620d072c7f20cc7a3e22860fda5cb64a/m/master "wercker status")](https://app.wercker.com/project/bykey/620d072c7f20cc7a3e22860fda5cb64a)

# Digital tv guide
This project will aggregate tv series and will search for nzb files to automate downloading those.

## TODO
- Switch from paperclip to carrierwave

# Setup
Install redis, and start it
```bash
cd 'projects'
git clone git@github.com:jewilmeer/tv-guide.git
cd tv-guide
cp config/database{.sample,}.yml
cp config/s3{.sample,}.yml
bundle
bundle exec rake db:setup
bundle exec rails s
```

Make sure to start the background processing
```bash
bundle exec sidekiq
```
