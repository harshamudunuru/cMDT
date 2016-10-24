
#region Variables
#$scriptPath = '.\ScriptToTest.ps1'
#$configDataPath = '.\ConfigDataToTest.psd1'

#$lineNumber = 0
#$ScriptContent = Get-Content $scriptPath
#$ScriptContentRaw = Get-Content $scriptPath -Raw
$Rules = Get-ScriptAnalyzerRule

#endregion


$modules = Get-ChildItem -Path $PSScriptRoot\..\src\DSCResources -Recurse -Include @('*.psm1','*.ps1')
$modules += Get-ChildItem -Path $PSScriptRoot\..\src\Public -Recurse -Include @('*.psm1','*.ps1')

#
#$sw = [System.Diagnostics.Stopwatch]::StartNew()
Describe 'Testing that the script complies with the script analyzer rules' {    
    foreach ($module in $modules) {
        foreach ($rule in $rules) {            
            It "$($module.Name) Passes the `"$($rule.CommonName)`" validation" {                
                $output = $null
                $results = Invoke-ScriptAnalyzer -Path $module.FullName -IncludeRule $Rule.RuleName
                if ($results.count -eq 1){
                    $output = "$($results.Message) at line $($results.Line)"
                }
                elseif ($results.count -gt 1){
                    foreach ($result in $results)
                    {
                        $output += "$($result.Message) at line $($result.Line)`r`n"
                    }
                }
                $output | should be $null
            }
        }        
    }   
}
#>

Describe 'Testing that script does not contain bad quotationmarks' {
    foreach ($module in $modules) {
        $ScriptContentRaw = Get-Content $module.FullName -Raw
        It "$($module.Name) Does not contain ‘" {
            $ScriptContentRaw -match "‘" | Should Be $false
        }
        It "$($module.Name) Does not contain ’" {
            $ScriptContentRaw -match "’" | Should Be $false
        }
        It "$($module.Name) Does not contain `“" {
            $ScriptContentRaw -match "`“" | Should Be $false
        }
        It "$($module.Name) Does not contain `”" {
            $ScriptContentRaw -match "`”" | Should Be $false
        }        
    }
}

Describe 'Testing that the build script works' {
    
    it "Does not throw an exception" {
        { & $PSScriptRoot\..\Build.ps1 } | Should Not throw
    }
}

#$sw.Stop()
#$sw.Elapsed
<#
foreach ($module in $modules){
        It "$($module.Name) Does not contain ‘" {
        
        }
    }
#>
