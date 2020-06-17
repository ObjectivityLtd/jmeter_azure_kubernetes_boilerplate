#!/usr/bin/env bats

load $HOME/test/'test_helper/batsassert/load.bash'
load $HOME/test/'test_helper/batscore/load.bash'


test_image_name=jmeter-chrome-selenium-test
run_opts="--shm-size=2g --rm -it"

# setup_file does not work well for this, so I build docker image in first test as an ugly but stable work-around
# whover knows how to fix it, you get a beer. Rememeber this case is equivalent of setup_file.
@test "IT: Docker Image Builds Successfully" {
  docker image rm $test_image_name ||:
  docker build -t $test_image_name -f Dockerfile .
}

@test "IT: Image is on the list" {
  run docker image ls $test_image_name
  #Then it is successful
  assert_output --partial $test_image_name
}

@test "IT: Python 2.7.17 is installed" {
  run docker run  $run_opts $test_image_name python --version
  #Then it is successful
  assert_output --partial "Python 2.7.16"
}

@test "IT: Groovy 2.4.16 is installed" {
  run docker run $run_opts $test_image_name groovy --version
  #Then it is successful
  assert_output --partial "Groovy Version: 2.4.16"
}

@test "IT: Chromedriver 83.0.4103.39 is installed" {
  run docker run $run_opts $test_image_name chromedriver --version
  #Then it is successful
  assert_output --partial "ChromeDriver 83.0.4103.39"
}

@test "IT: Chrome 83.0.4103.6 is installed" {
  run docker run $run_opts $test_image_name google-chrome --version
  #Then it is successful
  assert_output --partial "Google Chrome 83.0.4103.61"
}

@test "IT: OpenJDK 1.8.0_252 is installed" {
  run docker run $run_opts $test_image_name java -version
  #Then it is successful
  assert_output --partial "1.8.0_252"
}

@test "IT: Chrome Headless works fine when used in python script" {
  #WHEN I run test that use chrome headless
  run docker run $run_opts $test_image_name python test.py
  #Then they are successful
  assert_success
}

@test "IT: JMeter 5.0 is present" {
  #WHEN I run test that use chrome headless
  run docker run $run_opts $test_image_name jmeter --version
  #Then they are successful
  assert_output --partial "5.0 r1840935"
}

@test "IT: JMeter WebDriver Sampler scenario with Chrome Headless is run fine within the container" {
  local result_file=results.csv
  local test_scenario=selenium_test_chrome_headless.jmx
  #WHEN I run a jmeter test that use chrome headless and webdriver and I print result file to stdout
  run docker run $run_opts $test_image_name jmeter -Jwebdriver.sampleresult_class=com.googlecode.jmeter.plugins.webdriver.sampler.SampleResultWithSubs -n -l $result_file -t $test_scenario
  #Then test is a success
  refute_output --partial CannotResolveClassException
}