# AzureADGraphvizOrgChart



You can install graphviz using the windows command "winget install graphviz"

I recommend you install the "grapviz preview" extention for vscode "efanzh.graphviz-preview"

be sure to add the path for dot.exe to your enviormental variables in windows. The defualt path is "C:\Program Files\Graphviz\bin\"


pre req
PS Command: Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
PS Command: Install-Module -Name AzureAD
Windows config: add new enviromental variable to PATH  "C:\Program Files\Graphviz\bin\" (without quotes)
VS CODE: add extention "Grapviz Preview"


edit:

added code to run graphviz via commandline