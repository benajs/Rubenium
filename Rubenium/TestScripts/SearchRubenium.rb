# author Benasir Jailabudeen
# description Sample test script
class SearchRubenium

  require_relative "../controls/SeleniumControls.rb"
  
  result="";

  def start(inputs)

    SeleniumControls.typeByName("q","Rubenium")
    SeleniumControls.clickByName("btnG")
    SeleniumControls.waitText("results")

    result=SeleniumControls.screenshot();
    return result;
  end
end