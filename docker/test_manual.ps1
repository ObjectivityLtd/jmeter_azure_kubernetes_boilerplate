 #build image (in bash)
 sh build.sh jmeter-chrome-selenium
 #confirm container has headless chrome
 docker run -v C:\Users\gstarczewski\repos\performance\IBR\wds\resources:/test --shm-size=2g --rm -it jmeter-chrome-selenium python /test/test.py
 #get inside the container
 docker run --shm-size=2g --rm -it jmeter-chrome-selenium bash
 #then run jmeter tests with selenium and webdriver subsamples
 jmeter -Jwebdriver.sampleresult_class=com.googlecode.jmeter.plugins.webdriver.sampler.SampleResultWithSubs -n -l result.csv -t selenium_test_chrome_headless.jmx
