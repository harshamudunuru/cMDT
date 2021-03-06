#region Variables

$Rules = Get-ScriptAnalyzerRule | Where-Object RuleName -NotIn @('PSDSCDscExamplesPresent','PSDSCDscTestsPresent','PSUseShouldProcessForStateChangingFunctions','PSShouldProcess')

#endregion

$modules = Get-ChildItem -Path $PSScriptRoot\..\src\DSCResources -Recurse -Include @('*.psm1','*.ps1')
$modules += Get-ChildItem -Path $PSScriptRoot\..\src\Public -Recurse -Include @('*.psm1','*.ps1')

Describe 'Script analyzer rule: ' {    
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

Describe 'Testing for bad quotationmarks: ' {
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
