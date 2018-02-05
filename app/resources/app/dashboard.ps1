Start-UDDashboard -Port 8001 -Dashboard (
    New-UDDashboard -Title "Chuck Norris Jokes" -Content {
        New-UDRow  -Columns {
            New-UDColumn -Size 12 -Endpoint {
                $Joke = Invoke-RestMethod http://api.icndb.com/jokes/random
    
                New-UDCard -Title "Joke #$($Joke.value.id)" -Text $Joke.value.joke
            } -AutoRefresh -RefreshInterval 5
        }
    }
  )  -Wait 