param( 
    [Parameter(ValueFromPipeline=$true)] 
    [string] $Url 
)
$request = [System.Net.WebRequest]::Create( $Url ) 
$headers = $request.GetResponse().Headers 
$headers.AllKeys | 
     Select-Object @{ Name = "Key"; Expression = { $_ }}, 
     @{ Name = "Value"; Expression = { $headers.GetValues( $_ ) } }

