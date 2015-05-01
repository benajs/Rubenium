# author Benasir Jailabudeen
# description Executes the test scripts based on the keywords in Setup.yml file

class StartExecution

  require "yaml"
  require "csv"
  require_relative "../controls/SeleniumControls.rb"
  require_relative "../controls/Reports.rb"

  properties = YAML.load_file("./Setup.yml")

  # Requires the relative Testscripts in to this class for execution
  path= "#{properties['SCRIPT_DIRECTORY']}"
  Dir.foreach(path) do |item|
    next if item == '.' or item == '..'
    if(path.start_with?("."))
      require_relative File.join(File.expand_path("."), path.split(".").last() +item)
    else
      require_relative File.join( path +item) ;
    end
  end

  directory_name = "Results"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  #variables
  testSuiteName=""
  testStatus=""
  starttime = Time.now.getutc

  #Start Controls
  begin
    Reports.table("Execution Details",Array["Browser","Test Details","Start time","End Time","Duration in Secs"])
    Reports.table("Test Result",Array["Test Case","Test result","Exception","Screenshot"])

    #Start Browser
    SeleniumControls.startBrowser("#{properties['URL']}","#{properties['BROWSER']}")

    CSV.foreach("#{properties['INPUT_FILE']}", :headers => true) do |row|
      begin
        an_object =  Object::const_get(row[0]).new

        testSuiteName=row[2]
        $LOG.info("Processing Test suite "+testSuiteName+" using class "+row[0]+"\n")
        testStatus= an_object.start(row[1])

        Reports.updateResult("Test Result",Array[testSuiteName,"Pass","",testStatus],true)

      rescue Exception => e
        testStatus=SeleniumControls.screenshot()
        Reports.updateResult("Test Result",Array[testSuiteName,"Fail",e.message(),testStatus],false)
        $LOG.error(e.message())
        $LOG.error(e.backtrace.inspect)
        next
      end
    end

  rescue Exception => e
    $LOG.error(e.message())
    Reports.updateResult("Test Result",Array["Test Execution","Fail",e.message(),""],false)
    $LOG.error(e.backtrace.inspect)

  end

  begin
    #Exit
    SeleniumControls.closeBrowser()
    endtime = Time.now.getutc
    duration = endtime-starttime

    Reports.insertRecord("Execution Details",Array["#{properties['BROWSER']}".upcase,"#{properties['PROJECT']}",starttime.to_s,endtime.to_s,duration.to_s])
    Reports.closetable("Execution Details")
    Reports.closetable("Test Result")
    Reports.writeFile()
  rescue Exception => e
    $LOG.error(e.message())
    $LOG.error(e.backtrace.inspect)

  end

end