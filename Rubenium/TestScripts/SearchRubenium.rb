# author Benasir Jailabudeen
# description Sample test script
class SearchRubenium

  require_relative "../controls/SeleniumControls.rb"
  
  result="";

  def start(inputs)

    SeleniumControls.typeByName("q",inputs)
    SeleniumControls.clickByName("btnG")
    SeleniumControls.waitText("results")

    result=SeleniumControls.screenshot();
    return result;
  end
end
