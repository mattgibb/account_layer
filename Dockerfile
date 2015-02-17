FROM ubuntu:14.04
MAINTAINER Matt Gibb <matt@lendlayer.com>

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes \
  build-essential \
  curl \
  git \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libxslt-dev \
  libyaml-dev \
  zlib1g-dev

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN git clone https://github.com/aripollak/rbenv-bundler-ruby-version.git ~/.rbenv/plugins/rbenv-bundler-ruby-version
RUN ./root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
ENV PATH /root/.rbenv/shims:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Install ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.1.5
ENV RBENV_VERSION 2.1.5

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

# VOLUME ["log"]

ENV RAILS_ENV production

# install the app
RUN gem install bundler

COPY Gemfile Gemfile.lock /app/
RUN cd /app && rbenv local 2.1.5 && bundle
# COPY . /app
#
# WORKDIR /app
# EXPOSE 8080
# CMD ["unicorn_rails"]
