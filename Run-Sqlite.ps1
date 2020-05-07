$db_path = 

"C:/Users/jgxu78/Main/Business-Intel/write_offs/write_off.db"

#"C:/Users/jgxu78/Main/Business-Intel/dnfb/dnfb.db"

$query_path = ""


start-process C:\binary\SQLite3\sqlite3.exe

Write-Output (".open {0}" -f $db_path )

<#
try{ Run-Sqlite -query_path  -db_path $db_path }

catch{  
  
   $ErrorMessage = $_.Exception.Message
   $FailedItem   = $_.Exception.ItemName
 
   Write-output "Error Message = " + $ErrorMessage  "Failed Item   = " + $FailedItem  
}

#>
<#
References:
    https://www.pdq.com/blog/using-powershell-and-sqlite/
#>


