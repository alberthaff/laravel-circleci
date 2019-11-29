# Laravel / Circle CI Docker-container

This package installs PHP along with the most common extensions.

All extensions that are required by Laravel Vapor is included.

## YAML snippet 

```yaml
version: 2.1

executors:
  php-mysql-executor:
    docker:
    - image: alberthaff/laravel-circleci:latest
    - image: circleci/mysql:8.0.0
      environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: database
        MYSQL_USER: user
        MYSQL_PASSWORD: pass
    working_directory: ~/laravel

jobs:
  build:
    executor: php-executor
    description: Prepare the environment
    steps:
    - checkout
    - run: mv ~/laravel/.env.circleCi ~/laravel/.env
    - restore_cache:
      keys:
      - composer-v1-{{ checksum "composer.json" }}
    - run: composer install -n --prefer-dist --ignore-platform-reqs
    - save_cache:
      key: composer-v1-{{ checksum "composer.json" }}
      paths:
      - vendor
    - persist_to_workspace:
      root: ~/
      paths:
      - laravel
  test:
    executor: php-mysql-executor
    description: Run the tests
    steps:
    - attach_workspace:
      at: ~/
    - run:
      name: Wait for MySQL Server to start
      command: dockerize -wait tcp://localhost:3306 -timeout 1m
    - run: php ~/laravel/vendor/phpunit/phpunit/phpunit --configuration ~/laravel/.circleci/phpunit.xml
workflows:
  build_and_test:
    jobs:
    - build
    - test:
      requires:
      - build
```

