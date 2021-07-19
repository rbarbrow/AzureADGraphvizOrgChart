#set path of saved .dot file
$path = "C:\z\"
$dotfile ="\orgchart.dot"
#$orgfile = "\orgchart.svg"

$DOTpath =$path+$dotfile
#$ORGpath =$path+$orgfile


#array of names to ignore
$ignore = @("Blue Desk", "Bot", "Canary Bot", "Help", "Help Con", "Help Fin", "Help HR", "Help IT", "Help Marketing", "Help Office Admin", "Help Rec", "Help Sec", "Help Solutions", "HelpProp", "HQ Innovation Lab", "HQ Training Room", "HQ Well Room", "innovation.lab", "Peerless Admin", "Red Desk", "Yellow Desk","markon.training")

$ignoreOrphans = $FALSE
#$ignoreOrphans = $TRUE


#array of job title to color change as needed
$includeTitle = $true
$TitleColor = @{}
$TitleColor.Add("President","lightpurple") 
$TitleColor.Add("Vice President","purple")
$TitleColor.Add("Senior Director","Blue")
$TitleColor.Add("Director","Green")
$TitleColor.Add("Technical Director","Green")
$TitleColor.Add("Senior Manager","greenyellow")
$TitleColor.Add("Senior Specialist","Greenyellow")
$TitleColor.Add("Manager","Yellow")
$TitleColor.Add("Specialist","Yellow")
$TitleColor.Add("Senior Associate","Orange")
$TitleColor.Add("Senior Consultant","Orange")
$TitleColor.Add("Associate","Red")
$TitleColor.Add("Lead Associate","Red")
$TitleColor.Add("1099","Grey")
$TitleColor.Add("Intern","Grey1")


function CleanText([string]$text)
{
    $text = $text.Replace(" ","_")
    $text = $text.Replace(".","")
    $text = $text.Replace("'","")
    $text = $text.Replace("-","_")    
    Write-Debug $text
    return $text
}

#$graphvizPath = "C:\Program Files\Graphviz\bin\dot.exe"


#install module if needed
#Install-Module AzureAD 
#connect to azure AD (will prompt you sometimes it hides the window behind other things)
Connect-AzureAD

#grab a list of all memebers
$users = Get-AzureADUser -All $true | where-object {$_.UserType -eq 'Member'}

#create a stringbuilder object
$sb = new-object System.Text.StringBuilder

#setup the header of the .dot graphviz file
$sb.AppendLine("digraph{")
$sb.AppendLine("    layout = dot;")
$sb.AppendLine("    ranksep=10;")

#loop through each user 
#loop sets up def of each user and what colors should be assigined to their node
if($includeTitle){
    foreach ($user in $users) {
        $u = CleanText ($user.DisplayName)
        $sb.AppendLine($u+" [color="+$TitleColor[$user.JobTitle]+", style=filled]")
    }
}

#loop sets up the hierarchy 
foreach ($user in $users) {
   
    #checks to see if user is on the ignore list
     if(!$ignore.Contains($user.DisplayName) )  {
        
        #gets the manager for each user
        $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
        $u =CleanText($user.DisplayName)
        $m = CleanText($manager.DisplayName)
        #checks if the manager is null also replaces any spaces in the name
        if($null -eq $manager.DisplayName) 
        {
            if(!$ignoreOrphans){
                $sb.AppendLine(  "None -> " + $u ) 
            }
        }else {
            
            $sb.AppendLine($m + " -> "+ $u )
            
        }
    }
}
 
#terminal bracket for graphviz "script"
$sb.AppendLine("}")

#Cleanup  no space, no ., no ',
#$sb = $sb.Replace(".","")
#$sb = $sb.Replace("'","")  
#$sb = $sb.Replace("r-H","r_H")
$sb.ToString() | Out-File $DOTpath




#will add code to run graphviz dot.exe natively here
#dot -Tpng input.dot > output.png
#dot -Tps filename.dot -o outfile.ps
#cmd.exe /c C:\Program Files\Graphviz\bin\dot.exe -Tsvg $DOTpath -o $ORGpath