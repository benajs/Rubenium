# author Benasir Jailabudeen
# description HTML Reporting Framework for Test Reports

class Reports
  htmlContent="<HTML>
 \n <style >
  \n
  \n  body {
  \n      font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;
  \n      font-size: 11px;
  \n      background-color:#1EA9C1;
  \n     }
  \n  table.resulttable {
  \n      font-family: verdana,arial,sans-serif;
  \n      font-size:11px;
  \n      color:#333333;
  \n      border-color: #a9c6c9;
  \n      border-collapse: collapse;
  \n      width:100%;
  \n     }
  \n  table.resulttable th {
  \n      background-color:#c3dde0;
  \n      border-width: 1px;
  \n      padding: 8px;
  \n      border-style: solid;
  \n      border-color: #a9c6c9;
  \n      font-weight: bold;
  \n    }
  \n  table.resulttable tr:nth-child(even) {
  \n      background-color:#fff;
  \n      height:38px;
  \n    }
  \n  table.resulttable tr:hover {
  \n      background-color: FFF88E;
  \n    }
  \n  table.resulttable tr:nth-child(odd) {
  \n      background-color:#B4EFF9;
  \n      height:38px;
  \n    }
  \n  table.resulttable tr:hover {
  \n      background-color: FFF88E;
  \n    }
  \n  table.resulttable td {
  \n      border-width: 1px;
  \n      padding: 8px;
  \n      border-style: solid;
  \n      border-color: #a9c6c9;
  \n      max-width: 100px;
  \n      word-wrap:break-word;
  \n    }
  \n  span.head{
  \n      background-color:#B602B3;
  \n      color:white;
  \n      padding: 8px;
  \n      font-size:15px;
  \n      font-weight: bold;
  \n    }
  \n  span.subhead{
  \n      background-color:#DD0466;
  \n      color:white;
  \n      padding: 4px;
  \n      font-size:13px;
  \n      font-weight: bold;
  \n    }
  \n  span.pass{
  \n      color:green;
  \n      font-weight: bold;
  \n    }
  \n  span.fail{
  \n      color:red;
  \n      font-weight: bold;
  \n    }

  \n\n<\/style>\n\n<BR>
  \n<Head>\n\t<H1><span class=\"head\"> Consolidated Result <\/H1> \n<\/Head>\n\n<Body>"
  @@htmlTable ={"Consolidated Result"=>htmlContent}

  def self.table(tableName, columns)
    @tableName=tableName;
    @columns=columns;

    tableheader= "\n<BR>\n\t<table class=\"resulttable\" ><span class=\"subhead\"> #@tableName \n\t\t<tr>"
    for column in @columns
      tableheader=tableheader+" \t<th> "+column+" </th>"
    end
    tableheader=tableheader+" \t</tr>\n"
    @@htmlTable[@tableName]=tableheader

  end

  def self.updateResult(tableName,columns,isPass)
    @tableName=tableName
    @columns=columns

    #sets background color
    tableheader= @@htmlTable[@tableName] +" \n\t\t<tr>"

    if(isPass)
      status="\t<td> <span class=\"pass\"> "+@columns[1]+" </td>";
    else
      status= "\t<td> <span class=\"fail\"> "+@columns[1]+" </td>";
    end

    exception= "\t<td> <span class=\"fail\"> "+@columns[2]+" </td>";

    
    imageURL=" ";
    if(""!=@columns[3])
      imageURL="\n\t\t\t<a href=\"./"+@columns[3]+"\" target=\"_blank\">\n\t\t\t\t<IMG src=\""+@columns[3]+"\"height=\"100\" width=\"300\" ></a>";
    end

    tableheader=tableheader+" \t<td> "+@columns[0]+" </td>"+status+exception+" \t<td>"+imageURL+" </td>";
    tableheader=tableheader+" \t</tr>\n"
    @@htmlTable[@tableName]=tableheader
  end

  def self.insertRecord(tableName,columns)
    @tableName=tableName
    @columns=columns
    tableheader= @@htmlTable[@tableName] +" \n\t\t<tr >"
    for column in @columns
      tableheader=tableheader+" \t<td> "+column+" </td>"
    end

    tableheader=tableheader+" \t</tr>\n"
    @@htmlTable[@tableName]=tableheader

  end

  def  self.closetable(tableName)
    @tableName=tableName
    tableheader= @@htmlTable[@tableName] +" \n\t</table><BR><BR>"
    @@htmlTable[@tableName]=tableheader
    #   puts "#{tableheader}"
  end

  def self.writeFile
    @@htmlTable["Close"]="\n</Body>\n</HTML>"
    stringBuffer=""
    for records in @@htmlTable.keys
      stringBuffer=stringBuffer+@@htmlTable[records]
    end
    #  puts "#{stringBuffer}"
    File.write('./Results/TestReport.html',"#{stringBuffer}" )

  end

end

