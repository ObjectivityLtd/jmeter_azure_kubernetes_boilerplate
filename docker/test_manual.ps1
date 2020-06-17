 #build image (in bash)
 sh build.sh jmeter-chrome-selenium
 #on windows to test IBR app running on local (from powershell so mount works)
 docker run -v C:\Users\gstarczewski\repos\performance\IBR\wds\resources:/test --shm-size=2g --rm -it jmeter-chrome-selenium groovy /test/wds_docker.groovy
 docker run -v C:\Users\gstarczewski\repos\performance\IBR\wds\resources:/test --shm-size=2g --rm -it jmeter-chrome-selenium python /test/test.py
 #get inside the container
 docker run --shm-size=2g --rm -it jmeter-chrome-selenium bash
 #then run tests with selenium and multisteps
 jmeter -Jwebdriver.sampleresult_class=com.googlecode.jmeter.plugins.webdriver.sampler.SampleResultWithSubs -n -l result.csv -t selenium_test_chrome_headless.jmx
 #check result file is OK
