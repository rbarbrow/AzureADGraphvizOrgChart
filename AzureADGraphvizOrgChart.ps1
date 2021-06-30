

#set path of saved .dot file
$path = "C:\Users\rbarbrow\OneDrive - Markon Solutions\Desktop\"


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
    #gets the manager for each user
    $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
    
    #checks if the manager is null also replaces any spaces in the name
    if($null -eq $manager.DisplayName) 
    {
        $sb.AppendLine( $user.DisplayName.replace(" ","_")+ " ->  None" )
    }else {
        $sb.AppendLine( $user.DisplayName.replace(" ","_")+ " -> "+ $manager.DisplayName.replace(" ","_"))
     }
}    
#setup termination for the .dot graphviz file
$sb.AppendLine("}")

#Cleanup  no space no . no '
$sb = $sb.Replace(".","")
$sb = $sb.Replace("'","")

$sb.ToString() | Out-File $path\orgchart.dot

#will add code to run graphviz dot.exe natively here