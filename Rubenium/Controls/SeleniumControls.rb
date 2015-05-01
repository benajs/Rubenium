# author Benasir Jailabudeen
# description Selenium Controls to perform various actions in Selenium

class SeleniumControls
  require 'rubygems'
  require 'selenium-webdriver'
  require 'logger'
  #  require "chromedriver-helper"
  $LOG = Logger.new('log_file.log', 'daily')
  @wait = Selenium::WebDriver::Wait.new(:timeout => 5)

  def self.startBrowser (url,browser)
    @url = url
    @browser = browser
    #Browser values are firefox,chrome,ie,safari
    @driver = Selenium::WebDriver.for :"#@browser"
    @driver.get "#@url"
    $LOG.info("Browser Started... \nPage title is #{@driver.title} in browser #@browser ")
  end

  def self.typeByName (attrib,value)
    @attrib=attrib
    @value=value
    element = @driver.find_element :name => "#@attrib"
    element.send_keys "#@value"
    $LOG.info("Typed text #@value in #@attrib")
  end

  def self.typeById (attrib,value)
    @attrib=attrib
    @value=value
    element = @driver.find_element :id => "#@attrib"
    element.send_keys "#@value"
    $LOG.info("Typed text #@value in #@attrib")
  end

  def self.clickByid (attrib)
    @attrib=attrib
    element = @driver.find_element :id => "#@attrib"
    element.click
    $LOG.info("Clicked element Id #@attrib")
  end

  def self.clickByName (attrib)
    @attrib=attrib
    element = @driver.find_element :name => "#@attrib"
    element.click
    $LOG.info("Element clicked by Name  #@attrib")
  end

  def self.clickByCss (attrib)
    @attrib=attrib
    element = @driver.find_element :css => "#@attrib"
    element.click
    $LOG.info("Element clicked by CSS  #@attrib")
  end

  def self.clickByXpath (attrib,value,isExact)
    @attrib=attrib
    @value=value
    if(isExact)
      element = @driver.find_element :xpath => "//*[#@attrib='#@value']"

    else
      element = @driver.find_element :xpath => "//*[contains(#@attrib,'#@value')]"
    end
    element.click
    $LOG.info("Element clicked by Name  #@attrib")
  end

  def self.clickByText (value,isExact)
    @value=value
    waitText(@value)
    if(isExact)
      element = @wait.until {
        element1 =  @driver.find_element :xpath => "//*[text()='#@value']"
        element1 if element1.displayed?
      }

    else
      element =@wait.until {
        element1 =  @driver.find_element :xpath => "//*[contains(text(),'#@value')]"
        element1 if element1.displayed?
      }
    end
    @driver.action.move_to(element)
    element.click
    $LOG.info("Element clicked by Text  #@value")
  end

  def self.pageSubmit (attrib)
    @attrib=attrib
    element = @driver.find_element :id => "#@attrib"
    element.submit
    $LOG.info("Page submitted using Id #@attrib")

  end

  def self.waitTitle (text)
    @text=text
    @wait.until { @driver.title.downcase.start_with? "#@text" }
    $LOG.info("Browser with title #@text is displayed")

  end

  def self.waitText (text)
    @text=text
    begin

      element = @wait.until {
        element1 =  @driver.find_element :xpath => "//*[contains(text(),'#@text')]"
        element1 if element1.displayed?
      }
      element.location_once_scrolled_into_view

      $LOG.info("Waited for text #@text till displayed")
      return true
    rescue Exception => e
      $LOG.error("Exception thrown: "+e.message())
      $LOG.error(e.backtrace.inspect)
      return false
    end

  end

  def self.scrollText (text)
    begin
      @text=text
      waitText(@text)
      element = @driver.find_element :xpath => "//*[contains(text(),'#@text')]"
      element.location_once_scrolled_into_view
      $LOG.info("Scrolled to text  #@text is displayed")
    rescue Exception => e
      $LOG.error("Exception thrown: "+e.message())
      $LOG.error(e.backtrace.inspect)
    end

  end

  def self.selectByText (value)
    @value=value

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath => "//select"))
    print option
    option.select_by(:text, value)

    $LOG.info("Selected text #@value ")
  end

  def self.selectByText (attrib,value)
    @value=value
    @attrib=attrib
    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath => "//select[@name='"+@attrib+"']"))
    print option
    option.select_by(:text, value)

    $LOG.info("Selected text #@value ")
  end

  def self.closeBrowser
    begin
      @driver.quit
      $LOG.info("Browser closed successfully")
    rescue Exception => e
      $LOG.error("Exception thrown: "+e.message())
      $LOG.error(e.backtrace.inspect)
    end
  end

  def self.screenshot
    timestamp = Time.now.getutc
    #ScreenShots
    filename=timestamp.strftime("ScreenAt_%Y%m%d%H%M%S.png")
    @driver.save_screenshot("./Results/"+filename)
    return filename
  end

  def self.actionByText(text)
    element =@wait.until {
      element1 =  @driver.find_element :xpath => "//*[contains(text(),'#@value')]"
      element1 if element1.displayed?
    }
    @driver.action.move_to(element).click
  end

  def self.uploadfile(filename)
    file = File.join(Dir.pwd, filename)

    @driver.find_element(id: 'file-upload').send_keys file
    @driver.find_element(id: 'file-submit').click

    uploaded_file = @driver.find_element(id: 'uploaded-files').text
  end

  def self.upload(filename)
    file = File.join(Dir.pwd, filename)
    alert = @driver.switch_to.alert
    alert.send_keys file
    @driver.find_element(id: 'file-upload').send_keys file
    @driver.find_element(id: 'file-submit').click

    uploaded_file = @driver.find_element(id: 'uploaded-files').text
  end

end

