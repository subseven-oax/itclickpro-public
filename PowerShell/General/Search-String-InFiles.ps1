# This script search one or many strings in the contents of one or many files, the results will show the full path of the file, the line where the string was found, and what string was found
# Replace string-1, string-2, etc. with the strings to search

$searchWords = @('string-1','string-2','string-x')

Foreach ($sw in $searchWords)
{
    # You can also use the -include parameter to only search in specific type of files, see example below: 
    # Example:  Get-Childitem -Path "C:\Full_path\" -Recurse -include "*.txt","*.xml","*.properties" | 

    Get-Childitem -Path "C:\Full_path\" -Recurse -include "*.*" | 
    Select-String -Pattern "$sw" | 
    Select Path,LineNumber,@{n='SearchWord';e={$sw}}
}