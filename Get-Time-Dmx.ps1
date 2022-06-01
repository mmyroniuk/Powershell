Import-Module "C:\Users\jgxu78\Main\Code\PowerShell\Modules\Data-Tools.psm1"

$target_path = "C:\Users\jgxu78\Desktop"
$holidays = ('1-1','5-25','7-4','9-7','11-26','12-25')


$year       = (Get-Date).AddYears(0).ToString("yyyy")
$begin_date = [datetime]::ParseExact(("{0}-01-01" -f $year), "yyyy-MM-dd", $null)
$end_date   = [datetime]::ParseExact(("{0}-12-31" -f $year), "yyyy-MM-dd", $null)
$total_days = ($end_date-$begin_date).Days

$busy_days = 0
$day_count = 0
$week = 0
$year_week = 0

$is_holiday = ''
$is_business_day = ''
$date_dmx = @()


if($year % 4 -eq 0)
{
    $total_days +=1
}

$date = ($begin_date).AddDays($day_count)
$month = (($date).AddMonths(0)).ToUniversalTime().Month
$month_name = $month | % {(Get-Culture).DateTimeFormat.GetMonthName($_)}



while ($day_count -lt $total_days) {
    
    $is_holiday = 'N'
    
    if ($tmp_month -gt $month) {

        $month = (($date).AddMonths(0)).ToUniversalTime().Month
        $month_name = $month | % {(Get-Culture).DateTimeFormat.GetMonthName($_)}
        $busy_days = 0
        $week = 0
    }
    if (("{0}-{1}" -f $date.Month, $date.Day) -in $holidays){
       $is_holiday = 'Y'    
       $is_business_day = 'N'
    }
    elseif ($date.DayOfWeek -eq "Saturday") {
       $busy_days = $busy_days
       $is_business_day = 'N'
    }  
    elseif ($date.DayOfWeek -eq "Sunday") {
      $week +=1
      $year_week+=1
      $is_business_day = 'N'
    }
    else {
        $busy_days +=1
        $is_business_day = 'Y'
    }
    
    #write-output $date $busy_days
    
    $day_count+=1
    $ps_obj = New-Object -TypeName psobject |

    Add-Member -MemberType NoteProperty -Name day_name	        -Value $date.DayOfWeek	 -PassThru |    
    Add-Member -MemberType NoteProperty -Name month_name	    -Value $month_name       -PassThru |   
    Add-Member -MemberType NoteProperty -Name month_day_number	-Value $date.Day	     -PassThru |  
    Add-Member -MemberType NoteProperty -Name year_day_number	-Value $day_count	     -PassThru |  
    Add-Member -MemberType NoteProperty -Name business_day_num  -Value $busy_days        -PassThru |  
    Add-Member -MemberType NoteProperty -Name is_business_day	-Value $is_business_day  -PassThru |  
    Add-Member -MemberType NoteProperty -Name year	            -Value $year	         -PassThru |  
    Add-Member -MemberType NoteProperty -Name month_number	    -Value $month	         -PassThru |   
    Add-Member -MemberType NoteProperty -Name week	            -Value $week	         -PassThru |    
    Add-Member -MemberType NoteProperty -Name year_Week	        -Value $year_week	     -PassThru |     
    Add-Member -MemberType NoteProperty -Name is_holiday        -Value $is_holiday       -PassThru 
   $date_dmx += $ps_obj   
   
    $date = ($begin_date).AddDays($day_count) 
       
    $tmp_month = (($date).AddMonths(0)).ToUniversalTime().Month

}
Export-PSObj-To-Piped-Csv -array $date_dmx -path $target_path -file 'time_dmx'
