# svn-ci-tests
Health check for Sub Version repositories using Ruby Rspec.

## Background

At a client project the mandated SVN workflow involved a common development "branch" (AKA "trunk" in most organisations), and release "tags". The release "tags" contain a subset of the code objects within the development branch/trunk. As such it is difficult to perform diffs against tag and branch/trunk (due the tag being a subset).

This project performs this analysis to ensure that the tag and development branch are syncronised prior to release. Other checks around SVN best practices are also performed.

Initially designed to be used with a CI tool such as Jenkins. RSpec test output is generated in JUnit XML format (in ```spec/reports/SPEC-Svn.xml```) via [CI::Reporter::RSpec](https://github.com/ci-reporter/ci_reporter_rspec).


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

- run tests:
```
rake
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

# Requirements

- environment variable ```$WORKSPACE``` pointed to svn working copy (this is already set when using Jenkins
- environment variable ```$SVN_URL``` set to "tag" folder url (this is already set when using Jenkins and svn integration)
- svn installed

