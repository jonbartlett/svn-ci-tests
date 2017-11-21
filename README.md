# svn-ci-tests

Health check for Sub Version repositories using Ruby Rspec.

## Background

This project was created to overcome some of the tedious manual checks on SVN when branching and tagging. The main objective was to automate the diff between branches where the branched version contains a subset of the source branch.

Other tests were then added to ensure SVN integrity.

Initially designed to be used with a CI tool such as Jenkins. RSpec test output is generated in JUnit XML format (in ```spec/reports/SPEC-Svn.xml```) via [CI::Reporter::RSpec](https://github.com/ci-reporter/ci_reporter_rspec).

## The Tests

### 1: Differences between two branches (i.e. trunk and tag)

On a client project the SVN workflow involved a common development "branch" (AKA "trunk" in most organisations), and release "tags". The release "tags" contain a subset of the code objects within the development branch/trunk. As such it is difficult to perform diffs against tag and branch/trunk (due the tag being a subset).

This test performs this analysis to ensure that the tag and development branch are syncronised prior to release.

Defined the source and branched repo URL in ```.config``` as environment variables below (the latter takes precedence).

Implemented in:

```spec/lib/svn_diff_spec.rb```

Usage:

```rspec spec/lib/svn_diff_spec.rb```

Environment variables:

```
  export DIFF_SOURCE_URL = svn://dwp07/EDW/branches/project
  export DIFF_BRANCHED_URL = svn://dwp07/EDW/branches/project
```

.config:

```
diff_check:
  source_url: svn://dwp07/EDW/trunk
  branched_url: svn://dwp07/EDW/tags/CR/CR20370
```

### 2: Files that exist in tag but not branch

Code objects are 'tagged' from the branch to tag for release. Not code objects should be directly added to the tag. This test checks for objects that are in the tag but do not exist in the branch.

Defined the source and branched repo URL in ```.config``` as environment variables below (the latter takes precedence).

Implemented in:

```spec/lib/svn_diff_spec.rb```

Usage:

```rspec spec/lib/svn_diff_spec.rb```

Environment variables:

```
  export DIFF_SOURCE_URL = svn://dwp07/EDW/branches/project
  export DIFF_BRANCHED_URL = svn://dwp07/EDW/branches/project
```

.config:

```
diff_check:
  source_url: svn://dwp07/EDW/trunk
  branched_url: svn://dwp07/EDW/tags/CR/CR20370
```

### 3: SVN Keywords present on all objects

A simple scan over all SVN objects within a given branch for the presence of SVN keyword properties. Can run over a remote SVN repo or on local files (quicker and most convenient when using Jenkins which will checkout a local svn working copy). 

Modify section ```keyword_check``` in file ```.config``` to specifiy remote or local use and the files that should be checked for keywords.

If running against a remote SVN repo, specify the remote repo URL in ```.config``` section ```keyword_check:svn_url```. Or set env variable ```KEYWORD_URL``` which will take precedence. 

Implemented in:

```spec/lib/svn_keywords_spec.rb```

Usage:

```rspec spec/lib/svn_keywords_spec.rb```

Environment variables:

```
  export KEYWORD_URL = svn://dwp07/EDW/branches/project
```

.config:

```
keyword_check:
  run_remote: true
  svn_url: svn://d07/EDW/tags/CR/CR20370
  files:
  - ".ksh"
  - ".sh"
  - ".ddl"
  - ".sql"
  - ".pls"
  - ".pks"
  - ".pkb"
  - ".java"
```

### 4: Common code objects changed between branches

Two projects were running concurrently and potentially modifiy the same objects in different SVN branches. This test highlights where changes are made to objects in one branch that also exist in a specified other branch. Also used to highlight changes to production branches made by other projects or production support.

Designed to be run from Jenkins which monitors the non-project branch. Only files changed since the last test run are identified.

Now writes to a CSV file when ```write_csv: true``` property set. This can be emailed via Jenkins 'Editable Email Notification' functionality.

Implemented in:

```spec/lib/svn_clash_spec.rb```

Usage:

Set project and non-project svn URLs as either environment variables or in the ```.config``` file (the former takes precedence).

Environment variables:

```
  export CLASH_PROJECT_URL = svn://dwp07/EDW/branches/project
  export CLASH_NON_PROJECT_URL = svn://dwp07/EDW/branches/dev_jbartlett/non_project
```

.config:

```
clash_check:
  project_url: svn://d07/EDW/branches/stellar
  non_project_url: svn://d07/EDW/branches/dev_jbartlett/CR20370
  write_csv: true
```

### 5: Monitor all changes to a branch

This is a simple test that returns all changes to a branch between test runs. Changes show up as test failures that can be processed by Jenkins or other CI tool. Handy for monitoring production / trunk branches to highlight re-integration work into a project branch. Essentially this is just a fancy reporting wrapper around ```svn diff```.

Writes to a CSV file when ```write_csv: true``` property set. This can be emailed via Jenkins 'Editable Email Notification' functionality.

Implemented in:

```spec/lib/svn_monitor_spec.rb```

Usage:

Set monitor svn URLs as either environment variables or in the ```.config``` file (the former takes precedence).

Environment variables:

```
  export MONITOR_URL = svn://dwp07/EDW/trunk
```

.config:

```
monitor:
  monitor_url: svn://djwp07/EDW/trunk
  write_csv: true
```

## Usage

- clone this repo
- edit ```.config.yaml```
- install ruby dependencies:

```
gem install bundler
bundle install
```

- run all tests:
```
rake
```

- in Jenkins (or other CI tool) execute build shell:

```
cd $WORKSPACE/svn-ci-tests # assuming git repo is here
gem install bundler
bundle install
# set CI_REPORTS env used by RSpec CI Reporter (https://github.com/ci-reporter/ci_reporter)
export CI_REPORTS="$WORKSPACE/.test/reports"
# create .test directory if not already exists
mkdir -p $CI_REPORTS
rake
```

- setup post build action to read JUnit test report found in ```svn-ci-tests/spec/reports```

# Requirements

- svn installed

