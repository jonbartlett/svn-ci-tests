# svn-ci-tests
Health check for SVN repositories.

Designed to be used with a CI tool such as Jenkins.

Currently checks:

1. Differences between two branches (i.e. trunk and tag) - file contents and missing files
2. SVN Keywords present on all objects

Future checks:

3. Files change directly in a tag



## Usage

- clone this repo
- edit ```.config.yaml```
- install ruby dependencies:

```
gem install bundler
bundle install
```

- in Jenkins (or other CI tool) execute build shell:

```
cd $WORKSPACE/svn-ci-tests
gem install bundler
svn upgrade $WORKSPACE
bundle install
rake
```

- setup post build action to read JUnit test report found in ```svn-ci-tests/spec/reports```

# Requires

- ```environment variable ```$WORKSPACE``` pointed to svn working copy (this is already set when using Jenkins.
- svn

