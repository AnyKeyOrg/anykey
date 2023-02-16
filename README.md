AnyKey
======
Repository for the anykey.org v2.0 website which includes the relaunched GLHF pledge and custom moderation system.

The app currently runs on Ruby 2.6.3, Rails 6.0.0.rc1, MySQL, and Redis. It is recommended that you use [asdf](https://asdf-vm.com) to install and manage your rubies.

Environment Configuration
-------------------------
Follow these general steps to set up your local development environment from scratch.

**1. Fork & clone this repo**
* Click fork in the upper right hand corner of the AnyKey GitHub page
* Then create a local copy of your fork with:
* `git clone git@github.com:<username>/anykey.git`

**2. Install MySQL 8 (app database)**
* Download: https://dev.mysql.com/downloads/mysql
* Choose "Use Legacy Password Encryption"
* After install make sure you add `/usr/local/mysql/bin` (or equivalent) to your path

**3. Install Redis (cache database)**
* Learn more here: https://redis.io/topics/quickstart
* `mkdir redis && cd redis`
* `curl -O http://download.redis.io/redis-stable.tar.gz`
* `tar xzvf redis-stable.tar.gz`
* `cd redis-stable`
* `make`
* `make test`
* `sudo make install`
* Verify redis binaries are in /usr/local/bin and remove install folder

**4. Install ImageMagick (image processing software)**
* Learn more here: https://imagemagick.org/script/download.php
* `brew install imagemagick`
* Run `convert -version` tp ensure crucial ImageMagick command has been installed

**5. Install asdf (Ruby version manager)**
* Learn more here: https://asdf-vm.com/guide/getting-started.html
* `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1`
* Add two lines at the end of bash_profile:
```shell
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
```
* Run `asdf --version` to confirm it returns info
* Configure asdf to accept legacy files:
* `echo "legacy_version_file = yes" >> ~/.asdfrc`

**6. Install Ruby 2.6.3 via asdf**
* Learn more here: https://www.ruby-lang.org/en/documentation/installation
* Install system dependencies via Homebrew:
  * `brew install openssl readline`
  * `brew install ruby-build`
  * `brew install shared-mime-info`
* Add asdf Ruby plugin:
  * `asdf plugin add ruby`
  * `asdf list all ruby`
* Install Ruby:
  * Set these flags on M1 Macs:
    * `export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"`
    * `export RUBY_CFLAGS="-Wno-error=implicit-function-declaration"`
  * `asdf install ruby 2.6.3`
  * `asdf global ruby 2.6.3` (creates ~/.tool-versions)
  * `asdf local ruby 2.6.3` (create .tool-versions file in repo)
* Make sure you are using Ruby 2.6.3 before proceeding:
  * `cd anykey` then `ruby -v` to check your version

**7. Install essential gems**
* Disable gem docs:
  * `echo "gem: --no-document" >> ~/.gemrc`
* Install Rails 6.0.0.rc1:
  * `gem install rails --version 6.0.0.rc1`
* Install MySQL gem:
  * `gem install mysql2`
  * Use the `-- --with-opt-dir="$(brew --prefix openssl@1.1)"` flag on M1 Macs
* Install required gems:
  * `bundle install`

**8. Configure database environment variables**
* Add a file called `.env` to your app's root directory
* Ensure that it includes the correct credentials for your database:

```shell
MYSQL_USERNAME=XXX
MYSQL_PASSWORD=YYY
MYSQL_SOCKET=/tmp/mysql.sock              # For Mac
MYSQL_SOCKET=/var/run/mysqld/mysqld.sock  # For Windows
```

**9. Configure Amazon S3 bucket**
* Learn more here: https://aws.amazon.com/s3
* Create a new bucket for development testing
* Add the relevant credentials to your `.env` file:

```shell
AWS_BUCKET=bucket-name
AWS_ACCESS_KEY_ID=XXX
AWS_SECRET_ACCESS_KEY=YYY
AWS_REGION=region-name
```

**10. Create database in MySQL**
* Run either `rake db:create`
* Or `mysql -u root -p` and `CREATE DATABASE anykey_development;`

**11. Seed database and run migrations**
* `rake db:seed`
* `rake db:migrate`

**12. Confirm app runs**
* Launch Redis: `redis-server`
* Launch the app: `rackup`
* Open http://localhost:9292 (or http://127.0.0.1:9292) in a browser
* You should see AnyKey homepage


External API configuration
--------------------------
The AnyKey app uses several external services:
* AWS S3 for storing staff-uploaded images and thumbnails (cached via Redis)
* Sendgrid for transactional email
* Stripe for donation payments
* Twitch for GLHF pledge badge assignment and moderation

In order to test all of the features in your development environment you will have to add additional credentials to your `.env` file. These credentials are only available to trusted collaborators and can be obtained from the repository manager.

Note that the `TWITCH_REDIRECT_URL` must be set in both the external Twitch app and the local development environment. A separate Twitch app should be created by the developer for local testing purposes.

```shell
SENDGRID_USERNAME=XXX
SENDGRID_PASSWORD=YYY
SENDGRID_DOMAIN=anykey.org


TWITCH_AUTH_BASE_URL=https://id.twitch.tv
TWITCH_API_BASE_URL=https://api.twitch.tv/helix
TWITCH_PLEDGE_BASE_URL=https://api.twitch.tv/ent/chat/badges/pledge
TWITCH_CLIENT_ID=XXX
TWITCH_CLIENT_SECRET=YYY
TWITCH_PLEDGE_SECRET=ZZZ
TWITCH_REDIRECT_URL=http://localhost:9292/pledge
```

License
-------
Copyright 2019-2022, AnyKey

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see https://www.gnu.org/licenses.
