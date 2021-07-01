
#set path of saved .dot file
$path = "C:\Users\rbarbrow\OneDrive - Markon Solutions\Desktop"
$dotfile ="\orgchart.dot"
$orgfile = "\orgchart.svg"


$DOTpath =$path+$dotfile
$ORGpath =$path+$orgfile

#array of names to ignore
$ignore = @("Blue Desk", "Bot", "Canary Bot", "Help", "Help Con", "Help Fin", "Help HR", "Help IT", "Help Marketing", "Help Office Admin", "Help Rec", "Help Sec", "Help Solutions", "HelpProp", "HQ Innovation Lab", "HQ Training Room", "HQ Well Room", "innovationlab", "Peerless Admin", "Red Desk", "Yellow Desk")
#path for graphviz dot.exe file
$graphvizPath = "C:\Program Files\Graphviz\bin\dot.exe"




#connect to azure AD (will prompt you sometimes it hides the window behind other things)
Connect-AzureAD

#grab a list of all memebers
$users = Get-AzureADUser -All $true | where-object {$_.UserType -eq 'Member'}

#create a stringbuilder object
$sb = new-object System.Text.StringBuilder

#setup the header of the .dot graphviz file
$sb.AppendLine("digraph{")
$sb.AppendLine("    layout = dot;")
$sb.AppendLine("    ranksep=1.9;")

#loop through each user 
foreach ($user in $users) {
   
    #checks to see if user is on the ignore list
     if(!$ignore.Contains($user.DisplayName) )  {
        
        #gets the manager for each user
        $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
    
        #checks if the manager is null also replaces any spaces in the name
        if($null -eq $manager.DisplayName) 
        {
            $sb.AppendLine(  "None -> " + $user.DisplayName.replace(" ","_") )
        }else {
            $sb.AppendLine( $manager.DisplayName.replace(" ","_")+ " -> "+ $user.DisplayName.replace(" ","_") )
        }
    }
}
    
$sb.AppendLine("}")

#Cleanup  no space, no ., no ',
$sb = $sb.Replace(".","")
$sb = $sb.Replace("'","")

$sb.ToString() | Out-File $DOTpath


#will add code to run graphviz dot.exe natively here
#dot -Tpng input.dot > output.png
#dot -Tps filename.dot -o outfile.ps
cmd.exe /c C:\Program Files\Graphviz\bin\dot.exe -Tsvg $DOTpath -o $ORGpath