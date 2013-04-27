# Digital tv guide
This project will aggregate tv series and will search for nzb files to automate downloading those.

## TODO
- Switch from paperclip to carrierwave

# Setup
```bash
cd 'projects'
git clone git@github.com:jewilmeer/tv-guide.git
cd tv-guide
bundle
bundle exec rake db:setup
bundle exec rails s
```
